import 'package:cinemapp/domain/entities/movie.dart';

abstract class LocalStorageRepository {
  Future<void> toogleFavorite(Movie movie);
  Future<bool> isMovieFavorite(int movieId);
  Future<List<Movie>> loadMovies({int limit = 14, offset = 0});
}
