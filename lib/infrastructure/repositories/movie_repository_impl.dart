import 'package:cinemapp/domain/entities/movie.dart';
import 'package:cinemapp/domain/datasources/movies_datasource.dart';
import 'package:cinemapp/domain/repositories/movies_repository.dart';

class MovieRepositoryImpl extends MoviesRepository {
  final MovieDatasource datasource;

  MovieRepositoryImpl({required this.datasource});
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    return datasource.getNowPlaying(page: page);
  }

  @override
  Future<List<Movie>> getPopularMovies({int page = 1}) {
    return datasource.getPopularMovies(page: page);
  }

  @override
  Future<List<Movie>> getTopRatedMovies({int page = 1}) {
    return datasource.getTopRatedMovies(page: page);
  }

  @override
  Future<List<Movie>> getUpcomingMovies({int page = 1}) {
    return datasource.getUpcomingMovies(page: page);
  }

  @override
  Future<Movie> getMovieById(String id) {
    return datasource.getMovieById(id);
  }

  @override
  Future<List<Movie>> searchMovies(String query) {
    return datasource.searchMovies(query);
  }
}
