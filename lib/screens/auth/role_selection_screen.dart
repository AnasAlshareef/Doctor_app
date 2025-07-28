import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doctor_appointment_manager/providers/auth_provider.dart';
import 'package:doctor_appointment_manager/screens/doctor/doctor_home_screen.dart';
import 'package:doctor_appointment_manager/screens/patient/patient_home_screen.dart';
import 'package:doctor_appointment_manager/services/notification_service.dart';
import 'package:doctor_appointment_manager/widgets/common/custom_button.dart';
import 'package:doctor_appointment_manager/widgets/common/custom_text_field.dart';
import 'package:doctor_appointment_manager/widgets/common/loading_indicator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RoleSelectionScreen extends StatefulWidget {
  final String name;
  final String email;
  final String password;

  const RoleSelectionScreen({
    Key? key,
    required this.name,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String _selectedRole = 'patient';
  final TextEditingController _specializationController = TextEditingController();
  // File? _profileImage;
  // final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _specializationController.dispose();
    super.dispose();
  }

  // Future<void> _pickImage() async {
  //   // final XFile? pickedFile = await _picker.pickImage(
  //   //   source: ImageSource.gallery,
  //   //   maxWidth: 800,
  //   //   maxHeight: 800,
  //   //   imageQuality: 85,
  //   // );

  //   if (pickedFile != null) {
  //     setState(() {
  //       _profileImage = File(pickedFile.path);
  //     });
  //   }
  // }

  Future<void> _completeRegistration() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    bool success = await authProvider.register(
      widget.email,
      widget.password,
      widget.name,
      _selectedRole,
      specialization: _selectedRole == 'doctor' ? _specializationController.text.trim() : null,
      // profileImage: _selectedRole == 'doctor' ? _profileImage : null,
    );

    if (success && mounted) {
      NotificationService.showToast('Registration successful');
      
      // Navigate based on user role
      if (_selectedRole == 'doctor') {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const DoctorHomeScreen()),
          (route) => false,
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const PatientHomeScreen()),
          (route) => false,
        );//********************* */
      }
    } else if (mounted) {
      NotificationService.showSnackBar(
        context,
        authProvider.error ?? 'Registration failed',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Role'),
      ),
      body: SafeArea(
        child: authProvider.isLoading
            ? const LoadingIndicator()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'I am a:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildRoleCard(
                      title: 'Doctor',
                      description: 'I provide medical services and manage appointments',
                      icon: Icons.medical_services,
                      isSelected: _selectedRole == 'doctor',
                      onTap: () => setState(() => _selectedRole = 'doctor'),
                    ),
                    const SizedBox(height: 16),
                    _buildRoleCard(
                      title: 'Patient',
                      description: 'I want to book appointments with doctors',
                      icon: Icons.person,
                      isSelected: _selectedRole == 'patient',
                      onTap: () => setState(() => _selectedRole = 'patient'),
                    ),
                    const SizedBox(height: 24),
                    if (_selectedRole == 'doctor') ...[  
                      // Profile Image Picker
                      Center(
                        child: Column(
                          children: [
                            // GestureDetector(
                            //   onTap: _pickImage,
                            //   child: CircleAvatar(
                            //     radius: 50,
                            //     backgroundColor: Colors.grey[300],
                            //     backgroundImage: _profileImage != null 
                            //         ? FileImage(_profileImage!) 
                            //         : null,
                            //     child: _profileImage == null
                            //         ? const Icon(Icons.add_a_photo, size: 40, color: Colors.grey)
                            //         : null,
                            //   ),
                            // ),
                            // const SizedBox(height: 8),
                            // const Text(
                            //   'Add Profile Photo',
                            //   style: TextStyle(color: Colors.grey),
                            // ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      CustomTextField(
                        label: 'Specialization',
                        controller: _specializationController,
                        prefixIcon: const Icon(Icons.local_hospital),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your specialization';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                    CustomButton(
                      text: 'Complete Registration',
                      onPressed: _completeRegistration,
                      isLoading: authProvider.isLoading,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String description,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: isSelected ? 4 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 40,
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Theme.of(context).primaryColor : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(description),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).primaryColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}