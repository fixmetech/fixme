import 'package:firebase_core/firebase_core.dart';
import 'package:fixme/app.dart';
import 'package:fixme/firebase_options.dart';
import 'package:fixme/global/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(); 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  ).then(
    (FirebaseApp value) => Get.put(AuthenticationRepository()),
  );
  runApp(const MyApp());
}

