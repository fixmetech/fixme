import 'package:flutter/material.dart';

/// Custom Class for Light & Dark Checkbox Themes
class FixMeCheckboxThemes {
  FixMeCheckboxThemes._(); // Private constructor to avoid creating instances

  /// -- Light Checkbox Theme
  static final CheckboxThemeData lightCheckboxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
    checkColor: MaterialStateProperty.resolveWith<Color>((states) {
      return states.contains(MaterialState.selected) ? Colors.white : Colors.black;
    }),
    fillColor: MaterialStateProperty.resolveWith<Color>((states) {
      return states.contains(MaterialState.selected) ? Colors.blue : Colors.transparent;
    }),
  );

  /// -- Dark Checkbox Theme
  static final CheckboxThemeData darkCheckboxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
    checkColor: MaterialStateProperty.resolveWith<Color>((states) {
      return states.contains(MaterialState.selected) ? Colors.white : Colors.black;
    }),
    fillColor: MaterialStateProperty.resolveWith<Color>((states) {
      return states.contains(MaterialState.selected) ? Colors.blue : Colors.transparent;
    }),
  );
}
