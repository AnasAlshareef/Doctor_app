import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:doctor_appointment_manager/models/appointment_model.dart';
import 'package:doctor_appointment_manager/providers/appointment_provider.dart';
import 'package:doctor_appointment_manager/providers/auth_provider.dart';
import 'package:doctor_appointment_manager/screens/auth/login_screen.dart';
import 'package:doctor_appointment_manager/screens/shared/appointment_details_screen.dart';
import 'package:doctor_appointment_manager/services/notification_service.dart';
import 'package:doctor_appointment_manager/widgets/common/loading_indicator.dart';
import 'package:doctor_appointment_manager/widgets/doctor/appointment_card.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({Key? key}) : super(key: key);

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Upcoming', 'Completed', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _loadAppointments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAppointments() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final appointmentProvider = Provider.of<AppointmentProvider>(context, listen: false);
    
    if (authProvider.user != null) {
      await appointmentProvider.getDoctorAppointments(authProvider.user!.uid);
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

  List<AppointmentModel> _filterAppointments(String status) {
    final appointmentProvider = Provider.of<AppointmentProvider>(context);
    return appointmentProvider.appointments
        .where((appointment) => appointment.status == status)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final appointmentProvider = Provider.of<AppointmentProvider>(context);

    if (authProvider.isLoading) {
      return const Scaffold(body: LoadingIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
      body: authProvider.user == null
          ? const Center(child: Text('Please login to continue'))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildAppointmentList('scheduled'),
                _buildAppointmentList('completed'),
                _buildAppointmentList('cancelled'),
              ],
            ),
    );
  }

  Widget _buildAppointmentList(String status) {
    final appointmentProvider = Provider.of<AppointmentProvider>(context);
    final appointments = _filterAppointments(status);

    if (appointmentProvider.isLoading) {
      return const LoadingIndicator();
    }

    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No ${status.toLowerCase()} appointments',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAppointments,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return AppointmentCard(
            appointment: appointment,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AppointmentDetailsScreen(appointment: appointment),
                ),
              );
            },
            onStatusChange: (newStatus) async {
              bool success = await appointmentProvider.updateAppointmentStatus(
                appointment.id!,
                newStatus,
              );

              if (success && mounted) {
                NotificationService.showSnackBar(
                  context,
                  'Appointment ${newStatus.toLowerCase()} successfully',
                );
              } else if (mounted) {
                NotificationService.showSnackBar(
                  context,
                  appointmentProvider.error ?? 'Failed to update appointment',
                  isError: true,
                );
              }
            },
          );
        },
      ),
    );
  }
}