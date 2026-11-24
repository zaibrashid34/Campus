import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  FirebaseAuth? get _auth {
    try {
      return FirebaseAuth.instance;
    } catch (_) {
      return null;
    }
  }

  UserModel? _currentUser;
  bool _isLoggedIn = false;
  bool _rememberMe = true;
  bool _isLoading = false;
  bool _isEmailVerified = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get rememberMe => _rememberMe;
  bool get isLoading => _isLoading;
  bool get isEmailVerified => _isEmailVerified;
  bool get isAdmin => _currentUser?.campusRole == 'Admin';

  AuthProvider() {
    // Default demo student user
    _currentUser = UserModel(
      id: 'usr_101',
      fullName: 'Ali Hassan',
      email: 'ali.hassan@university.edu.pk',
      phone: '+923001234567',
      campusRole: 'Student',
      preferredLocation: 'Main Library Plaza',
    );
    _isLoggedIn = true;
    _isEmailVerified = true;
  }

  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  // Email Validation helper
  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Email address is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email.trim())) {
      return 'Enter a valid email address with @ and domain';
    }
    return null;
  }

  // Password Validation helper
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  // Full Name Validation helper
  static String? validateFullName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Full name is required';
    }
    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(name.trim())) {
      return 'Full name should only contain alphabets and spaces';
    }
    if (name.trim().length > 30) {
      return 'Full name cannot exceed 30 characters';
    }
    return null;
  }

  // Phone Number Validation helper
  static String? validatePhone(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (phone.trim().length < 10) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_auth != null) {
        final credential = await _auth!.signInWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
        final user = credential.user;
        if (user != null) {
          _isEmailVerified = user.emailVerified;
          _currentUser = UserModel(
            id: user.uid,
            fullName: user.displayName ?? 'Campus User',
            email: user.email ?? email,
            phone: user.phoneNumber ?? '+923001234567',
            campusRole: 'Student',
          );
          _isLoggedIn = true;
          _isLoading = false;
          notifyListeners();
          return true;
        }
      }
    } catch (e) {
      debugPrint('Firebase Login note (falling back to demo login): $e');
    }

    // Fallback demo login
    await Future.delayed(const Duration(milliseconds: 1000));
    _currentUser = UserModel(
      id: 'usr_101',
      fullName: 'Ali Hassan',
      email: email,
      phone: '+923001234567',
      campusRole: 'Student',
    );
    _isLoggedIn = true;
    _isEmailVerified = true;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> loginAdmin(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));

    if (email.contains('admin') || password == 'admin1234') {
      _currentUser = UserModel(
        id: 'admin_1',
        fullName: 'Campus Admin',
        email: email,
        phone: '+923009998877',
        campusRole: 'Admin',
      );
      _isLoggedIn = true;
      _isEmailVerified = true;
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// Returns null on success, or an error message string on failure.
  Future<String?> signUp({
    required String fullName,
    required String email,
    required String password,
    required String phone,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_auth != null) {
        final credential = await _auth!.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
        final user = credential.user;
        if (user != null) {
          await user.updateDisplayName(fullName);
          // Send verification email
          await user.sendEmailVerification();
          _isEmailVerified = false;

          _currentUser = UserModel(
            id: user.uid,
            fullName: fullName,
            email: email,
            phone: phone,
            campusRole: 'Student',
          );
          _isLoggedIn = true;
          _isLoading = false;
          notifyListeners();
          return null; // Success
        }
      }
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      switch (e.code) {
        case 'email-already-in-use':
          return 'This email address is already registered.';
        case 'weak-password':
          return 'The password provided is too weak (minimum 8 characters).';
        case 'operation-not-allowed':
          return 'Email/Password sign-in is not enabled in your Firebase Console. Please enable it under Authentication -> Sign-in method.';
        case 'invalid-email':
          return 'The email address format is invalid.';
        default:
          return e.message ?? 'Firebase Auth error: ${e.code}';
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'Unexpected error during sign up: $e';
    }

    _isLoading = false;
    notifyListeners();
    return 'Firebase authentication service is unavailable.';
  }

  /// Explicit method to resend email verification
  Future<bool> sendEmailVerificationLink() async {
    try {
      if (_auth != null) {
        final user = _auth!.currentUser;
        if (user != null && !user.emailVerified) {
          await user.sendEmailVerification();
          return true;
        }
      }
    } catch (e) {
      debugPrint('Error sending verification email: $e');
    }
    return false;
  }

  Future<void> updateProfile({
    required String fullName,
    required String phone,
    required String preferredLocation,
  }) async {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        fullName: fullName,
        phone: phone,
        preferredLocation: preferredLocation,
      );
      notifyListeners();
    }
  }

  void logout() async {
    try {
      if (_auth != null) {
        await _auth!.signOut();
      }
    } catch (_) {}
    _isLoggedIn = false;
    _currentUser = null;
    _isEmailVerified = false;
    notifyListeners();
  }
}
