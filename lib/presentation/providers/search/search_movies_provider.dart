import 'package:cinemapp/domain/entities/movie.dart';
import 'package:cinemapp/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchQueRyProvider = StateProvider<String>((ref) => '');

final searchMoviesProvider =
    StateNotifierProvider<SearchMoviesNotifier, List<Movie>>(
  (ref) {
    final movieRepository = ref.read(movieRepositoryProvider);

    return SearchMoviesNotifier(
        ref: ref, searchMovies: movieRepository.searchMovies);
  },
);

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMoviesNotifier extends StateNotifier<List<Movie>> {
  SearchMoviesCallback searchMovies;
  final Ref ref;
  SearchMoviesNotifier({required this.ref, required this.searchMovies})
      : super([]);

  Future<List<Movie>> serchMovieByQuery(String query) async {
    final List<Movie> movies = await searchMovies(query);
    ref.read(searchQueRyProvider.notifier).update((state) => query);

    state = movies;
    return movies;
  }
}
