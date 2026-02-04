class RegisterModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String address;
  final String city;
  final String state;
  final String country;
  final String pinCode;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RegisterModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.pinCode,
    this.profileImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      pinCode: json['pin_code'] ?? '',
      profileImage: json['profile_image'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // 🔹 TO JSON (APP → API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'pin_code': pinCode,
      'profile_image': profileImage,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
  RegisterModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? gender,
    String? address,
    String? city,
    String? state,
    String? country,
    String? pinCode,
    String? profileImage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RegisterModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      pinCode: pinCode ?? this.pinCode,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
