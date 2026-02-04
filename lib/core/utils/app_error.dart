class AppError {
  final String message;
  final int? statusCode;

  AppError(this.message, {this.statusCode});

  static AppError fromException(dynamic error) {
    if (error is NetworkException) {
      return AppError(error.message, statusCode: error.statusCode);
    } else if (error is Exception) {
      return AppError('An unexpected error occurred');
    } else {
      return AppError(error.toString());
    }
  }
}

class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  NetworkException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => message;
}