import 'package:flutter/material.dart';

class FixMeTextButtonThemes{
  FixMeTextButtonThemes._();
  // Primary blue color palette
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color lightBlue = Color(0xFF64B5F6);
  static const Color darkBlue = Color(0xFF1976D2);
  static const Color disabledBlue = Color(0xFFBBDEFB);
  
  // Light theme TextButton
  static TextButtonThemeData lightTextButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: primaryBlue,
      backgroundColor: Colors.transparent,
      disabledForegroundColor: disabledBlue,
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0,
      overlayColor: primaryBlue.withOpacity(0.1),
    ).copyWith(
      // Custom state-based styling
      foregroundColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return disabledBlue;
          }
          if (states.contains(MaterialState.pressed)) {
            return darkBlue;
          }
          if (states.contains(MaterialState.hovered)) {
            return darkBlue;
          }
          return primaryBlue;
        },
      ),
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return primaryBlue.withOpacity(0.1);
          }
          if (states.contains(MaterialState.hovered)) {
            return primaryBlue.withOpacity(0.05);
          }
          return Colors.transparent;
        },
      ),
    ),
  );

  // Dark theme TextButton
  static TextButtonThemeData darkTextButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: lightBlue,
      backgroundColor: Colors.transparent,
      disabledForegroundColor: disabledBlue.withOpacity(0.5),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0,
      overlayColor: lightBlue.withOpacity(0.1),
    ).copyWith(
      foregroundColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return disabledBlue.withOpacity(0.5);
          }
          if (states.contains(MaterialState.pressed)) {
            return Colors.white;
          }
          if (states.contains(MaterialState.hovered)) {
            return Colors.white;
          }
          return lightBlue;
        },
      ),
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return lightBlue.withOpacity(0.2);
          }
          if (states.contains(MaterialState.hovered)) {
            return lightBlue.withOpacity(0.1);
          }
          return Colors.transparent;
        },
      ),
    ),
  );

  // Outlined blue TextButton style
  static ButtonStyle outlinedBlueTextButtonStyle = TextButton.styleFrom(
    foregroundColor: primaryBlue,
    backgroundColor: Colors.transparent,
    side: const BorderSide(color: primaryBlue, width: 1.5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  ).copyWith(
    foregroundColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return disabledBlue;
        }
        if (states.contains(MaterialState.pressed)) {
          return Colors.white;
        }
        return primaryBlue;
      },
    ),
    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return primaryBlue;
        }
        if (states.contains(MaterialState.hovered)) {
          return primaryBlue.withOpacity(0.1);
        }
        return Colors.transparent;
      },
    ),
    side: MaterialStateProperty.resolveWith<BorderSide?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return BorderSide(color: disabledBlue, width: 1.5);
        }
        return const BorderSide(color: primaryBlue, width: 1.5);
      },
    ),
  );

  // Filled blue TextButton style
  static ButtonStyle filledBlueTextButtonStyle = TextButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: primaryBlue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  ).copyWith(
    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return disabledBlue;
        }
        if (states.contains(MaterialState.pressed)) {
          return darkBlue;
        }
        if (states.contains(MaterialState.hovered)) {
          return darkBlue;
        }
        return primaryBlue;
      },
    ),
  );

  // Gradient blue TextButton style
  static ButtonStyle gradientBlueTextButtonStyle = TextButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    padding: EdgeInsets.zero,
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );

  // Custom gradient TextButton widget
  static Widget gradientTextButton({
    required String text,
    required VoidCallback? onPressed,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryBlue, lightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        style: gradientBlueTextButtonStyle,
        child: Padding(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
