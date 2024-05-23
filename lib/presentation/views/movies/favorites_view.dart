import 'package:cinemapp/presentation/providers/providers.dart';
import 'package:cinemapp/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {
  bool isLastPage = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadNextPage();
  }

  void loadNextPage() async {
    if (isLoading || isLastPage) return;
    isLoading = true;
    final movies =
        await ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    isLoading = false;

    if (movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final movies = ref.watch(favoriteMoviesProvider).values.toList();

    return movies.isEmpty
        ? const Center(
            child: Text(
              'No tienes películas favoritas, vaya tela',
              style: TextStyle(fontSize: 46, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          )
        : Scaffold(
            body: MovieMasonry(
              movies: movies,
              loadNextPage: loadNextPage,
            ),
          );
  }
}
