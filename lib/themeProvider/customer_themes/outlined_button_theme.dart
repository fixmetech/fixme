import 'package:flutter/material.dart';

/// -- Light & Dark Outlined Button Themes
class FixMeOutlinedButtonThemes {
  FixMeOutlinedButtonThemes._(); // To avoid creating instances

  /// -- Light Theme
  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: const Color(0xFF2563EB), // Modern blue-600
      backgroundColor: Colors.transparent,
      disabledForegroundColor: const Color(0xFF9CA3AF), // Gray-400
      disabledBackgroundColor: Colors.transparent,
      side: const BorderSide(
        color: Color(0xFF2563EB), // Modern blue-600
        width: 1.5,
      ),
      padding: const EdgeInsets.symmetric(vertical: 18),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ).copyWith(
      // Different states styling
      foregroundColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return const Color(0xFF9CA3AF); // Gray-400
          }
          if (states.contains(MaterialState.pressed)) {
            return const Color(0xFF1D4ED8); // Blue-700
          }
          if (states.contains(MaterialState.hovered)) {
            return const Color(0xFF1D4ED8); // Blue-700
          }
          return const Color(0xFF2563EB); // Blue-600
        },
      ),
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return const Color(0xFF2563EB).withOpacity(0.08);
          }
          if (states.contains(MaterialState.hovered)) {
            return const Color(0xFF2563EB).withOpacity(0.04);
          }
          return Colors.transparent;
        },
      ),
      side: MaterialStateProperty.resolveWith<BorderSide?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return const BorderSide(
              color: Color(0xFF9CA3AF), // Gray-400
              width: 1.5,
            );
          }
          if (states.contains(MaterialState.pressed)) {
            return const BorderSide(
              color: Color(0xFF1D4ED8), // Blue-700
              width: 2.0,
            );
          }
          if (states.contains(MaterialState.hovered)) {
            return const BorderSide(
              color: Color(0xFF1D4ED8), // Blue-700
              width: 1.5,
            );
          }
          if (states.contains(MaterialState.focused)) {
            return const BorderSide(
              color: Color(0xFF3B82F6), // Blue-500
              width: 2.0,
            );
          }
          return const BorderSide(
            color: Color(0xFF2563EB), // Blue-600
            width: 1.5,
          );
        },
      ),
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return const Color(0xFF2563EB).withOpacity(0.12);
          }
          if (states.contains(MaterialState.hovered)) {
            return const Color(0xFF2563EB).withOpacity(0.08);
          }
          if (states.contains(MaterialState.focused)) {
            return const Color(0xFF2563EB).withOpacity(0.12);
          }
          return null;
        },
      ),
    ),
  );

  /// -- Dark Theme
  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: const Color(0xFF60A5FA), // Modern blue-400
      backgroundColor: Colors.transparent,
      disabledForegroundColor: const Color(0xFF6B7280), // Gray-500
      disabledBackgroundColor: Colors.transparent,
      side: const BorderSide(
        color: Color(0xFF60A5FA), // Modern blue-400
        width: 1.5,
      ),
      padding: const EdgeInsets.symmetric(vertical: 18),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ).copyWith(
      // Different states styling
      foregroundColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return const Color(0xFF6B7280); // Gray-500
          }
          if (states.contains(MaterialState.pressed)) {
            return const Color(0xFF93C5FD); // Blue-300
          }
          if (states.contains(MaterialState.hovered)) {
            return const Color(0xFF93C5FD); // Blue-300
          }
          return const Color(0xFF60A5FA); // Blue-400
        },
      ),
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return const Color(0xFF60A5FA).withOpacity(0.12);
          }
          if (states.contains(MaterialState.hovered)) {
            return const Color(0xFF60A5FA).withOpacity(0.08);
          }
          return Colors.transparent;
        },
      ),
      side: MaterialStateProperty.resolveWith<BorderSide?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return const BorderSide(
              color: Color(0xFF6B7280), // Gray-500
              width: 1.5,
            );
          }
          if (states.contains(MaterialState.pressed)) {
            return const BorderSide(
              color: Color(0xFF93C5FD), // Blue-300
              width: 2.0,
            );
          }
          if (states.contains(MaterialState.hovered)) {
            return const BorderSide(
              color: Color(0xFF93C5FD), // Blue-300
              width: 1.5,
            );
          }
          if (states.contains(MaterialState.focused)) {
            return const BorderSide(
              color: Color(0xFF3B82F6), // Blue-500
              width: 2.0,
            );
          }
          return const BorderSide(
            color: Color(0xFF60A5FA), // Blue-400
            width: 1.5,
          );
        },
      ),
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return const Color(0xFF60A5FA).withOpacity(0.16);
          }
          if (states.contains(MaterialState.hovered)) {
            return const Color(0xFF60A5FA).withOpacity(0.12);
          }
          if (states.contains(MaterialState.focused)) {
            return const Color(0xFF60A5FA).withOpacity(0.16);
          }
          return null;
        },
      ),
    ),
  );
}