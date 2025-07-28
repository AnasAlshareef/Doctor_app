import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:doctor_appointment_manager/models/user_model.dart';
import 'package:doctor_appointment_manager/services/auth_service.dart';
import 'dart:io';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  // Initialize user data
  Future<void> initializeUser() async {
    if (_authService.currentUser != null) {
      await getUserData();
    }
  }

  // Sign in with email and password
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      UserCredential userCredential = await _authService
          .signInWithEmailAndPassword(email, password);
      await getUserData();
      _isLoading = false;
      notifyListeners();
      print('User signed in: ${_user?.email}, Role: ${_user?.role}');
      return true;
    } catch (e, stackTrace) {
      _isLoading = false;
      _error = e.toString();
      debugPrint('❌ Error during sign-in: $e');
      debugPrint('📍 Stack trace:\n$stackTrace');
      notifyListeners();
      return false;
    }
  }

  // Register with email and password
  Future<bool> register(
    String email,
    String password,
    String name,
    String role, {
    String? specialization,
    File? profileImage,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      UserCredential userCredential = await _authService
          .registerWithEmailAndPassword(email, password);
      
      // Upload profile image if provided
      // String? photoUrl;
      // if (profileImage != null) {
      //   photoUrl = await _authService.uploadProfileImage(
      //     profileImage, 
      //     userCredential.user!.uid
      //   );
      // }

      UserModel newUser = UserModel(
        uid: userCredential.user!.uid,
        email: email,
        name: name,
        role: role,
        specialization: specialization,
        // photoUrl: photoUrl,
      );

      await _authService.createUserInFirestore(newUser);
      _user = newUser;
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

  // Get user data
  Future<void> getUserData() async {
    _isLoading = true;
    notifyListeners();

    try {
      User? currentUser = _authService.currentUser;
      if (currentUser != null) {
        UserModel? userData = await _authService.getUserData(currentUser.uid);
        _user = userData;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Sign out
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signOut();
      _user = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
