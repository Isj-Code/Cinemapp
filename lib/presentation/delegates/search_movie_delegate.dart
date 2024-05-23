import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapp/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMovieCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMovieCallback searchMovie;
  // * Propiedades para controlar el stream
  final List<Movie> initialMovies;
  StreamController<List<Movie>> debounceMovies = StreamController.broadcast();
  Timer? _debounceTimer;

  SearchMovieDelegate({
    required this.searchMovie,
    required this.initialMovies,
  });

  void _onQueryChange(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(
      const Duration(milliseconds: 200),
      () async {
        // if (query.isEmpty) {
        //   debounceMovies.add([]);
        //   return;
        // }
        final movies = await searchMovie(query);
        debounceMovies.add(movies);
      },
    );
  }

  void clearStreams() {
    debounceMovies.close();
  }

  // * Búsqueda de películas
  @override
  String get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      // if(query.isNotEmpty) // * Con el paquete de animateDo se puede obviar gracias a la propiedad animate.
      FadeIn(
        animate: query.isNotEmpty,
        duration: const Duration(milliseconds: 200),
        child: IconButton(
          onPressed: () => query = '',
          icon: const Icon(Icons.clear_outlined),
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        clearStreams();
        close(context, null);
      }, // * El null es para no tener seleccionada ninguna película
      icon: const Icon(Icons.arrow_back_ios_new),
    );
  }

//* Se podría hacer un widget para manejar tanto las sugerencias como resultados

  @override
  Widget buildResults(BuildContext context) {
    _onQueryChange(query);

    return StreamBuilder(
      stream: debounceMovies.stream,
      // future: searchMovie(query),
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) => _MovieSearchItem(
            movie: movies[index],
            onMovieSelected: (context, movie) {
              clearStreams();
              close(context, movie);
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChange(query);
    // * Cambiamos el Future por el stream del StreamBuilder para poder controlar el debounce y no haga una petición en cada pulsación
    return StreamBuilder(
      initialData: initialMovies,
      stream: debounceMovies.stream,
      // future: searchMovie(query),
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) => _MovieSearchItem(
            movie: movies[index],
            onMovieSelected: (context, movie) {
              clearStreams();
              close(context, movie);
            },
          ),
        );
      },
    );
  }
}

class _MovieSearchItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;
  const _MovieSearchItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final sizeMQ = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            // * imagen
            SizedBox(
              width: sizeMQ.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress != null) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return child;
                  },
                ),
              ),
            ),
            const Spacer(),
            // * descripción
            SizedBox(
              width: sizeMQ.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: textStyles.titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  (movie.overview.length > 200)
                      ? Text('${movie.overview.substring(0, 200)}...')
                      : Text(
                          movie.overview,
                          style: textStyles.bodyMedium,
                        ),
                  // * Calificación
                  Row(children: [
                    const Icon(Icons.star_border),
                    Text(movie.voteAverage.toStringAsFixed(2))
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
