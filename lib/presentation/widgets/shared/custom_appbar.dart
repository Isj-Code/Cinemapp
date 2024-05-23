import 'package:cinemapp/domain/entities/movie.dart';
import 'package:cinemapp/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapp/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Icon(
                Icons.movie_outlined,
                color: colors.primary,
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                'Cinemapp',
                style: titleStyle,
              ),
              const Spacer(),
              IconButton(
                // * no podemos usar el async / await para evitar trabajar con todo el context asi que usamos el then
                onPressed: () {
                  final searchedMovies = ref.read(searchMoviesProvider);
                  final searchQuery = ref.read(searchQueRyProvider);

                  showSearch<Movie?>(
                    query: searchQuery,
                    context: context,
                    delegate: SearchMovieDelegate(
                        initialMovies: searchedMovies,
                        searchMovie: ref
                            .read(searchMoviesProvider.notifier)
                            .serchMovieByQuery),
                  ).then(
                    (movie) {
                      if (movie == null) {
                        return null;
                      }
                      return context.push('/home/0/movie/${movie.id}');
                    },
                  );
                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
