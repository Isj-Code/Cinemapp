import 'package:cinemapp/domain/entities/actor.dart';
import 'package:cinemapp/domain/entities/movie.dart';
import 'package:cinemapp/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/widgets.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';
  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();

    // * Caché local
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorByMovieProvider.notifier).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];
    final List<Actor>? cast = ref.watch(actorByMovieProvider)[widget.movieId];

    if (movie == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppbar(
            movie: movie,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _MovieDetails(
                movie: movie,
                cast: cast ?? [],
              ),
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}

final isFavoriteProvider = FutureProvider.family.autoDispose(
  (ref, int movieId) {
    final localStorageRepository = ref.watch(localStorageRepositoryProvider);
    return localStorageRepository.isMovieFavorite(movieId);
  },
);

class _CustomSliverAppbar extends ConsumerWidget {
  final Movie movie;
  const _CustomSliverAppbar({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(isFavoriteProvider(movie.id));
    final sizeMQ = MediaQuery.of(context).size;
    return SliverAppBar(
      // title: Text(movie.title),
      expandedHeight: sizeMQ.height * 0.7,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () async {
            // ref.watch(localStorageRepositoryProvider).toogleFavorite(movie);
            await ref
                .read(favoriteMoviesProvider.notifier)
                .toogleFavorite(movie);
            ref.invalidate(isFavoriteProvider(movie.id));
          },
          icon: isFavorite.when(
            data: (isFavorite) => isFavorite
                ? const Icon(Icons.favorite_rounded,
                    color: Colors.red, size: 40)
                : const Icon(Icons.favorite_border_outlined, size: 40),
            error: (_, __) => throw UnimplementedError(),
            loading: () => const CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        const SizedBox(width: 10)
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
              ),
            ),
            const CustomGradient(
              colors: [
                Colors.black54,
                Colors.transparent,
              ],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter,
              stops: [0.1, 0.3],
            )
          ],
        ),
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;
  final List<Actor> cast;
  const _MovieDetails({
    required this.movie,
    required this.cast,
  });

  @override
  Widget build(BuildContext context) {
    final sizeMQ = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // * Imagen
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
                child: Image.network(
                  movie.posterPath,
                  width: sizeMQ.width * 0.3,
                ),
              ),
              const SizedBox(
                width: 10,
              ),

              // * Titulo y sinopsis
              SizedBox(
                width: (sizeMQ.width - 40) * 0.7,
                child: Column(
                  children: [
                    Text(
                      movie.title,
                      style: textStyles.titleLarge,
                    ),
                    Text(
                      movie.overview,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),

        // * Etiquetas género
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: [
              ...movie.genreIds.map(
                (gender) => Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Chip(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    label: Text(gender),
                  ),
                ),
              )
            ],
          ),
        ),
        if (cast.isEmpty) const SizedBox(),

        // * Actores
        Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            height: 300,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              scrollDirection: Axis.horizontal,
              itemCount: cast.length,
              itemBuilder: (context, index) {
                final actor = cast[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: SizedBox(
                    width: 150,
                    height: 180,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            actor.profilePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                          actor.name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 100)
      ],
    );
  }
}
