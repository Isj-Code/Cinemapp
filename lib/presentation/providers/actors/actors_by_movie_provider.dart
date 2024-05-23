import 'package:cinemapp/domain/entities/actor.dart';
import 'package:cinemapp/presentation/providers/actors/actors_respository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorByMovieProvider =
    StateNotifierProvider<ActorsByMovieNotifier, Map<String, List<Actor>>>(
  (ref) {
    final actorRepository = ref.watch(actorsRepositoryProvider);

    return ActorsByMovieNotifier(getActors: actorRepository.getActorsByMovie);
  },
);

typedef GetActorsCallback = Future<List<Actor>> Function(String movieId);

class ActorsByMovieNotifier extends StateNotifier<Map<String, List<Actor>>> {
  // Constructor con llamada a super y inicializando un arreglo vacío
  final GetActorsCallback getActors;
  ActorsByMovieNotifier({
    required this.getActors,
  }) : super({});

  Future<void> loadActors(String movieId) async {
    if (state[movieId] != null) return;
    final List<Actor> actors = await getActors(movieId);

    state = {...state, movieId: actors};
  }
}
