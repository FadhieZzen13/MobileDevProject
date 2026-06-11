import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/facility_screen.dart';
import 'screens/search_screen.dart';
import 'screens/green_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const FsktmNavApp(),
    ),
  );
}

class FsktmNavApp extends StatelessWidget {
  const FsktmNavApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'FSKTM Navigation & Green App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProvider.mode,
      // Named routes for screens that take no arguments. Screens that need
      // typed arguments (block, floor, room) are pushed with MaterialPageRoute
      // from within the screens themselves.
      initialRoute: SplashScreen.route,
      routes: {
        SplashScreen.route: (_) => const SplashScreen(),
        HomeScreen.route: (_) => const HomeScreen(),
        FacilityScreen.route: (_) => const FacilityScreen(),
        SearchScreen.route: (_) => const SearchScreen(),
        GreenScreen.route: (_) => const GreenScreen(),
      },
    );
  }
}
