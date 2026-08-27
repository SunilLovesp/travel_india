import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // TripAdvisor-inspired palette
  static const primary       = Color(0xFF00AA6C);   // TA Green
  static const primaryLight  = Color(0xFF34E0A1);   // TA light green
  static const primaryDark   = Color(0xFF007A4D);   // darker green
  static const navy          = Color(0xFF152C54);   // TA dark navy
  static const background    = Color(0xFFF2F2F2);
  static const cardBg        = Color(0xFFFFFFFF);
  static const textPrimary   = Color(0xFF152C54);
  static const textSecondary = Color(0xFF4A4A4A);
  static const textHint      = Color(0xFF9B9B9B);
  static const divider       = Color(0xFFE8E8E8);
  static const rating        = Color(0xFF00AA6C);
  static const ratingYellow  = Color(0xFFFFCD00);
  static const danger        = Color(0xFFE8003D);

  // Category colours (unchanged)
  static const templeColor   = Color(0xFFB71C1C);
  static const beachColor    = Color(0xFF0288D1);
  static const hillColor     = Color(0xFF2E7D32);
  static const cityColor     = Color(0xFF37474F);
  static const fortColor     = Color(0xFF795548);
  static const wildlifeColor = Color(0xFF558B2F);
  static const waterfallColor= Color(0xFF00838F);
  static const lakeColor     = Color(0xFF1565C0);

  static const adventureColor = Color(0xFFE64A19);
  static const museumColor    = Color(0xFF6A1B9A);
  static const marketColor    = Color(0xFFEF8C00);
  static const caveColor      = Color(0xFF37474F);
  static const valleyColor    = Color(0xFF00695C);
  static const desertColor    = Color(0xFFBF8B00);

  static const winterColor  = Color(0xFF5C6BC0);
  static const summerColor  = Color(0xFFFF8F00);
  static const monsoonColor = Color(0xFF0277BD);
  static const autumnColor  = Color(0xFFE65100);
}

class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      surface: AppColors.cardBg,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.poppinsTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.navy,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: Colors.black12,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: GoogleFonts.poppins(
          color: AppColors.navy,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: AppColors.navy),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBg,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        hintStyle: GoogleFonts.poppins(color: AppColors.textHint, fontSize: 14),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primary.withOpacity(0.12),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.black26,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.poppins(
                fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary);
          }
          return GoogleFonts.poppins(
              fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.textHint);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 24);
          }
          return const IconThemeData(color: AppColors.textHint, size: 22);
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: AppColors.primary.withOpacity(0.12),
        labelStyle: GoogleFonts.poppins(fontSize: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 0,
      ),
    );
  }
}
