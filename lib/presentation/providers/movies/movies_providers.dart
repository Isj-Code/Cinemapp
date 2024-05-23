import 'package:cinemapp/domain/entities/movie.dart';
import 'package:cinemapp/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// * Creamos un NotifierProvider, donde el que gobierna es la clase MoviesNotifier y maneja datos List<Movie>
final nowPlayingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>(
  (ref) {
    final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;
    return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
  },
);

final popularMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>(
  (ref) {
    final fetchMoreMovies = ref.watch(movieRepositoryProvider).getPopularMovies;
    return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
  },
);

final upcomingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>(
  (ref) {
    final fetchMoreMovies =
        ref.watch(movieRepositoryProvider).getUpcomingMovies;
    return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
  },
);

final topRatedMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>(
  (ref) {
    final fetchMoreMovies =
        ref.watch(movieRepositoryProvider).getTopRatedMovies;
    return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
  },
);

typedef MovieCallback = Future<List<Movie>> Function({int page});

// * Clase que gobierna los notifier
class MoviesNotifier extends StateNotifier<List<Movie>> {
  bool isLoading = false;
  int currentPage = 0;
  MovieCallback fetchMoreMovies;

  MoviesNotifier({required this.fetchMoreMovies}) : super([]);

  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;
    currentPage++;

    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    state = [...state, ...movies];
    await Future.delayed(const Duration(seconds: 1));
    isLoading = false;
  }
}
