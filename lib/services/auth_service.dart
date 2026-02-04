import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/utils/app_error.dart';

class AuthService {
  static const String baseUrl = 'BASE_URL';
  Future<Map<String, String>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'accessToken': data['access_token'],
        };
      } else if (response.statusCode == 400) {
        throw AuthException('Invalid email or password');
      } else {
        throw NetworkException(
          'Login failed',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is AuthException || e is NetworkException) rethrow;
      throw NetworkException('Network error: ${e.toString()}');
    }
  }

  Future<Map<String, String>> register(
      String email, String phone, String name) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
          'gender': '',
          'address': '',
          'city': '',
          'state': '',
          'country': '',
          'pin_code': '',
          'profile_image': '',
          'created_at': '',
          'updated_at': '',
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'accessToken': data['access_token'],
        };
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        throw AuthException(data['message'] ?? 'Registration failed');
      } else {
        throw NetworkException(
          'Registration failed',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is AuthException || e is NetworkException) rethrow;
      throw NetworkException('Network error: ${e.toString()}');
    }
  }

}