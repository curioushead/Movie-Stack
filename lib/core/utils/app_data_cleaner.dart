import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDataCleaner {
  static const _installFlagKey = 'app_installed_flag';

  /// Add all your Hive box names here
  static const List<String> _hiveBoxes = [
    'nowPlayingMovies',
    'popularMovies',
    'trendingMovies',
    'trendingMovies_week',
    "trendingMovies_day",
    'allPopularMovies',
    'allTopRatedMovies',
    'movieDetails'
  ];

  /// Call this at app startup. Clears data only on first install.
  static Future<void> clearDataOnFreshInstall() async {
    final prefs = await SharedPreferences.getInstance();
    final isInstalled = prefs.getBool(_installFlagKey) ?? false;

    if (!isInstalled) {
      if (kDebugMode) print('Fresh install detected: Clearing app data...');
      await _clearHiveData();
      await _clearCache();
      await prefs.clear(); // clear any leftover preferences
      await prefs.setBool(_installFlagKey, true); // mark as installed
      if (kDebugMode) print('App data cleared for fresh install.');
    }
  }

  static Future<void> _clearHiveData() async {
    await Hive.initFlutter();

    for (var boxName in _hiveBoxes) {
      try {
        final box = await Hive.openBox(boxName);
        await box.clear();
        await box.close();
        if (kDebugMode) print('Cleared Hive box: $boxName');
      } catch (e) {
        if (kDebugMode) print('Failed to clear box $boxName: $e');
      }
    }
  }

  static Future<void> _clearCache() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      if (cacheDir.existsSync()) cacheDir.deleteSync(recursive: true);

      final appDir = await getApplicationDocumentsDirectory();
      if (appDir.existsSync()) {
        for (var file in appDir.listSync(recursive: true)) {
          try {
            if (file is File) file.deleteSync();
          } catch (_) {}
        }
      }

      if (kDebugMode) print('Cache and documents cleared.');
    } catch (e) {
      if (kDebugMode) print('Failed to clear cache: $e');
    }
  }
}
