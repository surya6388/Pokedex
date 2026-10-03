import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/pokemon_list_controller.dart';
import 'widgets/pokemon_card.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      context.read<PokemonListController>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PokemonListController>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Pokédex',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: controller.setQuery,
            decoration: InputDecoration(
              hintText: 'Search Pokémon',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(child: _buildBody(controller)),
        ],
      ),
    );
  }

  Widget _buildBody(PokemonListController controller) {
    if (controller.isFirstLoad) {
      return const Center(child: CircularProgressIndicator());
    }
    if (controller.error != null && controller.visible.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(controller.error!),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: controller.loadMore,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    final items = controller.visible;
    if (items.isEmpty) {
      return const Center(child: Text('No Pokémon match your search.'));
    }
    return GridView.builder(
      controller: _scrollController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: items.length + 1,
      itemBuilder: (context, i) {
        if (i < items.length) return PokemonCard(pokemon: items[i]);
        // Footer: spinner, retry, or nothing.
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error != null) {
          return Center(
            child: TextButton(
              onPressed: controller.loadMore,
              child: const Text('Retry'),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
