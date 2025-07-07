
import 'package:fixme/features/authentication/screens/login.dart';
import 'package:fixme/features/authentication/screens/on_boarding.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthenticationRepository extends GetxController{
  static AuthenticationRepository get instance => Get.find();

  // variables
  final deviceStorage = GetStorage();
  
  // call from main.dart app
  @override
  void onReady(){
   // FlutterNativeSplashScreen.remove();
    screenRedirect();
  }

  // Flutter function to show relvent screen
  screenRedirect() async{
    deviceStorage.writeIfNull('isFirstTime', true);
    deviceStorage.read('isFirstTime') != true
        ? Get.offAll(LoginScreen())
        : Get.offAll(OnboardingScreen());
  }

}