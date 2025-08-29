import 'package:flutter/material.dart';

class FixMeTextThemes {
  FixMeTextThemes._(); // Private constructor to prevent instantiation

  static TextTheme lightTextTheme = TextTheme(
    bodyLarge: TextStyle().copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.black87,
    ),
    bodyMedium: TextStyle().copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black54,
    ),
    bodySmall: TextStyle().copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Colors.black45,
    ),

    titleLarge: const TextStyle().copyWith(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    titleMedium: const TextStyle().copyWith(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    titleSmall: const TextStyle().copyWith(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),

    headlineLarge: TextStyle().copyWith(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    headlineMedium: TextStyle().copyWith(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
    headlineSmall: TextStyle().copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    ),

    labelLarge: const TextStyle().copyWith(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    labelMedium: const TextStyle().copyWith(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Colors.black.withOpacity(0.5),
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    bodyLarge: TextStyle().copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white70,
    ),
    bodyMedium: TextStyle().copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.white60,
    ),
    bodySmall: TextStyle().copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Colors.white54,
    ),

    titleLarge: const TextStyle().copyWith(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    titleMedium: const TextStyle().copyWith(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    titleSmall: const TextStyle().copyWith(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),

    headlineLarge: TextStyle().copyWith(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white70,
    ),
    headlineMedium: TextStyle().copyWith(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white70,
    ),
    headlineSmall: TextStyle().copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.white70,
    ),

    labelLarge: const TextStyle().copyWith(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    labelMedium: const TextStyle().copyWith(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Colors.white.withOpacity(0.5),
    ),
  );
}
