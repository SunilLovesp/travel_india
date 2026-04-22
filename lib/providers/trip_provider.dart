import 'package:flutter/material.dart';
import '../models/trip.dart';

class TripProvider extends ChangeNotifier {
  final List<Trip> _trips = [];

  List<Trip> get trips => List.unmodifiable(_trips);

  void addTrip(Trip trip) {
    _trips.add(trip);
    notifyListeners();
  }

  void removeTrip(String id) {
    _trips.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void updateTrip(Trip updated) {
    final idx = _trips.indexWhere((t) => t.id == updated.id);
    if (idx != -1) {
      _trips[idx] = updated;
      notifyListeners();
    }
  }
}
