import 'package:firebase_core/firebase_core.dart';
import 'package:fixme/app.dart';
import 'package:fixme/data/repositories/authentication_repository.dart';
import 'package:fixme/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


Future<void> main() async{
  final WidgetsBinding widgetsBinding =  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(); 
  await GetStorage.init();
 // FlutterNativeSplashScreen.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  ).then(
    (FirebaseApp value) => Get.put(AuthenticationRepository()),
  );
  runApp(const MyApp());
}

