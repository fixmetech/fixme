
import 'package:fixme/features/authentication/screens/on_boarding.dart';
import 'package:flutter/material.dart';
import 'package:fixme/themeProvider/theme_provider.dart';
import 'package:fixme/splashScreen/splash_screen.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/utils.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FixMe',
      themeMode: ThemeMode.system,
      theme: FixMeThemes.lightTheme,
      darkTheme: FixMeThemes.darkTheme,
      home: OnboardingScreen(),
    );
  }
}