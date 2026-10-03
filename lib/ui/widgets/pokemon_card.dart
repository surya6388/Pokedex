import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/pokemon_models.dart';
import '../../logic/favorites_controller.dart';
import '../detail_screen.dart';
import '../type_colors.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard({super.key, required this.pokemon});

  final PokemonSummary pokemon;

  @override
  Widget build(BuildContext context) {
    // Rebuilds this card whenever favorites change anywhere in the app.
    final isFav = context.select<FavoritesController, bool>(
      (f) => f.isFavorite(pokemon.id),
    );
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => DetailScreen(pokemon: pokemon),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${pokemon.id.toString().padLeft(3, '0')}',
                    style: const TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>
                        context.read<FavoritesController>().toggle(pokemon),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.black38,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Image.network(
                  pokemon.artworkUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) =>
                      const Icon(Icons.catching_pokemon, size: 48),
                  loadingBuilder: (_, child, progress) => progress == null
                      ? child
                      : const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                ),
              ),
              Text(
                capitalize(pokemon.name),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
