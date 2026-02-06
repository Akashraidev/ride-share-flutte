import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../core/utils/app_error.dart';
import '../models/location_model.dart';

class MapProvider extends ChangeNotifier {
  Location? _currentLocation;
  bool _isLoading = false;
  AppError? _error;
  bool _locationPermissionGranted = false;

  Location? get currentLocation => _currentLocation;
  bool get isLoading => _isLoading;
  AppError? get error => _error;
  bool get locationPermissionGranted => _locationPermissionGranted;

  // Get current location
  Future<void> getCurrentLocation() async {
    try {
      _setLoading(true);
      _clearError();

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw AppError(
          message: 'Location services are disabled. Please enable them.',
          code: 'LOCATION_SERVICE_DISABLED',
        );
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw AppError.locationPermission();
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw AppError(
          message:
          'Location permissions are permanently denied. Please enable them in settings.',
          code: 'LOCATION_PERMISSION_DENIED_FOREVER',
        );
      }

      _locationPermissionGranted = true;

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _currentLocation = Location(
        latitude: position.latitude,
        longitude: position.longitude,
        address: 'Current Location', // In real app, use reverse geocoding
      );

      _setLoading(false);
    } catch (e) {
      _setError(e is AppError ? e : AppError.unknown());
      _setLoading(false);
    }
  }

  // Search location by text (mock implementation)
  Future<List<Location>> searchLocation(String query) async {
    try {
      _clearError();

      if (query.isEmpty) {
        return [];
      }

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock search results
      return _generateMockLocations(query);
    } catch (e) {
      _setError(e is AppError ? e : AppError.unknown());
      return [];
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

  // Generate mock location search results
  List<Location> _generateMockLocations(String query) {
    final locations = [
      Location(
        latitude: 40.7128,
        longitude: -74.0060,
        address: 'New York, NY, USA',
        city: 'New York',
        country: 'USA',
      ),
      Location(
        latitude: 34.0522,
        longitude: -118.2437,
        address: 'Los Angeles, CA, USA',
        city: 'Los Angeles',
        country: 'USA',
      ),
      Location(
        latitude: 41.8781,
        longitude: -87.6298,
        address: 'Chicago, IL, USA',
        city: 'Chicago',
        country: 'USA',
      ),
      Location(
        latitude: 29.7604,
        longitude: -95.3698,
        address: 'Houston, TX, USA',
        city: 'Houston',
        country: 'USA',
      ),
      Location(
        latitude: 33.4484,
        longitude: -112.0740,
        address: 'Phoenix, AZ, USA',
        city: 'Phoenix',
        country: 'USA',
      ),
    ];

    // Filter based on query
    return locations
        .where((loc) =>
    loc.address.toLowerCase().contains(query.toLowerCase()) ||
        loc.city?.toLowerCase().contains(query.toLowerCase()) == true)
        .toList();
  }

  // Update current location manually
  void setCurrentLocation(Location location) {
    _currentLocation = location;
    notifyListeners();
  }
}