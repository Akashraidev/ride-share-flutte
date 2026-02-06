import 'package:flutter/foundation.dart';
import '../core/utils/app_error.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  AppError? _error;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  AppError? get error => _error;

  // Login method
  Future<bool> login(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Validate credentials (mock validation)
      if (email.isEmpty || password.isEmpty) {
        throw AppError.validation('email and password');
      }

      if (!email.contains('@')) {
        throw AppError(
          message: 'Please enter a valid email address',
          code: 'INVALID_EMAIL',
        );
      }

      if (password.length < 6) {
        throw AppError(
          message: 'Password must be at least 6 characters',
          code: 'WEAK_PASSWORD',
        );
      }

      // Mock successful login
      _currentUser = User(
        id: '1',
        name: 'John Doe',
        email: email,
        phone: '+1234567890',
        rating: 4.8,
        totalRides: 25,
      );

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e is AppError ? e : AppError.unknown());
      _setLoading(false);
      return false;
    }
  }

  // Register method
  Future<bool> register(String name, String email, String password) async {
    try {
      _setLoading(true);
      _clearError();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Validate input
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        throw AppError.validation('all fields');
      }

      if (!email.contains('@')) {
        throw AppError(
          message: 'Please enter a valid email address',
          code: 'INVALID_EMAIL',
        );
      }

      if (password.length < 6) {
        throw AppError(
          message: 'Password must be at least 6 characters',
          code: 'WEAK_PASSWORD',
        );
      }

      // Mock successful registration
      _currentUser = User(
        id: '1',
        name: name,
        email: email,
        totalRides: 0,
      );

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e is AppError ? e : AppError.unknown());
      _setLoading(false);
      return false;
    }
  }

  // Logout method
  Future<void> logout() async {
    _currentUser = null;
    _clearError();
    notifyListeners();
  }

  // Helper methods
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(AppError error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  // Update user profile
  void updateUserProfile(User updatedUser) {
    _currentUser = updatedUser;
    notifyListeners();
  }
}