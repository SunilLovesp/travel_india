import 'package:flutter/material.dart';
import '../models/place.dart';
import '../data/places_data.dart';

class PlacesProvider extends ChangeNotifier {
  final List<Place> _all = allPlaces;

  PlaceCategory? _selectedCategory;
  Season? _selectedSeason;
  String _searchQuery = '';

  PlaceCategory? get selectedCategory => _selectedCategory;
  Season? get selectedSeason => _selectedSeason;
  String get searchQuery => _searchQuery;

  void setCategory(PlaceCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSeason(Season? season) {
    _selectedSeason = season;
    notifyListeners();
  }

  void setSearch(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategory = null;
    _selectedSeason = null;
    _searchQuery = '';
    notifyListeners();
  }

  List<Place> get filteredPlaces {
    return _all.where((p) {
      final matchCat =
          _selectedCategory == null || p.category == _selectedCategory;
      final matchSeason = _selectedSeason == null ||
          p.bestSeasons.contains(_selectedSeason);
      final matchSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery) ||
          p.state.toLowerCase().contains(_searchQuery) ||
          p.tags.any((t) => t.toLowerCase().contains(_searchQuery)) ||
          p.nearestCity.toLowerCase().contains(_searchQuery);
      return matchCat && matchSeason && matchSearch;
    }).toList();
  }

  List<Place> get featuredPlaces =>
      _all.where((p) => p.isFeatured).toList();

  List<Place> get currentSeasonPlaces {
    final season = SeasonExtension.currentSeason();
    return _all.where((p) => p.bestSeasons.contains(season)).take(10).toList();
  }

  List<Place> byCategory(PlaceCategory cat) =>
      _all.where((p) => p.category == cat).toList();

  Place? findById(String id) {
    try {
      return _all.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Place> get allList => _all;
}
