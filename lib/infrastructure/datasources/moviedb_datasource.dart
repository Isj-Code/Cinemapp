import 'package:cinemapp/config/constants/enviroment.dart';
import 'package:cinemapp/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapp/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapp/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';

import 'package:cinemapp/domain/datasources/movies_datasource.dart';
import 'package:cinemapp/domain/entities/movie.dart';

class MoviedbDatasource extends MovieDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Enviroment.theMovieDbKey,
        'language': 'es-Es',
      },
    ),
  );

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final respAPI = await dio.get('/movie/now_playing', queryParameters: {
      'page': page,
    });
    return _jsonToMovie(respAPI.data);
  }

  @override
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    final respAPI =
        await dio.get('/movie/upcoming', queryParameters: {'page': page});

    return _jsonToMovie(respAPI.data);
  }

  @override
  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    final respAPI = await dio.get('/movie/top_rated', queryParameters: {
      'page': page,
    });

    return _jsonToMovie(respAPI.data);
  }

  @override
  Future<List<Movie>> getUpcomingMovies({int page = 1}) async {
    final respAPI = await dio.get('/movie/popular', queryParameters: {
      'page': page,
    });

    return _jsonToMovie(respAPI.data);
  }

  @override
  Future<Movie> getMovieById(String id) async {
    final respAPI = await dio.get('/movie/$id');
    if (respAPI.statusCode != 200) throw Exception('Id not found');
    final movieDB = MovieDetails.fromJson(respAPI.data);
    final movie = MovieMapper.movieDetailToEntity(movieDB);

    return movie;
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) return [];

    final respAPI = await dio.get('/search/movie', queryParameters: {
      'query': query,
      'page': 1,
    });

    return _jsonToMovie(respAPI.data);
  }

  // * Funciona para pasar la respuesta a nuestra entidad
  List<Movie> _jsonToMovie(Map<String, dynamic> json) {
    final movieDbResponse = MovieDbResponse.fromJson(json);
    final List<Movie> movies = movieDbResponse.results
        .where((moviedb) => moviedb.posterPath != '')
        .map((moviedb) => MovieMapper.movieDBToEntity(moviedb))
        .toList();
    return movies;
  }
}
