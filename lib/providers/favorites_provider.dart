import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  static const _key = 'favorites';
  Set<String> _ids = {};

  Set<String> get ids => _ids;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _ids = Set.from(prefs.getStringList(_key) ?? []);
    notifyListeners();
  }

  Future<void> toggle(String id) async {
    if (_ids.contains(id)) {
      _ids.remove(id);
    } else {
      _ids.add(id);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _ids.toList());
  }

  bool isFavorite(String id) => _ids.contains(id);
}
