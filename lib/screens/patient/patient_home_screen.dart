import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doctor_appointment_manager/models/user_model.dart';
import 'package:doctor_appointment_manager/providers/appointment_provider.dart';
import 'package:doctor_appointment_manager/providers/auth_provider.dart';
import 'package:doctor_appointment_manager/providers/doctor_provider.dart';
import 'package:doctor_appointment_manager/screens/auth/login_screen.dart';
import 'package:doctor_appointment_manager/screens/patient/book_appointment_screen.dart';
import 'package:doctor_appointment_manager/screens/shared/appointment_details_screen.dart';
import 'package:doctor_appointment_manager/services/notification_service.dart';
import 'package:doctor_appointment_manager/widgets/common/loading_indicator.dart';
import 'package:doctor_appointment_manager/widgets/patient/doctor_card.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({Key? key}) : super(key: key);

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Doctors', 'My Appointments'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    final appointmentProvider = Provider.of<AppointmentProvider>(
      context,
      listen: false,
    );

    await doctorProvider.getAllDoctors();

    if (authProvider.user != null) {
      await appointmentProvider.getPatientAppointments(authProvider.user!.uid);
    }
  }

  Future<void> _signOut() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signOut();

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.isLoading) {
      return const Scaffold(body: LoadingIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: const Text('Patient Dashboard'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _signOut),
        ],
        bottom: TabBar(
          labelColor: Colors.white,
          
          controller: _tabController,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
      body:
          authProvider.user == null
              ? const Center(child: Text('Please login to continue'))
              : TabBarView(
                controller: _tabController,
                children: [_buildDoctorsList(), _buildAppointmentsList()],
              ),
    );
  }

  Widget _buildDoctorsList() {
    final doctorProvider = Provider.of<DoctorProvider>(context);

    if (doctorProvider.isLoading) {
      return const LoadingIndicator();
    }

    if (doctorProvider.doctors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.medical_services, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No doctors available',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => doctorProvider.getAllDoctors(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: doctorProvider.doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctorProvider.doctors[index];
          return DoctorCard(
            doctor: doctor,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BookAppointmentScreen(doctor: doctor),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildAppointmentsList() {
    final appointmentProvider = Provider.of<AppointmentProvider>(context);
    final appointments = appointmentProvider.appointments;

    if (appointmentProvider.isLoading) {
      return const LoadingIndicator();
    }

    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.calendar_today, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No appointments',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        return appointmentProvider.getPatientAppointments(
          authProvider.user!.uid,
        );
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                'Dr. ${appointment.doctorName}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        '${appointment.appointmentTime.day}/${appointment.appointmentTime.month}/${appointment.appointmentTime.year}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        '${appointment.appointmentTime.hour}:${appointment.appointmentTime.minute.toString().padLeft(2, '0')}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(appointment.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      appointment.status.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (_) =>
                            AppointmentDetailsScreen(appointment: appointment),
                  ),
                );
              },
              trailing:
                  appointment.status == 'scheduled'
                      ? IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () => _cancelAppointment(appointment.id!),
                      )
                      : null,
            ),
          );
        },
      ),
    );
  }

  Future<void> _cancelAppointment(String appointmentId) async {
    final appointmentProvider = Provider.of<AppointmentProvider>(
      context,
      listen: false,
    );

    bool success = await appointmentProvider.updateAppointmentStatus(
      appointmentId,
      'cancelled',
    );

    if (success && mounted) {
      NotificationService.showSnackBar(
        context,
        'Appointment cancelled successfully',
      );
    } else if (mounted) {
      NotificationService.showSnackBar(
        context,
        appointmentProvider.error ?? 'Failed to cancel appointment',
        isError: true,
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'scheduled':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
