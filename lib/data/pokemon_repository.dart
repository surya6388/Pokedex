import 'dart:convert';

import 'package:http/http.dart' as http;

import 'pokemon_models.dart';

class PokemonRepository {
  PokemonRepository({http.Client? client}) : _client = client ?? http.Client();

  static const firstPageUrl =
      'https://pokeapi.co/api/v2/pokemon?limit=20&offset=0';
  static const _detailBase = 'https://pokeapi.co/api/v2/pokemon';

  final http.Client _client;

  Future<PokemonPage> fetchPage(String url) async {
    final json = await _get(url);
    return PokemonPage.fromJson(json);
  }

  Future<PokemonDetail> fetchDetail(int id) async {
    final json = await _get('$_detailBase/$id');
    return PokemonDetail.fromJson(json);
  }

  Future<Map<String, dynamic>> _get(String url) async {
    final response = await _client
        .get(Uri.parse(url))
        .timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('Request failed (${response.statusCode})');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
