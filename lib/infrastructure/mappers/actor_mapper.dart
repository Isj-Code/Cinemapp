import 'package:cinemapp/domain/entities/actor.dart';
import 'package:cinemapp/infrastructure/models/moviedb/credits_response.dart';

class ActorMapper {
  static Actor castoToEntity(Cast cast) => Actor(
        name: cast.name,
        id: cast.id,
        profilePath: cast.profilePath != null
            ? 'https://image.tmdb.org/t/p/w500${cast.profilePath}'
            : 'https://upload.wikimedia.org/wikipedia/commons/3/37/No_person.jpg?20060716213357',
        character: cast.character,
      );
}
