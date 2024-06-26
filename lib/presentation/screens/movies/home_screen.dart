import 'package:flutter/material.dart';

import 'package:cinemapp/presentation/widgets/widgets.dart';
import 'package:cinemapp/presentation/views/views.dart';

class HomeScreen extends StatelessWidget {
  static const name = "home-screen";
  final int pageIndex;

  const HomeScreen({super.key, required this.pageIndex});

  final viewRoutes = const <Widget>[
    HomeView(),
    CategoriesView(),
    FavoritesView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IndexedStack(
          index: pageIndex,
          children: viewRoutes,
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationbar(currentIndex: pageIndex),
    );
  }
}
