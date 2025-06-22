import 'package:flutter/material.dart';
import 'package:doctor_appointment_manager/models/appointment_model.dart';
import 'package:doctor_appointment_manager/services/database_service.dart';

class AppointmentProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<AppointmentModel> _appointments = [];
  bool _isLoading = false;
  String? _error;

  List<AppointmentModel> get appointments => _appointments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get doctor appointments
  Future<void> getDoctorAppointments(String doctorId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _appointments = await _databaseService.getDoctorAppointments(doctorId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Get patient appointments
  Future<void> getPatientAppointments(String patientId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _appointments = await _databaseService.getPatientAppointments(patientId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Create appointment
  Future<bool> createAppointment(AppointmentModel appointment) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      String appointmentId = await _databaseService.createAppointment(appointment);
      AppointmentModel newAppointment = AppointmentModel(
        id: appointmentId,
        doctorId: appointment.doctorId,
        patientId: appointment.patientId,
        appointmentTime: appointment.appointmentTime,
        status: appointment.status,
        notes: appointment.notes,
        doctorName: appointment.doctorName,
        patientName: appointment.patientName,
      );
      _appointments.add(newAppointment);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Update appointment status
  Future<bool> updateAppointmentStatus(String appointmentId, String status) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _databaseService.updateAppointmentStatus(appointmentId, status);
      
      int index = _appointments.indexWhere((appointment) => appointment.id == appointmentId);
      if (index != -1) {
        AppointmentModel updatedAppointment = AppointmentModel(
          id: _appointments[index].id,
          doctorId: _appointments[index].doctorId,
          patientId: _appointments[index].patientId,
          appointmentTime: _appointments[index].appointmentTime,
          status: status,
          notes: _appointments[index].notes,
          doctorName: _appointments[index].doctorName,
          patientName: _appointments[index].patientName,
        );
        _appointments[index] = updatedAppointment;
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Delete appointment
  Future<bool> deleteAppointment(String appointmentId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _databaseService.deleteAppointment(appointmentId);
      _appointments.removeWhere((appointment) => appointment.id == appointmentId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}