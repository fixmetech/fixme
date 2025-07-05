
import 'package:flutter/material.dart';
import 'package:fixme/themeProvider/theme_provider.dart';
import 'package:fixme/splashScreen/splash_screen.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FixMe',
      themeMode: ThemeMode.system,
      theme: FixMeThemes.lightTheme,
      darkTheme: FixMeThemes.darkTheme,
      home: SplashScreen(),
    );
  }
}