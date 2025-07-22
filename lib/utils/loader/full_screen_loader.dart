import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fixme/utils/constants/colors.dart';
import 'package:fixme/utils/constants/size.dart';

// Helper function to ensure opacity is within valid range
double _clampOpacity(double opacity) {
  return opacity.clamp(0.0, 1.0);
}

class FullScreenLoader {
  static bool _isLoaderVisible = false;

  static void showLoader({
    required BuildContext context,
    required String text,
    required String lottieAsset,
  }) {
    if (_isLoaderVisible) return;
    _isLoaderVisible = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: Colors.black.withOpacity(_clampOpacity(0.2)),
          child: Center(
            child: TweenAnimationBuilder(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              builder: (context, value, child) => Transform.scale(
                scale: value.clamp(0.0, 1.0),
                child: Opacity(
                  opacity: value.clamp(0.0, 1.0),
                  child: Container(
                    padding: EdgeInsets.all(32),
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(_clampOpacity(0.9)),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(_clampOpacity(0.3)),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(_clampOpacity(0.1)),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset(
                          lottieAsset,
                          width: 100,
                          height: 100,
                        ),
                        SizedBox(height: FixMeSizes.md),
                        Text(
                          text,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: FixMeColors.dark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void showMinimalisticLoader({
    required BuildContext context,
    required String text,
    required String lottieAsset,
    double animationSize = 80,
    double fontSize = 14,
    Color textColor = const Color(0xFF6B7280),
    FontWeight fontWeight = FontWeight.w500,
  }) {
    if (_isLoaderVisible) return;
    _isLoaderVisible = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (_) => Container(
        color: Colors.white,
        child: Center(
          child: TweenAnimationBuilder(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) => Transform.translate(
              offset: Offset(0, 20 * (1 - value.clamp(0.0, 1.0))),
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      lottieAsset,
                      width: animationSize,
                      height: animationSize,
                    ),
                    SizedBox(height: 32),
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                        color: textColor,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void showCleanLoader({
    required BuildContext context,
    required String text,
    Color backgroundColor = Colors.white,
    Color primaryColor = FixMeColors.primary,
    Color textColor = FixMeColors.black,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    if (_isLoaderVisible) return;
    _isLoaderVisible = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (_) => Container(
        color: backgroundColor,
        child: Center(
          child: TweenAnimationBuilder(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) => Transform.translate(
              offset: Offset(0, 30 * (1 - value.clamp(0.0, 1.0))),
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      child: TweenAnimationBuilder(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 1200),
                        curve: Curves.linear,
                        builder: (context, rotation, child) => Transform.rotate(
                          angle: rotation.clamp(0.0, 1.0) * 2 * 3.14159,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: primaryColor.withOpacity(_clampOpacity(0.2)),
                                width: 3,
                              ),
                            ),
                            child: Container(
                              margin: EdgeInsets.all(8),
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    primaryColor,
                                    primaryColor.withOpacity(_clampOpacity(0.3)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                        color: textColor,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void hideLoader(BuildContext context) {
    if (_isLoaderVisible) {
      _isLoaderVisible = false;
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
