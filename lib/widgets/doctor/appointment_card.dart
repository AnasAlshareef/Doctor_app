import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:doctor_appointment_manager/models/appointment_model.dart';
import 'package:doctor_appointment_manager/config/theme.dart';
import 'package:doctor_appointment_manager/config/animations.dart';

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
    return AppAnimations.pulse(
      Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 3,
        shadowColor: AppTheme.shadowColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
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
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    _buildStatusChip(context),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, size: 18, color: AppTheme.primaryColor),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat('EEEE, MMM d, yyyy').format(appointment.appointmentTime),
                        style: TextStyle(fontSize: 14, color: AppTheme.textColor),
                      ),
                      const Spacer(),
                      Icon(Icons.access_time, size: 18, color: AppTheme.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('h:mm a').format(appointment.appointmentTime),
                        style: TextStyle(fontSize: 14, color: AppTheme.textColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (appointment.status == 'scheduled')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: ElevatedButton.icon(
                          onPressed: () => onStatusChange('completed'),
                          icon: const Icon(Icons.check, size: 18),
                          label: const Text('Complete'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.successColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            textStyle: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: ElevatedButton.icon(
                          onPressed: () => onStatusChange('cancelled'),
                          icon: const Icon(Icons.cancel, size: 18),
                          label: const Text('Cancel'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.errorColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            textStyle: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
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