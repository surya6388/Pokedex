import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/pokemon_models.dart';

/// The single source of truth for favorites. Every screen reads from here
/// via Provider, so a toggle anywhere rebuilds every listening widget.
class FavoritesController extends ChangeNotifier {
  FavoritesController(this._prefs) {
    _load();
  }

  static const _storageKey = 'favorites_v1';

  final SharedPreferences _prefs;
  final Map<int, PokemonSummary> _items = {};

  List<PokemonSummary> get items =>
      _items.values.toList()..sort((a, b) => a.id.compareTo(b.id));

  bool isFavorite(int id) => _items.containsKey(id);

  Future<void> toggle(PokemonSummary pokemon) async {
    if (_items.remove(pokemon.id) == null) {
      _items[pokemon.id] = pokemon;
    }
    notifyListeners(); // UI updates immediately, saving happens after.
    await _save();
  }

  void _load() {
    final raw = _prefs.getString(_storageKey);
    if (raw == null) return;
    try {
      for (final e in jsonDecode(raw) as List) {
        final p = PokemonSummary.fromJson(e as Map<String, dynamic>);
        _items[p.id] = p;
      }
    } catch (_) {
      _items.clear(); // Corrupt data: start fresh.
    }
  }

  Future<void> _save() => _prefs.setString(
        _storageKey,
        jsonEncode(_items.values.map((p) => p.toJson()).toList()),
      );
}
