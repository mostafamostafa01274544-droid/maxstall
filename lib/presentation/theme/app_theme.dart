import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  AppColors._();
  static const background   = Color(0xFF0A0E1A);
  static const surface      = Color(0xFF111827);
  static const glassWhite   = Color(0x1AFFFFFF);
  static const glassBorder  = Color(0x33FFFFFF);
  static const neonPrimary  = Color(0xFF00F5C4);  // vivid mint
  static const neonSecondary= Color(0xFF7C5CFC);  // electric violet
  static const neonAccent   = Color(0xFFFF6B9D);  // hot pink
  static const textPrimary  = Color(0xFFEDF2FF);
  static const textSecondary= Color(0xFF8892B0);

  static const gradientPrimary = LinearGradient(
    colors: [Color(0xFF00F5C4), Color(0xFF7C5CFC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientBackground = LinearGradient(
    colors: [Color(0xFF0A0E1A), Color(0xFF1A0A2E), Color(0xFF0A1A1A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary:   AppColors.neonPrimary,
          secondary: AppColors.neonSecondary,
          surface:   AppColors.surface,
          onSurface: AppColors.textPrimary,
          onPrimary: AppColors.background,
        ),
        textTheme: const TextTheme(
          displayMedium: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
            fontSize: 32,
            letterSpacing: -1,
          ),
          titleLarge: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
          titleMedium: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          bodyMedium: TextStyle(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          labelSmall: TextStyle(
            color: AppColors.neonPrimary,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
      );
}
