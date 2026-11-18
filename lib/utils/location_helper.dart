import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class UserAddressData {
  final String village; // Village / Area / Sub-locality
  final String city;    // City / Locality
  final String state;   // State / Region
  final String pincode; // Pincode / Postal Code
  final String fullFormattedAddress; // Full combined address
  final double latitude;
  final double longitude;

  const UserAddressData({
    required this.village,
    required this.city,
    required this.state,
    required this.pincode,
    required this.fullFormattedAddress,
    required this.latitude,
    required this.longitude,
  });
}

class LocationHelper {
  /// Fetches current live position with full permission checks and user notification prompts
  static Future<Position?> getCurrentLiveLocation(BuildContext context) async {
    try {
      // 1. Check if location services (GPS) are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (context.mounted) {
          _showSnackBar(
            context,
            'Location services (GPS) are disabled. Please enable GPS.',
            isSuccess: false,
          );
        }
        await Geolocator.openLocationSettings();
        return null;
      }

      // 2. Check location permission status
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          _showSnackBar(
            context,
            'Requesting Live Location Permission...',
            isSuccess: true,
          );
        }
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (context.mounted) {
            _showSnackBar(
              context,
              'Location permission denied.',
              isSuccess: false,
            );
          }
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (context.mounted) {
          _showLocationSettingsDialog(context);
        }
        return null;
      }

      // 3. Fetch Live Current Position
      if (context.mounted) {
        _showSnackBar(
          context,
          'Fetching live location...',
          isSuccess: true,
        );
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      return position;
    } catch (e) {
      debugPrint('Error getting location: $e');
      if (context.mounted) {
        _showSnackBar(
          context,
          'Failed to get live location. Please try again.',
          isSuccess: false,
        );
      }
      return null;
    }
  }

  /// Fetches live coordinates and converts them into Village, City, State, and Pincode
  static Future<UserAddressData?> fetchLiveAddressDetails(BuildContext context) async {
    Position? position = await getCurrentLiveLocation(context);
    if (position == null) return null;

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        String village = place.subLocality?.isNotEmpty == true
            ? place.subLocality!
            : (place.street?.isNotEmpty == true
                ? place.street!
                : (place.name?.isNotEmpty == true ? place.name! : ''));

        String city = place.locality?.isNotEmpty == true
            ? place.locality!
            : (place.subAdministrativeArea?.isNotEmpty == true
                ? place.subAdministrativeArea!
                : '');

        String state = place.administrativeArea?.isNotEmpty == true
            ? place.administrativeArea!
            : '';

        String pincode = place.postalCode?.isNotEmpty == true ? place.postalCode! : '';

        List<String> parts = [];
        if (village.isNotEmpty) parts.add(village);
        if (city.isNotEmpty) parts.add(city);
        if (state.isNotEmpty) parts.add(state);

        String formatted = parts.join(', ');
        if (pincode.isNotEmpty) formatted += ' - $pincode';

        if (formatted.isEmpty) {
          formatted = 'Lat: ${position.latitude.toStringAsFixed(3)}, Long: ${position.longitude.toStringAsFixed(3)}';
        }

        UserAddressData addressData = UserAddressData(
          village: village.isNotEmpty ? village : 'Current Area',
          city: city.isNotEmpty ? city : 'City',
          state: state.isNotEmpty ? state : 'State',
          pincode: pincode,
          fullFormattedAddress: formatted,
          latitude: position.latitude,
          longitude: position.longitude,
        );

        if (context.mounted) {
          _showSnackBar(
            context,
            'Live Location: $formatted',
            isSuccess: true,
          );
        }

        return addressData;
      }
    } catch (e) {
      debugPrint('Error reverse geocoding: $e');
    }

    // Fallback if reverse geocoding fails
    String fallbackAddr =
        'Live GPS: ${position.latitude.toStringAsFixed(3)}, ${position.longitude.toStringAsFixed(3)}';
    UserAddressData fallbackData = UserAddressData(
      village: 'Area',
      city: 'City',
      state: 'State',
      pincode: '',
      fullFormattedAddress: fallbackAddr,
      latitude: position.latitude,
      longitude: position.longitude,
    );

    if (context.mounted) {
      _showSnackBar(
        context,
        fallbackAddr,
        isSuccess: true,
      );
    }

    return fallbackData;
  }

  /// Listen to real-time live location stream
  static StreamSubscription<Position>? getLiveLocationStream({
    required Function(Position position) onLocationChanged,
    required Function(String error) onError,
  }) {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen(
      (Position position) {
        onLocationChanged(position);
      },
      onError: (e) {
        onError(e.toString());
      },
    );
  }

  static void _showLocationSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.location_off_rounded, color: Color(0xFF3880C9)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Location Permission Required',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
            ],
          ),
          content: const Text(
            'Live location access is required to pinpoint your exact delivery address with Village, City & State. Please enable location permissions in App Settings.',
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                openAppSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3880C9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Open Settings',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  static void _showSnackBar(
    BuildContext context,
    String message, {
    bool isSuccess = true,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.my_location : Icons.location_off_outlined,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: isSuccess ? const Color(0xFF3880C9) : Colors.redAccent,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
