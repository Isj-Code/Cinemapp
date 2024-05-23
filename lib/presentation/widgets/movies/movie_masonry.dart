import 'package:cinemapp/domain/entities/movie.dart';
import 'package:cinemapp/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MovieMasonry extends StatefulWidget {
  final List<Movie> movies;
  final VoidCallback? loadNextPage;
  const MovieMasonry({
    super.key,
    required this.movies,
    this.loadNextPage,
  });

  @override
  State<MovieMasonry> createState() => MovieMasonryState();
}

class MovieMasonryState extends State<MovieMasonry> {
  final scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    scrollController.addListener(
      () {
        if (widget.loadNextPage == null) return;
        if (scrollController.position.pixels + 70 >=
            scrollController.position.maxScrollExtent) widget.loadNextPage!();
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: MasonryGridView.count(
        controller: scrollController,
        crossAxisSpacing: 3,
        mainAxisSpacing: 10,
        itemCount: widget.movies.length,
        crossAxisCount: 3,
        itemBuilder: (context, index) {
          if (index == 1) {
            return Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                MoviePosterLink(movie: widget.movies[index]),
              ],
            );
          }
          return MoviePosterLink(movie: widget.movies[index]);
        },
      ),
    );
  }
}
