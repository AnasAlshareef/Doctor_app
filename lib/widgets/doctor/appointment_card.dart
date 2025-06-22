import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:doctor_appointment_manager/models/appointment_model.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback onTap;
  final Function(String) onStatusChange;

  const AppointmentCard({
    Key? key,
    required this.appointment,
    required this.onTap,
    required this.onStatusChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Patient: ${appointment.patientName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  _buildStatusChip(context),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('EEEE, MMM d, yyyy').format(appointment.appointmentTime),
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('h:mm a').format(appointment.appointmentTime),
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (appointment.status == 'scheduled')
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => onStatusChange('completed'),
                      child: const Text('Mark Completed'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () => onStatusChange('cancelled'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    Color chipColor;
    String statusText;

    switch (appointment.status) {
      case 'scheduled':
        chipColor = Colors.blue;
        statusText = 'Scheduled';
        break;
      case 'completed':
        chipColor = Colors.green;
        statusText = 'Completed';
        break;
      case 'cancelled':
        chipColor = Colors.red;
        statusText = 'Cancelled';
        break;
      default:
        chipColor = Colors.grey;
        statusText = 'Unknown';
    }

    return Chip(
      label: Text(
        statusText,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: chipColor,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    );
  }
}