import 'dart:math';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationUtils {
  final location = Location();
  PermissionStatus _permissionStatus = PermissionStatus.denied;
  bool _isServiceEnabled = false;

  final _citiesCoordinates = <Map<String, dynamic>>[
    {'name': 'São Paulo', 'latitude': -23.533773, 'longitude': -46.625290},
    {'name': 'New York', 'latitude': 40.730610, 'longitude': -73.935242},
    {'name': 'Tokyo', 'latitude': 35.685360, 'longitude': 139.753372},
    {'name': 'Paris', 'latitude': 48.860294, 'longitude': 2.338629}
  ];

  Future<LocationData?> getLocation(BuildContext context) async {
    try {
      final isServiceEnabled = await _checkServiceStatus(context);

      if (!isServiceEnabled) {
        return null;
      }

      final hasPermission = await _checkPermissions(context);

      if (!hasPermission) {
        return null;
      }

      final locationData = await location.getLocation();
      return locationData;
    } catch (_) {
      return null;
    }
  }

  Future<List<double>> getDistanceToCities(BuildContext context) async {
    final currentLocation = await getLocation(context);
    final saoPaulo = LocationData.fromMap(
        _citiesCoordinates.firstWhere((map) => map['name'] == 'São Paulo'));
    final newYork = LocationData.fromMap(
        _citiesCoordinates.firstWhere((map) => map['name'] == 'New York'));
    final tokyo = LocationData.fromMap(
        _citiesCoordinates.firstWhere((map) => map['name'] == 'Tokyo'));
    final paris = LocationData.fromMap(
        _citiesCoordinates.firstWhere((map) => map['name'] == 'Paris'));

    final cities = [
      _calculateDistanceBetweenCoordinatesInKms(currentLocation!, saoPaulo),
      _calculateDistanceBetweenCoordinatesInKms(currentLocation, newYork),
      _calculateDistanceBetweenCoordinatesInKms(currentLocation, tokyo),
      _calculateDistanceBetweenCoordinatesInKms(currentLocation, paris),
    ];

    return cities;
  }

  double _calculateDistanceBetweenCoordinatesInKms(
    LocationData origin,
    LocationData target,
  ) {
    if (origin.latitude == null ||
        origin.longitude == null ||
        target.latitude == null ||
        target.longitude == null) {
      return 0.0;
    }
    const earthRadiusKm = 6371.0;

    final latitudeDistanceInDegrees =
        _degreesToRadians(target.latitude! - origin.latitude!);
    final longitudeDistanceInDegrees =
        _degreesToRadians(target.longitude! - origin.longitude!);

    final originLatitudeDegrees = _degreesToRadians(origin.latitude!);
    final targetLatitudeDegrees = _degreesToRadians(target.latitude!);

    final a = sin(latitudeDistanceInDegrees / 2) *
            sin(latitudeDistanceInDegrees / 2) +
        sin(longitudeDistanceInDegrees / 2) *
            sin(longitudeDistanceInDegrees / 2) *
            cos(originLatitudeDegrees) *
            cos(targetLatitudeDegrees);

    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  Future<bool> _checkServiceStatus(BuildContext context) async {
    _isServiceEnabled = await location.serviceEnabled();

    if (!_isServiceEnabled) {
      _isServiceEnabled = await location.requestService();
    }

    if (!_isServiceEnabled) {
      _showSnackbar(
        'Unable to use location service. Enable location service to use this app.',
        context,
      );
      return false;
    }

    return true;
  }

  Future<bool> _checkPermissions(BuildContext context) async {
    _permissionStatus = await location.hasPermission();

    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await location.requestPermission();
    }

    if (_permissionStatus == PermissionStatus.denied ||
        _permissionStatus == PermissionStatus.deniedForever) {
      _showSnackbar(
        'The app doesn\'t have permission to use this device\'s location. Check the permissions conceded to the app.',
        context,
      );
      return false;
    }

    return true;
  }

  void _showSnackbar(String? message, BuildContext context) {
    if (message == null || message.isEmpty) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
