import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_stack/core/resources/app_router.dart';
import 'package:movie_stack/core/resources/app_routes.dart';
import 'package:movie_stack/core/resources/app_strings.dart';
import 'package:movie_stack/core/resources/app_values.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            final String location = GoRouterState.of(context).matchedLocation;
            if (!location.startsWith(moviesPath)) {
              _onItemTapped(0, context);
            }
          }
        },
        child: widget.child,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: AppStrings.movies,
            icon: Icon(
              Icons.movie_creation_rounded,
              size: AppSize.s20,
            ),
          ),
          BottomNavigationBarItem(
            label: AppStrings.search,
            icon: Icon(
              Icons.search_rounded,
              size: AppSize.s20,
            ),
          ),
          BottomNavigationBarItem(
            label: AppStrings.watchlist,
            icon: Icon(
              Icons.bookmark_rounded,
              size: AppSize.s20,
            ),
          ),
        ],
        currentIndex: _getSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
      ),
    );
  }

  int _getSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(moviesPath)) {
      return 0;
    }
    if (location.startsWith(searchPath)) {
      return 1;
    }
    if (location.startsWith(watchlistPath)) {
      return 2;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.goNamed(AppRoutes.moviesRoute);
        break;
      case 1:
        context.goNamed(AppRoutes.searchRoute);
        break;
      case 2:
        context.goNamed(AppRoutes.watchlistRoute);
        break;
    }
  }
}
