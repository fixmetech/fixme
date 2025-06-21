import 'dart:async';

import 'package:fixme/Assistants/assistant_methods.dart';
import 'package:fixme/global/global.dart';
import 'package:fixme/screens/login_screen.dart';
import 'package:fixme/screens/home_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}



class _SplashScreenState extends State<SplashScreen> {

  startTimer(){
    Timer(Duration(seconds: 3), () async{
      if(await firebaseAuth.currentUser != null){
        firebaseAuth.currentUser != null ? AssistantMethods.readCurrentOnlineUserInfo():null;
        Navigator.push(context, MaterialPageRoute(builder: (c)=>LoginScreen()));
      }else{
        Navigator.push(context, MaterialPageRoute(builder: (c)=>LoginScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'FixMe',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 60,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}
