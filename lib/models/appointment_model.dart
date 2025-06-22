import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final String? id;
  final String doctorId;
  final String patientId;
  final DateTime appointmentTime;
  final String status; // 'scheduled', 'completed', 'cancelled'
  final String? notes;
  final String doctorName;
  final String patientName;

  AppointmentModel({
    this.id,
    required this.doctorId,
    required this.patientId,
    required this.appointmentTime,
    required this.status,
    this.notes,
    required this.doctorName,
    required this.patientName,
  });

  // Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'doctorId': doctorId,
      'patientId': patientId,
      'appointmentTime': Timestamp.fromDate(appointmentTime),
      'status': status,
      'notes': notes,
      'doctorName': doctorName,
      'patientName': patientName,
    };
  }

  // Create from Firestore document
  factory AppointmentModel.fromMap(Map<String, dynamic> map, String id) {
    return AppointmentModel(
      id: id,
      doctorId: map['doctorId'] ?? '',
      patientId: map['patientId'] ?? '',
      appointmentTime: (map['appointmentTime'] as Timestamp).toDate(),
      status: map['status'] ?? 'scheduled',
      notes: map['notes'],
      doctorName: map['doctorName'] ?? '',
      patientName: map['patientName'] ?? '',
    );
  }
}