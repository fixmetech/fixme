import 'package:flutter/material.dart';

/// -- Light & Dark Bottom Sheet Themes
class FixMeBottomSheetThemes {
  FixMeBottomSheetThemes._(); // Private constructor to prevent instantiation

  /// -- Light Theme
  static final BottomSheetThemeData lightBottomSheetTheme = BottomSheetThemeData(
    showDragHandle: true,
    backgroundColor: Colors.white,
    modalBackgroundColor: Colors.white,
    constraints: const BoxConstraints(minWidth: double.infinity),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  );

  /// -- Dark Theme
  static final BottomSheetThemeData darkBottomSheetTheme = BottomSheetThemeData(
    showDragHandle: true,
    backgroundColor: Colors.black,
    modalBackgroundColor: Colors.black,
    constraints: const BoxConstraints(minWidth: double.infinity),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  );
}
