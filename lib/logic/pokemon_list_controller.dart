import 'package:flutter/foundation.dart';

import '../data/pokemon_models.dart';
import '../data/pokemon_repository.dart';

class PokemonListController extends ChangeNotifier {
  PokemonListController(this._repository) {
    loadMore();
  }

  final PokemonRepository _repository;
  final List<PokemonSummary> _all = [];
  String? _nextUrl = PokemonRepository.firstPageUrl;
  String _query = '';

  bool isLoading = false;
  String? error;

  bool get hasMore => _nextUrl != null;
  bool get isFirstLoad => _all.isEmpty && isLoading;

  List<PokemonSummary> get visible {
    if (_query.isEmpty) return _all;
    return _all.where((p) => p.name.contains(_query)).toList();
  }

  void setQuery(String value) {
    _query = value.trim().toLowerCase();
    notifyListeners();
  }

  Future<void> loadMore() async {
    final url = _nextUrl;
    if (isLoading || url == null) return;
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final page = await _repository.fetchPage(url);
      _all.addAll(page.results);
      _nextUrl = page.next;
    } catch (e) {
      error = 'Could not load Pokémon. Check your connection.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
