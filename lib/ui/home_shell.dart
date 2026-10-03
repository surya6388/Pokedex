import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/pokemon_repository.dart';
import '../logic/pokemon_list_controller.dart';
import 'favorites_screen.dart';
import 'list_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PokemonListController(PokemonRepository()),
      child: Scaffold(
        body: SafeArea(
          child: IndexedStack(
            index: _index,
            children: const [ListScreen(), FavoritesScreen()],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.catching_pokemon),
              label: 'Pokédex',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_border),
              selectedIcon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
          ],
        ),
      ),
    );
  }
}
