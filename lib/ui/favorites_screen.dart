import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/favorites_controller.dart';
import 'widgets/pokemon_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesController>().items;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Favorites',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: favorites.isEmpty
                ? const Center(
                    child: Text('No favorites yet. Tap a heart to add one.'),
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.85,
                        ),
                    itemCount: favorites.length,
                    itemBuilder: (_, i) => PokemonCard(pokemon: favorites[i]),
                  ),
          ),
        ],
      ),
    );
  }
}
