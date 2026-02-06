class Location {
  final double latitude;
  final double longitude;
  final String address;
  final String? city;
  final String? country;

  Location({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.city,
    this.country,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'city': city,
      'country': country,
    };
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      address: json['address'] ?? '',
      city: json['city'],
      country: json['country'],
    );
  }

  Location copyWith({
    double? latitude,
    double? longitude,
    String? address,
    String? city,
    String? country,
  }) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
    );
  }
}