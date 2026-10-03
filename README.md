# Pokédex (Flutter)

## How to run
1. Install the Flutter SDK and run `flutter doctor`.
2. `flutter pub add provider http shared_preferences`
3. `flutter run` (or `flutter run -d chrome`)
4. Before submitting: `dart format .` and `flutter analyze`

## Choices
- **State management: `provider` with `ChangeNotifier`.** `FavoritesController`
  is created once at the app root, so it is the single source of truth. List
  cards, the detail header and the Favorites tab all read from it, so a toggle
  in one place rebuilds the others instantly. Provider is small and enough for
  this app. Riverpod or Bloc would add boilerplate without benefit here.
- **Local storage: `shared_preferences`.** Favorites are a small list of
  `{id, name}`, saved as JSON. Names are stored so the Favorites tab can render
  without a network call. A database such as Hive or Isar would be overkill.
- **Networking:** `http`, behind a `PokemonRepository` so the UI never touches
  the API directly.

## Known limitations / next steps
- List cards use a neutral background (the list API does not return types).
- No offline cache of Pokémon data.
- Colors and spacing approximate the Figma design, not pixel-perfect.
- Would add tests for the controllers and a Riverpod/Bloc comparison.
