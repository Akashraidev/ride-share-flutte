class SetPasswordModel {
  final String email;
  final String password;
  final String confirmPassword;

  SetPasswordModel({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "confirm_password": confirmPassword,
    };
  }
}
