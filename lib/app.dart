import 'package:fixme/bindings/general_binding.dart';
import 'package:fixme/features/authentication/controller/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:fixme/themeProvider/theme_provider.dart';
import 'package:fixme/splashScreen/splash_screen.dart';
import 'package:get/get.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(SignupController());
    return GetMaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'FixMe',
      themeMode: ThemeMode.system,
      theme: FixMeThemes.lightTheme,
      darkTheme: FixMeThemes.darkTheme,
      initialBinding: GeneralBinding(),
      home: SplashScreen(),
    );
  }
}