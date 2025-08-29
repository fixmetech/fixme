import 'package:fixme/themeProvider/customer_themes/appbar_theme.dart';
import 'package:fixme/themeProvider/customer_themes/bottom_sheet_theme.dart';
import 'package:fixme/themeProvider/customer_themes/checkbox_theme.dart';
import 'package:fixme/themeProvider/customer_themes/elevated_button_theme.dart';
import 'package:fixme/themeProvider/customer_themes/outlined_button_theme.dart';
import 'package:fixme/themeProvider/customer_themes/text_button_theme.dart';
import 'package:fixme/themeProvider/customer_themes/text_field_theme.dart';
import 'package:fixme/themeProvider/customer_themes/text_theme.dart';
import 'package:flutter/material.dart';

class FixMeThemes {
  FixMeThemes._(); // Private constructor to prevent instantiation

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'poppins',
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(),
    textTheme: FixMeTextThemes.lightTextTheme,
    elevatedButtonTheme: FixMeElevetedButtonThemes.lightElevatedButtonTheme,
    outlinedButtonTheme: FixMeOutlinedButtonThemes.lightOutlinedButtonTheme ,
    textButtonTheme: FixMeTextButtonThemes.lightTextButtonTheme,
    appBarTheme: FixMeAppBarThemes.lightAppBarTheme,
    bottomSheetTheme: FixMeBottomSheetThemes.lightBottomSheetTheme,
    checkboxTheme: FixMeCheckboxThemes.lightCheckboxTheme,
    inputDecorationTheme: FixMeTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: ColorScheme.dark(),
    textTheme: FixMeTextThemes.darkTextTheme,
    elevatedButtonTheme: FixMeElevetedButtonThemes.darkElevatedButtonTheme,
    outlinedButtonTheme: FixMeOutlinedButtonThemes.darkOutlinedButtonTheme,
    textButtonTheme: FixMeTextButtonThemes.darkTextButtonTheme,
    appBarTheme: FixMeAppBarThemes.darkAppBarTheme,
    bottomSheetTheme: FixMeBottomSheetThemes.darkBottomSheetTheme,
    checkboxTheme: FixMeCheckboxThemes.darkCheckboxTheme,
    inputDecorationTheme: FixMeTextFormFieldTheme.darkInputDecorationTheme,
  );
}
