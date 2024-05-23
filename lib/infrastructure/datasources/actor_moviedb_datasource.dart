import 'package:cinemapp/config/constants/enviroment.dart';
import 'package:cinemapp/domain/datasources/actors_datasource.dart';
import 'package:cinemapp/domain/entities/actor.dart';
import 'package:cinemapp/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapp/infrastructure/models/moviedb/credits_response.dart';
import 'package:dio/dio.dart';

class ActorMoviedbDatasource extends ActorsDatasource {
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
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    final respAPI = await dio.get('/movie/$movieId/credits');
    final respCastDB = CreditsResponse.fromJson(respAPI.data);
    final actors = respCastDB.cast
        .map((actor) => ActorMapper.castoToEntity(actor))
        .toList();

    return actors;
  }
}
