import 'package:firebase_core/firebase_core.dart';
import 'package:fixme/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(); 
  await Firebase.initializeApp();
  runApp(const MyApp());
}

