import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Arabic-first retail theme inspired by the provided Sanko Mall mockup.
class AppTheme {
  AppTheme._();

  static const Color _seed = Color(0xFF0F8A42);
  static const Color _brand = Color(0xFF138A3B);
  static const Color _brandDark = Color(0xFF0E6A2D);
  static const Color _canvasLight = Color(0xFFF6F8F4);
  static const Color _cardLight = Color(0xFFFFFFFF);
  static const double _radiusValue = 20;

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static BorderRadius get cardRadius => BorderRadius.circular(_radiusValue);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
    );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
    );
    final textTheme = GoogleFonts.cairoTextTheme(base.textTheme).copyWith(
      headlineMedium: GoogleFonts.cairo(fontWeight: FontWeight.w800),
      titleLarge: GoogleFonts.cairo(fontWeight: FontWeight.w700),
      titleMedium: GoogleFonts.cairo(fontWeight: FontWeight.w700),
      bodyLarge: GoogleFonts.cairo(fontWeight: FontWeight.w600),
      bodyMedium: GoogleFonts.cairo(fontWeight: FontWeight.w600),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: isDark ? const Color(0xFF111A13) : _canvasLight,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? Colors.white : const Color(0xFF1E2A1E),
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : const Color(0xFF1E2A1E),
        ),
        actionsIconTheme: IconThemeData(
          color: isDark ? Colors.white : const Color(0xFF1E2A1E),
        ),
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: isDark ? Colors.white : const Color(0xFF1E2A1E),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: isDark ? const Color(0xFF19231B) : _cardLight,
        shape: RoundedRectangleBorder(
          borderRadius: cardRadius,
          side: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : const Color(0xFFE7ECE5),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _brand,
          foregroundColor: Colors.white,
          // Width stays bounded so buttons can live inside a Row.
          minimumSize: const Size(0, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF1A251C) : const Color(0xFFF1F5EE),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : const Color(0xFFE2EAE0),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 74,
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF19231B) : Colors.white,
        indicatorColor: _brand.withValues(alpha: 0.14),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? _brandDark : Colors.black54);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.cairo(
            color: selected ? _brandDark : Colors.black54,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
          );
        }),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: isDark
            ? const Color(0xFF1A251C)
            : const Color(0xFFEAF3E8),
        selectedColor: _brand,
        labelStyle: GoogleFonts.cairo(fontWeight: FontWeight.w700),
      ),
    );
  }
}
