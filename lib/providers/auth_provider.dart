import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/utils/app_error.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _accessToken;

  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get accessToken => _accessToken;

  Future<void> checkAuth() async {
    _isLoading = true;
    notifyListeners();

    try {
      _accessToken = await _storage.read(key: 'access_token');

      if (_accessToken != null) {
        _isAuthenticated = true;
      }
    } catch (e) {
      _error = 'Failed to check authentication';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final tokens = await _authService.login(email, password);
      await _saveTokens(tokens['accessToken']!);
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } on NetworkException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Register
  Future<bool> register(String email, String phone, String name) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final tokens = await _authService.register(email, phone, name);
      await _saveTokens(tokens['accessToken']!,);
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } on NetworkException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    _accessToken = null;
    _isAuthenticated = false;
    _error = null;
    notifyListeners();
  }

  // Save tokens to secure storage
  Future<void> _saveTokens(String accessToken,) async {
    _accessToken = accessToken;
    await _storage.write(key: 'access_token', value: accessToken);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}