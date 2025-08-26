import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:movie_stack/core/domain/entities/media.dart';
import 'package:movie_stack/core/domain/entities/media_details.dart';
import 'package:movie_stack/core/resources/app_router.dart';
import 'package:movie_stack/core/resources/app_strings.dart';
import 'package:movie_stack/core/resources/app_theme.dart';
import 'package:movie_stack/core/services/service_locator.dart';
import 'package:movie_stack/core/utils/app_data_cleaner.dart';
import 'package:movie_stack/movies/data/models/movie_model.dart';
import 'package:movie_stack/movies/domain/entities/cast.dart';
import 'package:movie_stack/movies/domain/entities/review.dart';
import 'package:movie_stack/watchlist/presentation/controllers/watchlist_bloc/watchlist_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env first
  await dotenv.load(fileName: ".env");

  // Clear app data on fresh install
  await AppDataCleaner.clearDataOnFreshInstall();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(MediaAdapter());
  Hive.registerAdapter(MediaDetailsAdapter());
  Hive.registerAdapter(CastAdapter());
  Hive.registerAdapter(ReviewAdapter());
  Hive.registerAdapter(MovieModelAdapter());

  // Open Hive boxes
  await Hive.openBox('items');

  // Initialize your service locator
  ServiceLocator.init();

  // Run app with BlocProvider
  runApp(
    BlocProvider(
      create: (context) => sl<WatchlistBloc>(),
      child: const MovieApp(),
    ),
  );
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appTitle,
      theme: getApplicationTheme(),
      routerConfig: AppRouter().router,
    );
  }
}
