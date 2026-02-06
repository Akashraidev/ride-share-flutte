import 'package:flutter/material.dart';

class AppError {
  final String message;
  final String? code;
  final dynamic details;

  AppError({
    required this.message,
    this.code,
    this.details,
  });

  @override
  String toString() {
    return 'AppError: $message${code != null ? ' (Code: $code)' : ''}';
  }

  // Factory constructors for common errors
  factory AppError.network() {
    return AppError(
      message: 'Network error. Please check your connection.',
      code: 'NETWORK_ERROR',
    );
  }

  factory AppError.authentication() {
    return AppError(
      message: 'Authentication failed. Please try again.',
      code: 'AUTH_ERROR',
    );
  }

  factory AppError.validation(String field) {
    return AppError(
      message: 'Please enter a valid $field',
      code: 'VALIDATION_ERROR',
    );
  }

  factory AppError.unknown() {
    return AppError(
      message: 'Something went wrong. Please try again.',
      code: 'UNKNOWN_ERROR',
    );
  }

  factory AppError.locationPermission() {
    return AppError(
      message: 'Location permission denied. Please enable it in settings.',
      code: 'LOCATION_PERMISSION_ERROR',
    );
  }
}

// Error handling utilities
class ErrorHandler {
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static void showInfoSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}