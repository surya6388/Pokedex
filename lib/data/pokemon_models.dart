/// Minimal info needed to show a Pokémon in a list.
class PokemonSummary {
  const PokemonSummary({required this.id, required this.name});

  factory PokemonSummary.fromListJson(Map<String, dynamic> json) {
    final url = json['url'] as String;
    final segments = url.split('/').where((s) => s.isNotEmpty).toList();
    return PokemonSummary(
      id: int.parse(segments.last),
      name: json['name'] as String,
    );
  }

  factory PokemonSummary.fromJson(Map<String, dynamic> json) =>
      PokemonSummary(id: json['id'] as int, name: json['name'] as String);

  final int id;
  final String name;

  String get artworkUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/'
      'pokemon/other/official-artwork/$id.png';

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class PokemonPage {
  const PokemonPage({required this.results, required this.next});

  factory PokemonPage.fromJson(Map<String, dynamic> json) => PokemonPage(
        results: (json['results'] as List)
            .map((e) => PokemonSummary.fromListJson(e as Map<String, dynamic>))
            .toList(),
        next: json['next'] as String?,
      );

  final List<PokemonSummary> results;
  final String? next;
}

class PokemonStat {
  const PokemonStat({required this.name, required this.value});

  final String name;
  final int value;
}

class PokemonDetail {
  const PokemonDetail({
    required this.summary,
    required this.types,
    required this.heightMeters,
    required this.weightKg,
    required this.abilities,
    required this.stats,
  });

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    return PokemonDetail(
      summary: PokemonSummary.fromJson(json),
      types: (json['types'] as List)
          .map((e) => (e['type'] as Map)['name'] as String)
          .toList(),
      heightMeters: (json['height'] as int) / 10,
      weightKg: (json['weight'] as int) / 10,
      abilities: (json['abilities'] as List)
          .map((e) => (e['ability'] as Map)['name'] as String)
          .toList(),
      stats: (json['stats'] as List)
          .map(
            (e) => PokemonStat(
              name: (e['stat'] as Map)['name'] as String,
              value: e['base_stat'] as int,
            ),
          )
          .toList(),
    );
  }

  final PokemonSummary summary;
  final List<String> types;
  final double heightMeters;
  final double weightKg;
  final List<String> abilities;
  final List<PokemonStat> stats;
}
