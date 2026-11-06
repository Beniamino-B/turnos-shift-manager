import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF5B5FEF);
  static const Color primaryDark = Color(0xFF4348D0);
  static const Color accent = Color(0xFFFF9F43);
  static const Color night = Color(0xFF7C3AED);
  static const Color success = Color(0xFF22C55E);
  static const Color danger = Color(0xFFEF4444);
}

class AppPalette extends ThemeExtension<AppPalette> {
  final Color backgroundTop;
  final Color backgroundBottom;
  final Color textPrimary;
  final Color textSecondary;
  final Color glassFill;
  final Color glassBorder;

  const AppPalette({
    required this.backgroundTop,
    required this.backgroundBottom,
    required this.textPrimary,
    required this.textSecondary,
    required this.glassFill,
    required this.glassBorder,
  });

  static const light = AppPalette(
    backgroundTop: Color(0xFFEEF1FF),
    backgroundBottom: Color(0xFFD2D8FC),
    textPrimary: Color(0xFF1D1E3A),
    textSecondary: Color(0xFF6B6E93),
    glassFill: Color(0xB3FFFFFF),
    glassBorder: Color(0x66FFFFFF),
  );

  static const dark = AppPalette(
    backgroundTop: Color(0xFF14162B),
    backgroundBottom: Color(0xFF22254A),
    textPrimary: Color(0xFFF2F3FF),
    textSecondary: Color(0xFFB4B8D4),
    glassFill: Color(0x2EFFFFFF),
    glassBorder: Color(0x33FFFFFF),
  );

  static AppPalette of(BuildContext context) =>
      Theme.of(context).extension<AppPalette>() ?? light;

  @override
  AppPalette copyWith({
    Color? backgroundTop,
    Color? backgroundBottom,
    Color? textPrimary,
    Color? textSecondary,
    Color? glassFill,
    Color? glassBorder,
  }) {
    return AppPalette(
      backgroundTop: backgroundTop ?? this.backgroundTop,
      backgroundBottom: backgroundBottom ?? this.backgroundBottom,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      glassFill: glassFill ?? this.glassFill,
      glassBorder: glassBorder ?? this.glassBorder,
    );
  }

  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other == null) return this;
    return AppPalette(
      backgroundTop: Color.lerp(backgroundTop, other.backgroundTop, t)!,
      backgroundBottom: Color.lerp(backgroundBottom, other.backgroundBottom, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      glassFill: Color.lerp(glassFill, other.glassFill, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
    );
  }
}

ThemeData buildAppTheme() => _buildTheme(Brightness.light);
ThemeData buildDarkTheme() => _buildTheme(Brightness.dark);

ThemeData _buildTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final palette = isDark ? AppPalette.dark : AppPalette.light;

  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
    ),
    scaffoldBackgroundColor: Colors.transparent,
    fontFamily: GoogleFonts.poppins().fontFamily,
    extensions: [palette],
  );

  final textTheme = GoogleFonts.poppinsTextTheme(base.textTheme).apply(
    bodyColor: palette.textPrimary,
    displayColor: palette.textPrimary,
  );

  return base.copyWith(
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: palette.textPrimary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withValues(alpha: isDark ? 0.08 : 0.6),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: palette.glassBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
      ),
      labelStyle: TextStyle(color: palette.textSecondary),
    ),
    dividerTheme: DividerThemeData(color: palette.glassBorder),
  );
}
