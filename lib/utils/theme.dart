import 'package:flutter/material.dart';
// Removed google_fonts to avoid runtime asset loading issues on web/dev

class AppTheme {
  // Couleurs principales basées sur l'image fournie (sombre avec accents roses)
  static const Color primaryColor = Color(0xFFFF4081); // Rose accent
  static const Color backgroundColor = Color(0xFF121212); // Fond très sombre
  static const Color surfaceColor = Color(0xFF1E1E1E); // Cartes/Surfaces
  static const Color onSurfaceColor = Colors.white;

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundColor,
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      surface: surfaceColor,
      background: backgroundColor,
      onSurface: onSurfaceColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: onSurfaceColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: onSurfaceColor),
    ),
    textTheme: ThemeData.dark().textTheme.apply(
      bodyColor: onSurfaceColor,
      displayColor: onSurfaceColor,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
  );
  
  // Thème clair avec teinte rose douce
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFFAF0F5), // Fond avec teinte rose
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      surface: Color(0xFFFFF5F8), // Surface avec teinte rose plus légère
      background: Color(0xFFFAF0F5),
      onSurface: Color(0xFF1A1A1A),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFAF0F5),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Color(0xFF1A1A1A),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Color(0xFF1A1A1A)),
    ),
    textTheme: TextTheme(
      bodyLarge: const TextStyle(color: Color(0xFF1A1A1A)),
      bodyMedium: const TextStyle(color: Color(0xFF1A1A1A)),
      labelLarge: const TextStyle(color: Color(0xFF1A1A1A)),
      headlineLarge: const TextStyle(color: Color(0xFF1A1A1A)),
      headlineMedium: const TextStyle(color: Color(0xFF1A1A1A)),
      headlineSmall: const TextStyle(color: Color(0xFF1A1A1A)),
      titleLarge: const TextStyle(color: Color(0xFF1A1A1A)),
      titleMedium: const TextStyle(color: Color(0xFF1A1A1A)),
      titleSmall: const TextStyle(color: Color(0xFF1A1A1A)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
  );
}
