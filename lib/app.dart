import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/home_screen.dart';
import 'screens/suggestion_screen.dart';
import 'screens/favorite_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/daily_recommendation_screen.dart';

class MealMindApp extends StatelessWidget {
  const MealMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MealMind',
      debugShowCheckedModeBanner: false,

      // Gunakan sistem tema otomatis
      themeMode: ThemeMode.system,

      // Tema terang
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        brightness: Brightness.light,
        textTheme: GoogleFonts.poppinsTextTheme(),
        cardTheme: const CardThemeData(
          elevation: 3,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),

      // Tema gelap
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        cardTheme: const CardThemeData(
          elevation: 3,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),

      // Routing antar halaman
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/suggestion': (context) => const SuggestionScreen(),
        '/favorites': (context) => const FavoriteScreen(),
        '/detail': (context) => const DetailScreen(),
        '/daily': (context) => const DailyRecommendationScreen(),
      },
    );
  }
}
