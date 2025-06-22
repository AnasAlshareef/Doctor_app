import 'package:flutter/material.dart';
import 'package:doctor_appointment_manager/models/user_model.dart';
import 'package:doctor_appointment_manager/services/database_service.dart';

class DoctorProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<UserModel> _doctors = [];
  bool _isLoading = false;
  String? _error;

  List<UserModel> get doctors => _doctors;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get all doctors
  Future<void> getAllDoctors() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _doctors = await _databaseService.getAllDoctors();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Get doctor by ID
  UserModel? getDoctorById(String doctorId) {
    return _doctors.firstWhere((doctor) => doctor.uid == doctorId, orElse: () => null as UserModel);
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}