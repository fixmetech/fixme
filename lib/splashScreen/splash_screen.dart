import 'dart:async';

import 'package:fixme/Assistants/assistant_methods.dart';
import 'package:fixme/global/global.dart';
import 'package:fixme/mainScreen.dart';
import 'package:fixme/screens/login_screen.dart';
import 'package:flutter/material.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  startTimer() {
    Timer(Duration(seconds: 3), () async {
      if (await firebaseAuth.currentUser != null) {
        firebaseAuth.currentUser != null ? AssistantMethods.readCurrentOnlineUserInfo() : null;
        Navigator.push(context, MaterialPageRoute(builder: (c) => MainScreen()));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    // Setup animations
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _animationController.forward();
    _fadeController.forward();

    startTimer();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E3A8A), // Deep blue
              Color(0xFF3B82F6), // Blue
              Color(0xFF60A5FA), // Light blue
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Icon with wrench and car elements
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Car icon
                            Icon(
                              Icons.directions_car,
                              size: 50,
                              color: Color(0xFF1E3A8A),
                            ),
                            // Wrench icon positioned to overlap
                            Positioned(
                              bottom: 25,
                              right: 25,
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Color(0xFFEF4444), // Red accent
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.build,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),

                      // App Name
                      Text(
                        'FixMe',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.3),
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),

                      // Tagline
                      Text(
                        'All Services at Your Fingertips',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 50),

                      // Loading indicator
                      Container(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}