import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

/// A point on the map, in degrees.
typedef GeoPoint = ({double latitude, double longitude});

/// The device's position, read once when asked. Asks for the permission the
/// first time.
class LocationService {
  const LocationService();

  /// How long to wait for a fix once permission is granted. The time the user
  /// spends on the permission dialog is not counted.
  static const _fixTimeout = Duration(seconds: 3);

  /// The current position, or null without one: location off, permission
  /// refused, or no fix in time. Never throws.
  Future<GeoPoint?> currentPosition() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low,
            timeLimit: _fixTimeout,
          ),
        );
      } catch (_) {
        // No fresh fix in time: the last known one is good enough to sort
        // branches by.
        position = await Geolocator.getLastKnownPosition();
      }
      if (position == null) return null;
      return (latitude: position.latitude, longitude: position.longitude);
    } catch (_) {
      return null;
    }
  }

  /// Straight-line distance between two points, in kilometres.
  static double distanceKm(GeoPoint from, GeoPoint to) =>
      Geolocator.distanceBetween(
        from.latitude,
        from.longitude,
        to.latitude,
        to.longitude,
      ) /
      1000;
}

final locationServiceProvider = Provider<LocationService>(
  (ref) => const LocationService(),
);
