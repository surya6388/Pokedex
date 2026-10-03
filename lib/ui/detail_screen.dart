import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/pokemon_models.dart';
import '../data/pokemon_repository.dart';
import '../logic/favorites_controller.dart';
import 'type_colors.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.pokemon});

  final PokemonSummary pokemon;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _repository = PokemonRepository();
  late Future<PokemonDetail> _future;

  @override
  void initState() {
    super.initState();
    _future = _repository.fetchDetail(widget.pokemon.id);
  }

  void _retry() {
    setState(() => _future = _repository.fetchDetail(widget.pokemon.id));
  }

  @override
  Widget build(BuildContext context) {
    final isFav = context.select<FavoritesController, bool>(
      (f) => f.isFavorite(widget.pokemon.id),
    );
    return FutureBuilder<PokemonDetail>(
      future: _future,
      builder: (context, snapshot) {
        final detail = snapshot.data;
        final color =
            detail == null ? Colors.grey : typeColor(detail.types.first);
        return Scaffold(
          backgroundColor: color,
          appBar: AppBar(
            backgroundColor: color,
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                onPressed: () => context
                    .read<FavoritesController>()
                    .toggle(widget.pokemon),
              ),
            ],
          ),
          body: _buildBody(snapshot, color),
        );
      },
    );
  }

  Widget _buildBody(AsyncSnapshot<PokemonDetail> snapshot, Color color) {
    if (snapshot.hasError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Could not load details.',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: _retry, child: const Text('Retry')),
          ],
        ),
      );
    }
    final detail = snapshot.data;
    if (detail == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    return Column(
      children: [
        Text(
          capitalize(detail.summary.name),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          '#${detail.summary.id.toString().padLeft(3, '0')}',
          style: const TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: Image.network(detail.summary.artworkUrl),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: ListView(
              children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  children: [
                    for (final t in detail.types)
                      Chip(
                        label: Text(
                          capitalize(t),
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: typeColor(t),
                        side: BorderSide.none,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _Fact(label: 'Weight', value: '${detail.weightKg} kg'),
                    _Fact(label: 'Height', value: '${detail.heightMeters} m'),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Abilities',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(detail.abilities.map(capitalize).join(', ')),
                const SizedBox(height: 16),
                const Text(
                  'Base stats',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                for (final s in detail.stats) _StatBar(stat: s, color: color),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.black45)),
      ],
    );
  }
}

class _StatBar extends StatelessWidget {
  const _StatBar({required this.stat, required this.color});

  final PokemonStat stat;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(capitalize(stat.name))),
          SizedBox(
            width: 36,
            child: Text(
              '${stat.value}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (stat.value / 255).clamp(0.0, 1.0),
                minHeight: 8,
                color: color,
                backgroundColor: Colors.black12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
