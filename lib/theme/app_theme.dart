import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryColor = Colors.black; // Blue
  static const Color secondaryColor = Colors.black; // Dark Blue
  static const Color accentColor = Color(0xFFFF4081);
  static const Color metallicGold = Color(0xFFD4AF37);
  static const Color vegasGold = Color(0xFFC5B358);
  static const Color oldGold = Color(0xFFCFB53B);

  /*// Pink  static const Color primaryColor = Color(0xFF1E88E5); // Blue
  static const Color secondaryColor = Color(0xFF0D47A1); // Dark Blue
  static const Color accentColor = Color(0xFFFF4081); // Pink*/

  // Background Colors
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFFE0E0E0);
  static const Color surfaceColor = Color(0xFFFAFAFA);
  static const Color greyColor = Color(0xFF9E9E9E);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFF9E9E9E);

  // Status Colors
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFF44336);
  static const Color warningColor = Color(0xFFFFC107);

  // Icon Colors
  static const Color iconPrimaryColor = Color(0xFF1976D2);
  static const Color iconSecondaryColor = Colors.white;

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFD32F2F), Color(0xFFE53935)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF1976D2), Color(0xFF2196F3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Gradient get successGradient => const LinearGradient(
        colors: [Color(0xFF00B4D8), Color(0xFF48CAE4)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static Gradient get warningGradient => const LinearGradient(
        colors: [Color(0xFFFFC107), Color(0xFFFFA000)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static Gradient get appbarGradient =>  LinearGradient(
    colors: [Colors.red, Colors.red.shade900],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
      );
  static Gradient get appbarGradientBlue =>  LinearGradient(
    colors: [Colors.blue, Colors.blue.shade900],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
      );


  // Text Styles
  static final TextStyle titleStyle = GoogleFonts.montserrat(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static final TextStyle subtitleStyle = GoogleFonts.montserrat(
    fontSize: 14,
    color: textSecondary,
  );

  static final TextStyle buttonStyle = GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static final TextStyle priceStyle = GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );

  static final TextStyle oldPriceStyle = GoogleFonts.montserrat(
    fontSize: 14,
    color: greyColor,
    decoration: TextDecoration.lineThrough,
  );

  static final TextStyle ratingStyle = GoogleFonts.montserrat(
    fontSize: 14,
    color: textSecondary,
    fontWeight: FontWeight.w500,
  );

  // Decorations
  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration searchDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // Badges
  static Widget buildSaleBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: GoogleFonts.montserrat(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static final textFieldDecoration = InputDecoration(
    hintStyle: const TextStyle().copyWith(
      fontSize: 14,
      color: Colors.grey[600],
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    filled: true,
    fillColor: Colors.grey[100],
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );

  static Widget buildNewBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'New',
        style: GoogleFonts.montserrat(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static Widget buildCountdownTimer(Duration duration) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${duration.inDays}d ${duration.inHours % 24}h ${duration.inMinutes % 60}m',
        style: GoogleFonts.montserrat(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static Widget buildAddButton() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
        useMaterial3: true,
        primaryColor: primaryColor,
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          secondary: secondaryColor,
          error: errorColor,
          surface: surfaceColor,
          background: backgroundLight,
        ),
        scaffoldBackgroundColor: backgroundLight,
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.montserrat(
            color: textPrimary,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: GoogleFonts.montserrat(
            color: textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: GoogleFonts.montserrat(
            color: textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          headlineLarge: GoogleFonts.montserrat(
            color: textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
          headlineMedium: GoogleFonts.montserrat(
            color: textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: GoogleFonts.montserrat(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: GoogleFonts.montserrat(
            color: textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: GoogleFonts.montserrat(
            color: textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          titleSmall: GoogleFonts.montserrat(
            color: textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: GoogleFonts.montserrat(
            color: textPrimary,
            fontSize: 16,
          ),
          bodyMedium: GoogleFonts.montserrat(
            color: textSecondary,
            fontSize: 14,
          ),
          bodySmall: GoogleFonts.montserrat(
            color: textSecondary,
            fontSize: 12,
          ),
          labelLarge: GoogleFonts.montserrat(
            color: textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          labelMedium: GoogleFonts.montserrat(
            color: textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          labelSmall: GoogleFonts.montserrat(
            color: textPrimary,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: primaryColor),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        iconTheme: const IconThemeData(
          color: iconPrimaryColor,
          size: 24,
        ),
        cardTheme: CardThemeData(
            color: surfaceColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ))
        /*cardTheme: CardTheme(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),*/
        );
  }
}
