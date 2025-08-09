import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the application.
/// Implements Contemporary Purposeful Minimalism with Energetic Professional Palette
/// optimized for gamified productivity apps targeting young professionals.
class AppTheme {
  AppTheme._();

  // Energetic Professional Palette - Color Specifications
  static const Color primaryLight =
      Color(0xFF2563EB); // Vibrant blue for primary actions
  static const Color primaryDark =
      Color(0xFF3B82F6); // Lighter blue for dark mode
  static const Color secondaryLight =
      Color(0xFF10B981); // Fresh mint green for success
  static const Color secondaryDark =
      Color(0xFF34D399); // Lighter mint for dark mode
  static const Color accentLight = Color(0xFFF59E0B); // Golden yellow for MotiCoins
  static const Color accentDark =
      Color(0xFFFBBF24); // Lighter gold for dark mode

  // Background colors - warm off-white and professional dark
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF111827);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1F2937);

  // Status colors optimized for mobile visibility
  static const Color errorLight = Color(0xFFEF4444);
  static const Color errorDark = Color(0xFFF87171);
  static const Color warningLight = Color(0xFFF97316);
  static const Color warningDark = Color(0xFFFB923C);

  // Text colors with proper contrast ratios
  static const Color textPrimaryLight = Color(0xFF111827);
  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);

  // Border and divider colors - subtle and minimal
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF374151);

  // Card colors for elevated surfaces
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1F2937);

  // Shadow colors for minimal elevation system
  static const Color shadowLight = Color(0x0F000000);
  static const Color shadowDark = Color(0x1F000000);

  /// Light theme optimized for outdoor mobile usage
  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: primaryLight,
          onPrimary: Colors.white,
          primaryContainer: primaryLight.withValues(alpha: 0.1),
          onPrimaryContainer: primaryLight,
          secondary: secondaryLight,
          onSecondary: Colors.white,
          secondaryContainer: secondaryLight.withValues(alpha: 0.1),
          onSecondaryContainer: secondaryLight,
          tertiary: accentLight,
          onTertiary: Colors.white,
          tertiaryContainer: accentLight.withValues(alpha: 0.1),
          onTertiaryContainer: accentLight,
          error: errorLight,
          onError: Colors.white,
          surface: surfaceLight,
          onSurface: textPrimaryLight,
          onSurfaceVariant: textSecondaryLight,
          outline: borderLight,
          outlineVariant: borderLight.withValues(alpha: 0.5),
          shadow: shadowLight,
          scrim: Colors.black54,
          inverseSurface: surfaceDark,
          onInverseSurface: textPrimaryDark,
          inversePrimary: primaryDark),
      scaffoldBackgroundColor: backgroundLight,
      cardColor: cardLight,
      dividerColor: borderLight,

      // AppBar theme for contextual top navigation
      appBarTheme: AppBarTheme(
          backgroundColor: surfaceLight,
          foregroundColor: textPrimaryLight,
          elevation: 0,
          scrolledUnderElevation: 2,
          shadowColor: shadowLight,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textPrimaryLight),
          iconTheme: IconThemeData(color: textPrimaryLight),
          actionsIconTheme: IconThemeData(color: textPrimaryLight)),

      // Card theme with adaptive elevation
      cardTheme: CardThemeData(
          color: cardLight,
          elevation: 2,
          shadowColor: shadowLight,
          surfaceTintColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),

      // Bottom navigation for progressive disclosure
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: surfaceLight,
          selectedItemColor: primaryLight,
          unselectedItemColor: textSecondaryLight,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle:
              GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
          unselectedLabelStyle:
              GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400)),

      // Floating Action Button with morphing capability
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryLight,
          foregroundColor: Colors.white,
          elevation: 6,
          focusElevation: 8,
          hoverElevation: 8,
          highlightElevation: 12,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),

      // Button themes for consistent interaction
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: primaryLight,
              foregroundColor: Colors.white,
              elevation: 2,
              shadowColor: shadowLight,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              textStyle: GoogleFonts.inter(
                  fontSize: 14, fontWeight: FontWeight.w500))),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              foregroundColor: primaryLight,
              side: BorderSide(color: primaryLight, width: 1),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              textStyle: GoogleFonts.inter(
                  fontSize: 14, fontWeight: FontWeight.w500))),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: primaryLight,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              textStyle: GoogleFonts.inter(
                  fontSize: 14, fontWeight: FontWeight.w500))),

      // Typography using Inter for optimal mobile readability
      textTheme: _buildTextTheme(isLight: true),

      // Input decoration for clean form elements
      inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surfaceLight,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderLight)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderLight)),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: primaryLight, width: 2)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: errorLight)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: errorLight, width: 2)),
          labelStyle: GoogleFonts.inter(color: textSecondaryLight, fontSize: 14, fontWeight: FontWeight.w400),
          hintStyle: GoogleFonts.inter(color: textSecondaryLight, fontSize: 14, fontWeight: FontWeight.w400),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),

      // Switch theme for settings
      switchTheme: SwitchThemeData(thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primaryLight;
        return Colors.grey[300];
      }), trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected))
          return primaryLight.withValues(alpha: 0.5);
        return Colors.grey[300];
      })),

      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return primaryLight;
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(Colors.white),
          side: BorderSide(color: borderLight, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),

      // Progress indicators for loading states
      progressIndicatorTheme: ProgressIndicatorThemeData(color: primaryLight, linearTrackColor: primaryLight.withValues(alpha: 0.2), circularTrackColor: primaryLight.withValues(alpha: 0.2)),

      // Tab bar theme for navigation
      tabBarTheme: TabBarThemeData(labelColor: primaryLight, unselectedLabelColor: textSecondaryLight, indicatorColor: primaryLight, indicatorSize: TabBarIndicatorSize.label, labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600), unselectedLabelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400)),

      // Snackbar theme for feedback
      snackBarTheme: SnackBarThemeData(backgroundColor: textPrimaryLight, contentTextStyle: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400), actionTextColor: accentLight, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 6),

      // Bottom sheet theme for contextual actions
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: surfaceLight, elevation: 8, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))), clipBehavior: Clip.antiAliasWithSaveLayer), dialogTheme: DialogThemeData(backgroundColor: surfaceLight));

  /// Dark theme optimized for low-light usage
  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: primaryDark,
          onPrimary: Colors.white,
          primaryContainer: primaryDark.withValues(alpha: 0.2),
          onPrimaryContainer: primaryDark,
          secondary: secondaryDark,
          onSecondary: Colors.white,
          secondaryContainer: secondaryDark.withValues(alpha: 0.2),
          onSecondaryContainer: secondaryDark,
          tertiary: accentDark,
          onTertiary: Colors.white,
          tertiaryContainer: accentDark.withValues(alpha: 0.2),
          onTertiaryContainer: accentDark,
          error: errorDark,
          onError: Colors.white,
          surface: surfaceDark,
          onSurface: textPrimaryDark,
          onSurfaceVariant: textSecondaryDark,
          outline: borderDark,
          outlineVariant: borderDark.withValues(alpha: 0.5),
          shadow: shadowDark,
          scrim: Colors.black87,
          inverseSurface: surfaceLight,
          onInverseSurface: textPrimaryLight,
          inversePrimary: primaryLight),
      scaffoldBackgroundColor: backgroundDark,
      cardColor: cardDark,
      dividerColor: borderDark,

      // AppBar theme for dark mode
      appBarTheme: AppBarTheme(
          backgroundColor: surfaceDark,
          foregroundColor: textPrimaryDark,
          elevation: 0,
          scrolledUnderElevation: 2,
          shadowColor: shadowDark,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textPrimaryDark),
          iconTheme: IconThemeData(color: textPrimaryDark),
          actionsIconTheme: IconThemeData(color: textPrimaryDark)),

      // Card theme for dark mode
      cardTheme: CardThemeData(
          color: cardDark,
          elevation: 2,
          shadowColor: shadowDark,
          surfaceTintColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),

      // Bottom navigation for dark mode
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: surfaceDark,
          selectedItemColor: primaryDark,
          unselectedItemColor: textSecondaryDark,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle:
              GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
          unselectedLabelStyle:
              GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400)),

      // Floating Action Button for dark mode
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryDark,
          foregroundColor: Colors.white,
          elevation: 6,
          focusElevation: 8,
          hoverElevation: 8,
          highlightElevation: 12,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),

      // Button themes for dark mode
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: primaryDark,
              foregroundColor: Colors.white,
              elevation: 2,
              shadowColor: shadowDark,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              textStyle: GoogleFonts.inter(
                  fontSize: 14, fontWeight: FontWeight.w500))),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              foregroundColor: primaryDark,
              side: BorderSide(color: primaryDark, width: 1),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              textStyle: GoogleFonts.inter(
                  fontSize: 14, fontWeight: FontWeight.w500))),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: primaryDark,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              textStyle: GoogleFonts.inter(
                  fontSize: 14, fontWeight: FontWeight.w500))),

      // Typography for dark mode
      textTheme: _buildTextTheme(isLight: false),

      // Input decoration for dark mode
      inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surfaceDark,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderDark)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderDark)),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: primaryDark, width: 2)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: errorDark)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: errorDark, width: 2)),
          labelStyle: GoogleFonts.inter(color: textSecondaryDark, fontSize: 14, fontWeight: FontWeight.w400),
          hintStyle: GoogleFonts.inter(color: textSecondaryDark, fontSize: 14, fontWeight: FontWeight.w400),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),

      // Switch theme for dark mode
      switchTheme: SwitchThemeData(thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primaryDark;
        return Colors.grey[600];
      }), trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected))
          return primaryDark.withValues(alpha: 0.5);
        return Colors.grey[600];
      })),

      // Checkbox theme for dark mode
      checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return primaryDark;
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(Colors.white),
          side: BorderSide(color: borderDark, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),

      // Progress indicators for dark mode
      progressIndicatorTheme: ProgressIndicatorThemeData(color: primaryDark, linearTrackColor: primaryDark.withValues(alpha: 0.2), circularTrackColor: primaryDark.withValues(alpha: 0.2)),

      // Tab bar theme for dark mode
      tabBarTheme: TabBarThemeData(labelColor: primaryDark, unselectedLabelColor: textSecondaryDark, indicatorColor: primaryDark, indicatorSize: TabBarIndicatorSize.label, labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600), unselectedLabelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400)),

      // Snackbar theme for dark mode

      // Bottom sheet theme for dark mode
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: surfaceDark, elevation: 8, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))), clipBehavior: Clip.antiAliasWithSaveLayer), dialogTheme: DialogThemeData(backgroundColor: surfaceDark));

  /// Helper method to build text theme using Montserrat + Nunito font combination
  /// Montserrat for headings and Nunito for body text
  /// Optimized for mobile readability with proper hierarchy and modern feel
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textPrimary = isLight ? textPrimaryLight : textPrimaryDark;
    final Color textSecondary =
        isLight ? textSecondaryLight : textSecondaryDark;

    return TextTheme(
        // Display styles for large headings - Using Montserrat for bold, modern look
        displayLarge: GoogleFonts.montserrat(
            fontSize: 57,
            fontWeight: FontWeight.w700,
            color: textPrimary,
            letterSpacing: -0.25),
        displayMedium: GoogleFonts.montserrat(
            fontSize: 45, fontWeight: FontWeight.w700, color: textPrimary),
        displaySmall: GoogleFonts.montserrat(
            fontSize: 36, fontWeight: FontWeight.w600, color: textPrimary),

        // Headline styles for section headers - Using Montserrat for consistency
        headlineLarge: GoogleFonts.montserrat(
            fontSize: 32, fontWeight: FontWeight.w600, color: textPrimary),
        headlineMedium: GoogleFonts.montserrat(
            fontSize: 28, fontWeight: FontWeight.w600, color: textPrimary),
        headlineSmall: GoogleFonts.montserrat(
            fontSize: 24, fontWeight: FontWeight.w600, color: textPrimary),

        // Title styles for cards and components - Using Montserrat for titles
        titleLarge: GoogleFonts.montserrat(
            fontSize: 22, fontWeight: FontWeight.w500, color: textPrimary),
        titleMedium: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textPrimary,
            letterSpacing: 0.15),
        titleSmall: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textPrimary,
            letterSpacing: 0.1),

        // Body text for main content - Using Nunito for readability and friendly feel
        bodyLarge: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: textPrimary,
            letterSpacing: 0.5),
        bodyMedium: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: textPrimary,
            letterSpacing: 0.25),
        bodySmall: GoogleFonts.nunito(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: textSecondary,
            letterSpacing: 0.4),

        // Label styles for buttons and captions - Using Nunito for interactive elements
        labelLarge: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w600, // Slightly bolder for buttons
            color: textPrimary,
            letterSpacing: 0.1),
        labelMedium: GoogleFonts.nunito(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textPrimary,
            letterSpacing: 0.5),
        labelSmall: GoogleFonts.nunito(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: textSecondary,
            letterSpacing: 0.5));
  }
}
