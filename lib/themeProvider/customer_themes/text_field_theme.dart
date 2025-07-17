import 'package:flutter/material.dart';

class FixMeTextFormFieldTheme {
  FixMeTextFormFieldTheme._(); // Private constructor

  /// Light Theme
  static final InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
    labelStyle: const TextStyle(
      fontSize: 14,
      color: Colors.black,
    ),
    hintStyle: const TextStyle(
      fontSize: 14,
      color: Colors.black,
    ),
    errorStyle: const TextStyle(
      fontStyle: FontStyle.normal,
    ),
    floatingLabelStyle: TextStyle(
      color: Colors.black.withOpacity(0.8),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Colors.black12),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 2, color: Colors.orange),
    ),
  );

  /// Dark Theme (you can customize further if needed)
  static final InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: Colors.grey[300],
    suffixIconColor: Colors.grey[300],
    labelStyle: const TextStyle(
      fontSize: 14,
      color: Colors.white,
    ),
    hintStyle: const TextStyle(
      fontSize: 14,
      color: Colors.white70,
    ),
    errorStyle: const TextStyle(
      fontStyle: FontStyle.normal,
    ),
    floatingLabelStyle: TextStyle(
      color: Colors.white.withOpacity(0.8),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Colors.white),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Colors.white),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Colors.white70),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Colors.redAccent),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 2, color: Colors.orangeAccent),
    ),
  );
}
