import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment_manager/models/appointment_model.dart';
import 'package:doctor_appointment_manager/models/user_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all doctors
  Future<List<UserModel>> getAllDoctors() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'doctor')
          .get();

      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Create appointment
  Future<String> createAppointment(AppointmentModel appointment) async {
    try {
      DocumentReference docRef = await _firestore.collection('appointments').add(appointment.toMap());
      return docRef.id;
    } catch (e) {
      rethrow;
    }
  }

  // Get doctor appointments
  Future<List<AppointmentModel>> getDoctorAppointments(String doctorId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('appointments')
          .where('doctorId', isEqualTo: doctorId)
          .orderBy('appointmentTime')
          .get();

      return snapshot.docs
          .map((doc) => AppointmentModel.fromMap(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get patient appointments
  Future<List<AppointmentModel>> getPatientAppointments(String patientId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('appointments')
          .where('patientId', isEqualTo: patientId)
          .orderBy('appointmentTime')
          .get();

      return snapshot.docs
          .map((doc) => AppointmentModel.fromMap(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Update appointment status
  Future<void> updateAppointmentStatus(String appointmentId, String status) async {
    try {
      await _firestore.collection('appointments').doc(appointmentId).update({
        'status': status,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Delete appointment
  Future<void> deleteAppointment(String appointmentId) async {
    try {
      await _firestore.collection('appointments').doc(appointmentId).delete();
    } catch (e) {
      rethrow;
    }
  }
}