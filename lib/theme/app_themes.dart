import 'package:flutter/material.dart';
import 'package:lao_instruments/theme/app_colors.dart';

class AppThemes {
  static ThemeData get main => ThemeData(
    useMaterial3: true,
    colorScheme: _mainColorScheme,
    fontFamily: 'Inter',
    
    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryRed,
      foregroundColor: AppColors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      ),
      iconTheme: IconThemeData(color: AppColors.white),
    ),
    
    // Scaffold Background
    scaffoldBackgroundColor: AppColors.lightGrey,
    
    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.primaryRed,
      unselectedItemColor: AppColors.grey,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.normal,
        fontSize: 12,
      ),
    ),
    
    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryRed,
      foregroundColor: AppColors.white,
      elevation: 6,
    ),
    
    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryRed,
        foregroundColor: AppColors.white,
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    
    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryRed,
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    
    // Card Theme
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: AppColors.white,
      shadowColor: Colors.black.withOpacity(0.1),
    ),
    
    // Dialog Theme
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titleTextStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.darkGrey,
      ),
      contentTextStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        color: AppColors.grey,
      ),
    ),
    
    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryRed, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      labelStyle: const TextStyle(
        fontFamily: 'Inter',
        color: AppColors.grey,
      ),
      hintStyle: const TextStyle(
        fontFamily: 'Inter',
        color: AppColors.grey,
      ),
    ),
    
    // List Tile Theme
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      iconColor: AppColors.grey,
      textColor: AppColors.darkGrey,
    ),
    
    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: AppColors.lightGrey,
      thickness: 1,
      space: 1,
    ),
    
    // Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.white;
        }
        return AppColors.grey;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryRed;
        }
        return AppColors.lightGrey;
      }),
    ),
    
    // Progress Indicator Theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primaryRed,
      linearTrackColor: AppColors.lightGrey,
      circularTrackColor: AppColors.lightGrey,
    ),
    
    // Snack Bar Theme
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.darkGrey,
      contentTextStyle: TextStyle(
        fontFamily: 'Inter',
        color: AppColors.white,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 6,
    ),
  );

  static final ColorScheme _mainColorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primaryRed,
    brightness: Brightness.light,          // Light theme for Lao app
    primary: AppColors.primaryRed,          // Primary red from Lao flag
    onPrimary: AppColors.white,            
    secondary: AppColors.primaryGold,       // Gold for secondary elements
    onSecondary: AppColors.darkGrey,       
    tertiary: AppColors.primaryBlue,        // Blue from Lao flag
    onTertiary: AppColors.white,           
    surface: AppColors.white,               // White surface for cards
    onSurface: AppColors.darkGrey,         
    background: AppColors.lightGrey,        // Light grey background
    onBackground: AppColors.darkGrey,      
    error: AppColors.error,                
    onError: AppColors.white,              
    outline: AppColors.grey,               
    surfaceVariant: AppColors.lightGold,    // Light gold variant
    onSurfaceVariant: AppColors.darkGrey,  
  );
  
  // Dark theme for future use
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: _darkColorScheme,
    fontFamily: 'Inter',
    
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkGrey,
      foregroundColor: AppColors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    ),
    
    scaffoldBackgroundColor: const Color(0xFF121212),
    
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkGrey,
      selectedItemColor: AppColors.primaryGold,
      unselectedItemColor: AppColors.grey,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
  );
  
  static final ColorScheme _darkColorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primaryGold,
    brightness: Brightness.dark,
    primary: AppColors.primaryGold,
    secondary: AppColors.primaryRed,
    tertiary: AppColors.primaryBlue,
    surface: AppColors.darkGrey,
    background: const Color(0xFF121212),
  );
}