import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Corner radius tokens from DESIGN_SYSTEM.md §Components/§Layout.
/// Change values here, not at call sites, when the design system updates.
abstract final class AppRadius {
  static const double button = 8;
  static const double input = 8;
  static const double cardMin = 10;
  static const double cardMax = 14;
  static const double card = 12;
  static const double badge = 6;
}

/// Color tokens from DESIGN_SYSTEM.md §Colors, exposed via [ThemeExtension]
/// so screens/widgets read `Theme.of(context).extension<AppColors>()!`
/// instead of hardcoding hex values.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.brandRed,
    required this.brandRedDark,
    required this.textPrimary,
    required this.textSecondary,
    required this.surface,
    required this.surfaceMuted,
    required this.border,
    required this.success,
    required this.amber,
  });

  final Color brandRed;
  final Color brandRedDark;
  final Color textPrimary;
  final Color textSecondary;
  final Color surface;
  final Color surfaceMuted;
  final Color border;
  final Color success;
  final Color amber;

  static const light = AppColors(
    brandRed: Color(0xFFA31B1B),
    brandRedDark: Color(0xFF712222),
    textPrimary: Color(0xFF0F0F0E),
    textSecondary: Color(0xFF665F5F),
    surface: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFF5F2EF),
    border: Color(0xFFD3CFCA),
    success: Color(0xFF298C5A),
    amber: Color(0xFFB37A16),
  );

  @override
  AppColors copyWith({
    Color? brandRed,
    Color? brandRedDark,
    Color? textPrimary,
    Color? textSecondary,
    Color? surface,
    Color? surfaceMuted,
    Color? border,
    Color? success,
    Color? amber,
  }) {
    return AppColors(
      brandRed: brandRed ?? this.brandRed,
      brandRedDark: brandRedDark ?? this.brandRedDark,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      surface: surface ?? this.surface,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      border: border ?? this.border,
      success: success ?? this.success,
      amber: amber ?? this.amber,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      brandRed: Color.lerp(brandRed, other.brandRed, t)!,
      brandRedDark: Color.lerp(brandRedDark, other.brandRedDark, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      border: Color.lerp(border, other.border, t)!,
      success: Color.lerp(success, other.success, t)!,
      amber: Color.lerp(amber, other.amber, t)!,
    );
  }
}

/// Maps DESIGN_SYSTEM.md §Typography styles onto Material's [TextTheme] slots.
/// Page heading -> headlineSmall, Section heading -> titleLarge,
/// Body -> bodyLarge, Secondary -> bodyMedium, Caption -> labelSmall.
TextTheme _buildTextTheme(AppColors colors) {
  return GoogleFonts.interTextTheme().copyWith(
    headlineSmall: GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: colors.textPrimary,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: colors.textPrimary,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: colors.textPrimary,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: colors.textSecondary,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: colors.textSecondary,
    ),
  );
}

/// Single flat (no dark mode) theme for the app, per DESIGN_SYSTEM.md.
abstract final class AppTheme {
  static ThemeData get light {
    const colors = AppColors.light;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: colors.surface,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.brandRed,
        brightness: Brightness.light,
        primary: colors.brandRed,
        surface: colors.surface,
        error: colors.brandRed,
      ),
      textTheme: _buildTextTheme(colors),
      extensions: const [colors],
      dividerColor: colors.border,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style:
            ElevatedButton.styleFrom(
              backgroundColor: colors.brandRed,
              foregroundColor: colors.surface,
              minimumSize: const Size.fromHeight(44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.button),
              ),
              textStyle: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ).copyWith(
              overlayColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.pressed)
                    ? colors.brandRedDark
                    : null,
              ),
            ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.textPrimary,
          side: BorderSide(color: colors.border),
          minimumSize: const Size.fromHeight(44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        constraints: const BoxConstraints(minHeight: 44),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: colors.brandRed),
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: colors.textSecondary,
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.surfaceMuted,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
      ),
    );
  }
}
