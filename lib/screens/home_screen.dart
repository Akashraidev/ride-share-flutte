import 'package:flutter/material.dart';
import 'package:go_together/screens/search_results_screen.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../providers/map_provider.dart';
import '../../providers/ride_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/location_search_field.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocation();
    });
  }

  Future<void> _initializeLocation() async {
    final mapProvider = Provider.of<MapProvider>(context, listen: false);
    await mapProvider.getCurrentLocation();
  }

  void _handleSearch() {
    final rideProvider = Provider.of<RideProvider>(context, listen: false);

    if (rideProvider.sourceLocation == null ||
        rideProvider.destinationLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select both source and destination'),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Navigate to search results
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SearchResultsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map-like background (no API needed)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background,
                  AppColors.primary.withOpacity(0.05),
                ],
              ),
            ),
            child: Consumer<MapProvider>(
              builder: (context, mapProvider, _) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map,
                        size: 120,
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),
                      if (mapProvider.currentLocation != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadow,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                mapProvider.currentLocation!.address,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Search overlay
          SafeArea(
            child: Column(
              children: [
                // Search fields container
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Source field (full width)
                      LocationSearchField(
                        label: 'From',
                        icon: Icons.my_location,
                        iconColor: AppColors.mapSourceMarker,
                        onLocationSelected: (location) {
                          Provider.of<RideProvider>(context, listen: false)
                              .setSourceLocation(location);
                        },
                      ),
                      const SizedBox(height: 12),

                      // Destination and Date row
                      Row(
                        children: [
                          // Destination field (70%)
                          Expanded(
                            flex: 7,
                            child: LocationSearchField(
                              label: 'To',
                              icon: Icons.location_on,
                              iconColor: AppColors.mapDestinationMarker,
                              onLocationSelected: (location) {
                                Provider.of<RideProvider>(context,
                                    listen: false)
                                    .setDestinationLocation(location);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Date field (30%)
                          Expanded(
                            flex: 3,
                            child: _buildDateSelector(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Floating search button
          Positioned(
            right: 16,
            bottom: 24,
            child: FloatingActionButton.extended(
              onPressed: _handleSearch,
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.search, color: Colors.white),
              label: const Text(
                'Search',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // My location button
          Positioned(
            right: 16,
            bottom: 100,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: AppColors.surface,
              onPressed: () async {
                final mapProvider =
                Provider.of<MapProvider>(context, listen: false);
                await mapProvider.getCurrentLocation();

                if (mounted && mapProvider.currentLocation != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Location: ${mapProvider.currentLocation!.address}',
                      ),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Icon(
                Icons.my_location,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Consumer<RideProvider>(
      builder: (context, rideProvider, _) {
        final selectedDate = rideProvider.selectedDate;
        final isToday = selectedDate.year == DateTime.now().year &&
            selectedDate.month == DateTime.now().month &&
            selectedDate.day == DateTime.now().day;

        return InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 90)),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: AppColors.primary,
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (picked != null) {
              rideProvider.setSelectedDate(picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isToday ? 'Today' : DateFormat('MMM dd').format(selectedDate),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/*
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocation();
    });
  }

  Future<void> _initializeLocation() async {
    final mapProvider = Provider.of<MapProvider>(context, listen: false);
    await mapProvider.getCurrentLocation();

    if (mapProvider.currentLocation != null) {
      _updateMapLocation(
        mapProvider.currentLocation!.latitude,
        mapProvider.currentLocation!.longitude,
      );
    }
  }

  void _updateMapLocation(double lat, double lng) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(lat, lng),
        12,
      ),
    );
  }

  void _handleSearch() {
    final rideProvider = Provider.of<RideProvider>(context, listen: false);

    if (rideProvider.sourceLocation == null ||
        rideProvider.destinationLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select both source and destination'),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Navigate to search results
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SearchResultsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map background
          Consumer<MapProvider>(
            builder: (context, mapProvider, _) {
              final initialPosition = mapProvider.currentLocation != null
                  ? LatLng(
                mapProvider.currentLocation!.latitude,
                mapProvider.currentLocation!.longitude,
              )
                  : const LatLng(37.7749, -122.4194); // Default San Francisco

              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: initialPosition,
                  zoom: 12,
                ),
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                markers: _markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
              );
            },
          ),

          // Search overlay
          SafeArea(
            child: Column(
              children: [
                // Search fields container
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Source field (full width)
                      LocationSearchField(
                        label: 'From',
                        icon: Icons.my_location,
                        iconColor: AppColors.mapSourceMarker,
                        onLocationSelected: (location) {
                          Provider.of<RideProvider>(context, listen: false)
                              .setSourceLocation(location);
                        },
                      ),
                      const SizedBox(height: 12),

                      // Destination and Date row
                      Row(
                        children: [
                          // Destination field (70%)
                          Expanded(
                            flex: 7,
                            child: LocationSearchField(
                              label: 'To',
                              icon: Icons.location_on,
                              iconColor: AppColors.mapDestinationMarker,
                              onLocationSelected: (location) {
                                Provider.of<RideProvider>(context,
                                    listen: false)
                                    .setDestinationLocation(location);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Date field (30%)
                          Expanded(
                            flex: 3,
                            child: _buildDateSelector(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Floating search button
          Positioned(
            right: 16,
            bottom: 24,
            child: FloatingActionButton.extended(
              onPressed: _handleSearch,
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.search, color: Colors.white),
              label: const Text(
                'Search',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // My location button
          Positioned(
            right: 16,
            bottom: 100,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: AppColors.surface,
              onPressed: () async {
                final mapProvider =
                Provider.of<MapProvider>(context, listen: false);
                await mapProvider.getCurrentLocation();
                if (mapProvider.currentLocation != null) {
                  _updateMapLocation(
                    mapProvider.currentLocation!.latitude,
                    mapProvider.currentLocation!.longitude,
                  );
                }
              },
              child: const Icon(
                Icons.my_location,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Consumer<RideProvider>(
      builder: (context, rideProvider, _) {
        final selectedDate = rideProvider.selectedDate;
        final isToday = selectedDate.year == DateTime.now().year &&
            selectedDate.month == DateTime.now().month &&
            selectedDate.day == DateTime.now().day;

        return InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 90)),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: AppColors.primary,
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (picked != null) {
              rideProvider.setSelectedDate(picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isToday ? 'Today' : DateFormat('MMM dd').format(selectedDate),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}*/
