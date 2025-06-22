import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:doctor_appointment_manager/models/appointment_model.dart';
import 'package:doctor_appointment_manager/providers/appointment_provider.dart';
import 'package:doctor_appointment_manager/services/notification_service.dart';
import 'package:doctor_appointment_manager/widgets/common/custom_button.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  final AppointmentModel appointment;

  const AppointmentDetailsScreen({Key? key, required this.appointment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appointmentProvider = Provider.of<AppointmentProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(context),
            const SizedBox(height: 24),
            if (appointment.notes != null && appointment.notes!.isNotEmpty)
              _buildNotesCard(),
            const SizedBox(height: 24),
            if (appointment.status == 'scheduled')
              _buildActionButtons(context, appointmentProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Status', _getStatusText(), _getStatusColor()),
            const Divider(),
            _buildInfoRow('Patient', appointment.patientName),
            const Divider(),
            _buildInfoRow('Doctor', appointment.doctorName),
            const Divider(),
            _buildInfoRow(
              'Date',
              DateFormat('EEEE, MMM d, yyyy').format(appointment.appointmentTime),
            ),
            const Divider(),
            _buildInfoRow(
              'Time',
              DateFormat('h:mm a').format(appointment.appointmentTime),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(appointment.notes ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, AppointmentProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: CustomButton(
            text: 'Complete',
            onPressed: () => _updateStatus(context, provider, 'completed'),
            
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomButton(
            text: 'Cancel',
            onPressed: () => _updateStatus(context, provider, 'cancelled'),
           
          ),
        ),
      ],
    );
  }

  Future<void> _updateStatus(BuildContext context, AppointmentProvider provider, String status) async {
    bool success = await provider.updateAppointmentStatus(appointment.id!, status);

    if (success) {
      NotificationService.showSnackBar(
        context,
        'Appointment ${status.toLowerCase()} successfully',
      );
      Navigator.of(context).pop();
    } else {
      NotificationService.showSnackBar(
        context,
        provider.error ?? 'Failed to update appointment',
        isError: true,
      );
    }
  }

  Widget _buildInfoRow(String title, String value, [Color? valueColor]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: valueColor,
              fontWeight: valueColor != null ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText() {
    switch (appointment.status) {
      case 'scheduled':
        return 'Scheduled';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor() {
    switch (appointment.status) {
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