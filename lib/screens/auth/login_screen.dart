import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doctor_appointment_manager/providers/auth_provider.dart';
import 'package:doctor_appointment_manager/screens/auth/register_screen.dart';
import 'package:doctor_appointment_manager/screens/doctor/doctor_home_screen.dart';
import 'package:doctor_appointment_manager/screens/patient/patient_home_screen.dart';
import 'package:doctor_appointment_manager/services/notification_service.dart';
import 'package:doctor_appointment_manager/widgets/common/custom_button.dart';
import 'package:doctor_appointment_manager/widgets/common/custom_text_field.dart';
import 'package:doctor_appointment_manager/widgets/common/loading_indicator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      bool success = await authProvider.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (success && mounted) {
        // Navigate based on user role
        if (authProvider.user?.role == 'doctor') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DoctorHomeScreen()),
          );
          print('Doctor logged in: ${authProvider.user?.role}');
        } else if (authProvider.user?.role == 'patient') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const PatientHomeScreen()),
          );
        }
      } else if (mounted) {
        NotificationService.showSnackBar(
          context,
          authProvider.error ?? 'Login failed',
          isError: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child:
            authProvider.isLoading
                ? const LoadingIndicator()
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 60),
                        const Text(
                          'Doctor Appointment Manager',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        CustomTextField(
                          label: 'Email',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: const Icon(Icons.email),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: 'Password',
                          controller: _passwordController,
                          obscureText: true,
                          prefixIcon: const Icon(Icons.lock),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        CustomButton(
                          text: 'Login',
                          onPressed: _login,
                          isLoading: authProvider.isLoading,
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text('Don\'t have an account? Register'),
                        ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
