import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Corner radius tokens from DESIGN_SYSTEM.md §Components/§Layout.
/// Change values here, not at call sites, when the design system updates.
abstract final class AppRadius {
  static const double button = 28;
  static const double input = 16;
  static const double card = 18;
  static const double badge = 12;
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
    required this.error,
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
  final Color error;

  static const light = AppColors(
    brandRed: Color(0xFFE63950),
    brandRedDark: Color(0xFFA61E38),
    textPrimary: Color(0xFF1B1B1F),
    textSecondary: Color(0xFF8B8B93),
    surface: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFF4F5FA),
    border: Color(0xFFE8E8EE),
    success: Color(0xFF2E9E5B),
    amber: Color(0xFFC98A1D),
    error: Color(0xFFE2703A),
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
    Color? error,
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
      error: error ?? this.error,
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
      error: Color.lerp(error, other.error, t)!,
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
              minimumSize: const Size.fromHeight(54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.button),
              ),
              textStyle: GoogleFonts.inter(
                fontSize: 15,
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
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceMuted,
        constraints: const BoxConstraints(minHeight: 52),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: colors.brandRed, width: 1.5),
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: colors.textSecondary,
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
      ),
    );
  }
}
