import 'package:firebase_core/firebase_core.dart';
import 'package:fixme/screens/login_screen.dart';
import 'package:fixme/splashScreen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:fixme/screens/register_screen.dart';
import 'package:fixme/themeProvider/theme_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(); // Load environment variables from .env file
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FixMe',
      themeMode: ThemeMode.system,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      home: SplashScreen(),
    );
  }
}

