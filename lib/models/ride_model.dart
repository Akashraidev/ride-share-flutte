import 'package:go_together/models/user_model.dart';
import 'location_model.dart';

enum RideStatus {
  scheduled,
  active,
  completed,
  cancelled,
}

class Ride {
  final String id;
  final User driver;
  final Location source;
  final Location destination;
  final DateTime departureTime;
  final int availableSeats;
  final double pricePerSeat;
  final RideStatus status;
  final List<User> passengers;
  final String? vehicleModel;
  final String? vehicleNumber;
  final String? description;

  Ride({
    required this.id,
    required this.driver,
    required this.source,
    required this.destination,
    required this.departureTime,
    required this.availableSeats,
    required this.pricePerSeat,
    this.status = RideStatus.scheduled,
    this.passengers = const [],
    this.vehicleModel,
    this.vehicleNumber,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driver': driver.toJson(),
      'source': source.toJson(),
      'destination': destination.toJson(),
      'departureTime': departureTime.toIso8601String(),
      'availableSeats': availableSeats,
      'pricePerSeat': pricePerSeat,
      'status': status.toString().split('.').last,
      'passengers': passengers.map((p) => p.toJson()).toList(),
      'vehicleModel': vehicleModel,
      'vehicleNumber': vehicleNumber,
      'description': description,
    };
  }

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'] ?? '',
      driver: User.fromJson(json['driver'] ?? {}),
      source: Location.fromJson(json['source'] ?? {}),
      destination: Location.fromJson(json['destination'] ?? {}),
      departureTime: DateTime.parse(json['departureTime']),
      availableSeats: json['availableSeats'] ?? 0,
      pricePerSeat: json['pricePerSeat']?.toDouble() ?? 0.0,
      status: _parseStatus(json['status']),
      passengers: (json['passengers'] as List?)
          ?.map((p) => User.fromJson(p))
          .toList() ??
          [],
      vehicleModel: json['vehicleModel'],
      vehicleNumber: json['vehicleNumber'],
      description: json['description'],
    );
  }

  static RideStatus _parseStatus(String? status) {
    switch (status) {
      case 'active':
        return RideStatus.active;
      case 'completed':
        return RideStatus.completed;
      case 'cancelled':
        return RideStatus.cancelled;
      default:
        return RideStatus.scheduled;
    }
  }

  Ride copyWith({
    String? id,
    User? driver,
    Location? source,
    Location? destination,
    DateTime? departureTime,
    int? availableSeats,
    double? pricePerSeat,
    RideStatus? status,
    List<User>? passengers,
    String? vehicleModel,
    String? vehicleNumber,
    String? description,
  }) {
    return Ride(
      id: id ?? this.id,
      driver: driver ?? this.driver,
      source: source ?? this.source,
      destination: destination ?? this.destination,
      departureTime: departureTime ?? this.departureTime,
      availableSeats: availableSeats ?? this.availableSeats,
      pricePerSeat: pricePerSeat ?? this.pricePerSeat,
      status: status ?? this.status,
      passengers: passengers ?? this.passengers,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      description: description ?? this.description,
    );
  }
}