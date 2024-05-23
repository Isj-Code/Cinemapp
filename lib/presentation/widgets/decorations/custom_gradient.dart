import 'package:flutter/material.dart';

// Gradiente reutilizable

class CustomGradient extends StatelessWidget {
  final List<Color> colors;
  final AlignmentGeometry end;
  final AlignmentGeometry begin;
  final List<double> stops;
  const CustomGradient({
    super.key,
    required this.colors,
    required this.end,
    required this.begin,
    required this.stops,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            end: end,
            stops: stops,
            colors: colors,
          ),
        ),
      ),
    );
  }
}
