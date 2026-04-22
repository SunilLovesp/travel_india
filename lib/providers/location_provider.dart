import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/place.dart';
import '../services/location_service.dart';

enum LocationStatus { initial, loading, granted, denied }

class LocationProvider extends ChangeNotifier {
  final LocationService _service = LocationService();
  Position? _position;
  LocationStatus _status = LocationStatus.initial;

  Position? get position => _position;
  LocationStatus get status => _status;

  Future<void> fetchLocation() async {
    _status = LocationStatus.loading;
    notifyListeners();

    final pos = await _service.getCurrentPosition();
    if (pos != null) {
      _position = pos;
      _status = LocationStatus.granted;
    } else {
      _status = LocationStatus.denied;
    }
    notifyListeners();
  }

  List<Place> nearbyPlaces(List<Place> all, {double radiusKm = 500}) {
    if (_position == null) return [];
    final lat = _position!.latitude;
    final lng = _position!.longitude;
    return all
        .where((p) => p.distanceFrom(lat, lng) <= radiusKm)
        .toList()
      ..sort((a, b) =>
          a.distanceFrom(lat, lng).compareTo(b.distanceFrom(lat, lng)));
  }

  double? distanceTo(Place p) {
    if (_position == null) return null;
    return p.distanceFrom(_position!.latitude, _position!.longitude);
  }
}
