import 'package:cinemapp/infrastructure/datasources/moviedb_datasource.dart';
import 'package:cinemapp/infrastructure/repositories/movie_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// * Provider de solo lectura, es inmutable
final movieRepositoryProvider = Provider((ref) {
  return MovieRepositoryImpl(datasource: MoviedbDatasource());
});
