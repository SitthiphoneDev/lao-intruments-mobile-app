import 'package:flutter/material.dart';

class AppColors {
  // Lao Cultural Colors (ສີສັນວັດທະນະທຳລາວ)
  static const Color primaryGold = Color(0xFFFFD700);      // ທອງ - Buddhist/Royal color
  static const Color primaryRed = Color(0xFFDC143C);       // ແດງ - Flag red
  static const Color primaryBlue = Color(0xFF1E3A8A);      // ຟ້າ - Flag blue
  static const Color white = Color(0xFFFFFFFF);            // ຂາວ
  static const Color lightGrey = Color(0xFFF5F5F5);        // ເທົາອ່ອນ
  static const Color grey = Color(0xFF6B7280);             // ເທົາ
  static const Color darkGrey = Color(0xFF374151);         // ເທົາເຂັ້ມ
  static const Color lightGold = Color(0xFFFFF8DC);        // ທອງອ່ອນ
  
  // Additional accent colors
  static const Color success = Color(0xFF10B981);          // ສີຂຽວສຳເລັດ
  static const Color warning = Color(0xFFF59E0B);          // ສີເຫຼືອງເຕືອນ
  static const Color error = Color(0xFFEF4444);            // ສີແດງຜິດພາດ
  
  // Gradient Colors
  static const LinearGradient goldGradient = LinearGradient(
    colors: [primaryGold, Color(0xFFFFA500)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient redGradient = LinearGradient(
    colors: [primaryRed, Color(0xFFB91C3C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient blueGradient = LinearGradient(
    colors: [primaryBlue, Color(0xFF1E40AF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Additional gradients for the enhanced UI
  static const LinearGradient greyGradient = LinearGradient(
    colors: [grey, darkGrey],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient successGradient = LinearGradient(
    colors: [success, Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient warningGradient = LinearGradient(
    colors: [warning, Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}