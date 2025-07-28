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
import 'package:doctor_appointment_manager/config/animations.dart';

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
        // Navigate based on user role with animations
        if (authProvider.user?.role == 'doctor') {
          Navigator.of(
            context,
          ).pushReplacement(AppAnimations.slideRight(const DoctorHomeScreen()));
        } else if (authProvider.user?.role == 'patient') {
          Navigator.of(context).pushReplacement(
            AppAnimations.slideRight(const PatientHomeScreen()),
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
                  // padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // AppAnimations.pulse(
                        //   Image.network(
                        //     'https://tse2.mm.bing.net/th/id/OIP.cSgjmqsQ5KmBQQF9qO-8zQHaFq?rs=1&pid=ImgDetMain&o=7&rm=3', // تأكد من إضافة شعار للتطبيق
                        //     height: 120,
                        //   ),
                        // ),
                        // const SizedBox(height: 20),
                        // Text(
                        //   'Doctor Appointment Manager',
                        //   style: Theme.of(context).textTheme.headlineMedium,
                        //   textAlign: TextAlign.center,
                        // ),

                        /*
                        stack
                        children 
                        container with image
                        positioned text


                        */
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                'https://tse2.mm.bing.net/th/id/OIP.cSgjmqsQ5KmBQQF9qO-8zQHaFq?rs=1&pid=ImgDetMain&o=7&rm=3', // تأكد من إضافة شعار للتطبيق
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),

                          // child:  Image.network(
                          //   'https://tse2.mm.bing.net/th/id/OIP.cSgjmqsQ5KmBQQF9qO-8zQHaFq?rs=1&pid=ImgDetMain&o=7&rm=3', // تأكد من إضافة شعار للتطبيق
                          //   height: 120,

                          // ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Text(
                                'Doctor Appointment Manager',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 40),
                              //shader mask 
                              Text(
                                'Login',
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                                textAlign: TextAlign.center,
                              ),
                              CustomTextField(
                                label: 'email',
                                controller: _emailController,
                                obscureText: false,
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Don\'t have an account?'),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder:
                                              (_) => const RegisterScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Register',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        // color:
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
