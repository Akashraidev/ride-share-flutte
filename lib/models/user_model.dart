class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? profileImage;
  final double? rating;
  final int totalRides;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.profileImage,
    this.rating,
    this.totalRides = 0,
  });

  // Convert User to Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'rating': rating,
      'totalRides': totalRides,
    };
  }

  // Create User from Map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      profileImage: json['profileImage'],
      rating: json['rating']?.toDouble(),
      totalRides: json['totalRides'] ?? 0,
    );
  }

  // Create a copy of User with updated fields
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    double? rating,
    int? totalRides,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      rating: rating ?? this.rating,
      totalRides: totalRides ?? this.totalRides,
    );
  }
}