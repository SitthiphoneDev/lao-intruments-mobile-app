import 'package:flutter/material.dart';
import 'package:lao_instruments/theme/app_colors.dart';

class AppTextStyles {
  // Headings
  static const TextStyle h1 = TextStyle(
    fontFamily: 'Inter',
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.darkGrey,
    height: 1.2,
  );
  
  static const TextStyle h2 = TextStyle(
    fontFamily: 'Inter',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.darkGrey,
    height: 1.3,
  );
  
  static const TextStyle h3 = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.darkGrey,
    height: 1.3,
  );
  
  static const TextStyle h4 = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.darkGrey,
    height: 1.4,
  );
  
  // Body text
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.darkGrey,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.darkGrey,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.grey,
    height: 1.4,
  );
  
  // Labels
  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.darkGrey,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.grey,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.grey,
  );
  
  // Button text
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );
  
  static const TextStyle buttonMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );
  
  // Special styles
  static const TextStyle caption = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.grey,
    height: 1.3,
  );
  
  static const TextStyle overline = TextStyle(
    fontFamily: 'Inter',
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.grey,
    letterSpacing: 0.5,
  );
}

extension AppTextTheme on TextTheme {
  // Custom text theme extensions for Lao app
  TextStyle get laoHeading => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryRed,
  );
  
  TextStyle get laoSubheading => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.darkGrey,
  );
  
  TextStyle get laoBody => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.darkGrey,
    height: 1.5,
  );
  
  TextStyle get laoCaption => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.grey,
  );
}