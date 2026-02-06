import 'package:flutter/foundation.dart';
import '../models/location_model.dart';
import '../models/ride_model.dart';
import '../core/utils/app_error.dart';
import '../models/user_model.dart';

class RideProvider extends ChangeNotifier {
  List<Ride> _availableRides = [];
  List<Ride> _userRides = [];
  bool _isLoading = false;
  AppError? _error;

  // Search parameters
  Location? _sourceLocation;
  Location? _destinationLocation;
  DateTime _selectedDate = DateTime.now();

  List<Ride> get availableRides => _availableRides;
  List<Ride> get userRides => _userRides;
  bool get isLoading => _isLoading;
  AppError? get error => _error;
  Location? get sourceLocation => _sourceLocation;
  Location? get destinationLocation => _destinationLocation;
  DateTime get selectedDate => _selectedDate;

  // Set source location
  void setSourceLocation(Location? location) {
    _sourceLocation = location;
    notifyListeners();
  }

  // Set destination location
  void setDestinationLocation(Location? location) {
    _destinationLocation = location;
    notifyListeners();
  }

  // Set selected date
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  // Clear search parameters
  void clearSearch() {
    _sourceLocation = null;
    _destinationLocation = null;
    _selectedDate = DateTime.now();
    notifyListeners();
  }

  // Search for rides
  Future<void> searchRides() async {
    if (_sourceLocation == null || _destinationLocation == null) {
      _setError(AppError(
        message: 'Please select both source and destination',
        code: 'MISSING_LOCATION',
      ));
      return;
    }

    try {
      _setLoading(true);
      _clearError();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock data - generate sample rides
      _availableRides = _generateMockRides();

      _setLoading(false);
    } catch (e) {
      _setError(e is AppError ? e : AppError.unknown());
      _setLoading(false);
    }
  }

  // Get user's rides
  Future<void> fetchUserRides(String userId) async {
    try {
      _setLoading(true);
      _clearError();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data
      _userRides = _generateMockUserRides(userId);

      _setLoading(false);
    } catch (e) {
      _setError(e is AppError ? e : AppError.unknown());
      _setLoading(false);
    }
  }

  // Book a ride
  Future<bool> bookRide(String rideId, String userId) async {
    try {
      _setLoading(true);
      _clearError();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock booking - add to user rides
      final ride = _availableRides.firstWhere((r) => r.id == rideId);
      _userRides.add(ride);

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e is AppError ? e : AppError.unknown());
      _setLoading(false);
      return false;
    }
  }

  // Create a ride (offer a ride)
  Future<bool> createRide(Ride ride) async {
    try {
      _setLoading(true);
      _clearError();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _userRides.add(ride);

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e is AppError ? e : AppError.unknown());
      _setLoading(false);
      return false;
    }
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

  // Generate mock rides for demonstration
  List<Ride> _generateMockRides() {
    return List.generate(5, (index) {
      return Ride(
        id: 'ride_$index',
        driver: User(
          id: 'driver_$index',
          name: 'Driver ${index + 1}',
          email: 'driver$index@example.com',
          rating: 4.0 + (index * 0.15),
          totalRides: 10 + (index * 5),
        ),
        source: _sourceLocation!,
        destination: _destinationLocation!,
        departureTime: _selectedDate.add(Duration(hours: index + 1)),
        availableSeats: 3 - index % 3,
        pricePerSeat: 10.0 + (index * 2.5),
        vehicleModel: 'Honda Civic',
        vehicleNumber: 'ABC${1234 + index}',
        description: 'Comfortable ride with AC',
      );
    });
  }

  List<Ride> _generateMockUserRides(String userId) {
    return List.generate(2, (index) {
      return Ride(
        id: 'user_ride_$index',
        driver: User(
          id: 'driver_user_$index',
          name: 'Driver ${index + 1}',
          email: 'driver$index@example.com',
          rating: 4.5,
          totalRides: 20,
        ),
        source: Location(
          latitude: 40.7128,
          longitude: -74.0060,
          address: 'New York, NY',
        ),
        destination: Location(
          latitude: 42.3601,
          longitude: -71.0589,
          address: 'Boston, MA',
        ),
        departureTime: DateTime.now().add(Duration(days: index + 1)),
        availableSeats: 2,
        pricePerSeat: 25.0,
        status: index == 0 ? RideStatus.scheduled : RideStatus.completed,
        vehicleModel: 'Toyota Camry',
        vehicleNumber: 'XYZ${5678 + index}',
      );
    });
  }
}