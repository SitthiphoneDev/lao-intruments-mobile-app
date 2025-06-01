import 'package:flutter/material.dart';
import 'package:lao_instruments/theme/app_colors.dart';

class AppThemes {
  static ThemeData main = ThemeData(
    colorScheme: _mainColorScheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.jetBlack,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      // iconTheme: IconThemeData(color: AppColors.emeraldGreen),
    ),
      scaffoldBackgroundColor: AppColors.jetBlack,
    //    dialogTheme: DialogTheme(
    //   backgroundColor: Color(0xFF101010),
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    // ),
    // bottomNavigationBarTheme: BottomNavigationBarThemeData(
    //   backgroundColor: Color(0xFF101010),
    //   selectedItemColor: AppColors.emeraldGreen,
    //   unselectedItemColor: AppColors.charcoalGray,
    // ),
    //   floatingActionButtonTheme: FloatingActionButtonThemeData(
    //   backgroundColor: AppColors.emeraldGreen,
    //   foregroundColor: Colors.white,
      
    // ),
    //  textButtonTheme: TextButtonThemeData(
    //   style: TextButton.styleFrom(
    //     foregroundColor: AppColors.emeraldGreen,
    //   ),
    // ),
    // elevatedButtonTheme: ElevatedButtonThemeData(
    //   style: ElevatedButton.styleFrom(
    //     backgroundColor: AppColors.emeraldGreen,
    //     foregroundColor: Colors.white,
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    //   ),
    // ),
    // inputDecorationTheme: InputDecorationTheme(
    //   fillColor: Color(0xFF101010),
    //   filled: true,
    //   border: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(8),
    //     borderSide: BorderSide.none,
      // ),
    // ),
  );

  static final ColorScheme _mainColorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.emeraldGreen,  // Main color used as the base for generating the entire color scheme
    brightness: Brightness.dark,         // Sets the theme to dark mode
    primary: AppColors.emeraldGreen,     // Primary app color used for important buttons and main elements
    onPrimary: Colors.white,             // Color of text or icons displayed on primary color surfaces
    secondary: AppColors.tealGreen,      // Secondary app color used for less important elements
    onSecondary: Colors.white,           // Color of text or icons displayed on secondary color surfaces
    tertiary: AppColors.goldenAmber,     // Third-level color used to highlight or distinguish special elements
    onTertiary: Colors.white,            // Color of text or icons displayed on tertiary color surfaces
    surface: Color(0xFF101010),          // Surface color for cards or slightly elevated areas (darker than background)
    error: AppColors.crimsonRed,         // Color for errors or warnings
    onSurface: AppColors.lightGray,      // Text color on card surfaces
  );
}
