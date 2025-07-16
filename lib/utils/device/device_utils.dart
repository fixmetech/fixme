import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FixMeDeviceUtils {
  FixMeDeviceUtils._();

  // ============ SCREEN & DISPLAY ============
  
  /// Get screen width
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get screen height
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Get screen pixel ratio
  static double getPixelRatio() {
    return WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
  }

  /// Get status bar height
  static double getStatusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  /// Get bottom navigation bar height
  static double getBottomNavigationBarHeight() {
    return kBottomNavigationBarHeight;
  }

  /// Get app bar height
  static double getAppBarHeight() {
    return kToolbarHeight;
  }

  /// Get keyboard height
  static double getKeyboardHeight(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    return viewInsets.bottom;
  }

  /// Check if keyboard is visible
  static bool isKeyboardVisible(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    return viewInsets.bottom > 0;
  }

  /// Get safe area padding
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// Get available screen height (excluding status bar, app bar, etc.)
  static double getAvailableScreenHeight(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    final statusBarHeight = getStatusBarHeight(context);
    final appBarHeight = getAppBarHeight();
    return screenHeight - statusBarHeight - appBarHeight;
  }

  // ============ DEVICE ORIENTATION ============

  /// Get current device orientation
  static Orientation getOrientation(BuildContext context) {
    return MediaQuery.of(context).orientation;
  }

  /// Check if device is in portrait mode
  static bool isPortrait(BuildContext context) {
    return getOrientation(context) == Orientation.portrait;
  }

  /// Check if device is in landscape mode
  static bool isLandscape(BuildContext context) {
    return getOrientation(context) == Orientation.landscape;
  }

  /// Set preferred orientations
  static void setPreferredOrientations(List<DeviceOrientation> orientations) {
    SystemChrome.setPreferredOrientations(orientations);
  }

  /// Set portrait orientation only
  static void setPortraitOrientation() {
    setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  /// Set landscape orientation only
  static void setLandscapeOrientation() {
    setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// Allow all orientations
  static void setAllOrientations() {
    setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  // ============ DEVICE TYPE DETECTION ============

  /// Check if running on physical device
  static bool isPhysicalDevice() {
    return defaultTargetPlatform == TargetPlatform.android ||
           defaultTargetPlatform == TargetPlatform.iOS;
  }

  /// Check if running on Android
  static bool isAndroid() {
    return defaultTargetPlatform == TargetPlatform.android;
  }

  /// Check if running on iOS
  static bool isIOS() {
    return defaultTargetPlatform == TargetPlatform.iOS;
  }

  /// Check if running on Web
  static bool isWeb() {
    return kIsWeb;
  }

  /// Check if running on Desktop
  static bool isDesktop() {
    return defaultTargetPlatform == TargetPlatform.linux ||
           defaultTargetPlatform == TargetPlatform.macOS ||
           defaultTargetPlatform == TargetPlatform.windows;
  }

  /// Check if running on Mobile
  static bool isMobile() {
    return isAndroid() || isIOS();
  }

  /// Check if running on Tablet (based on screen size)
  static bool isTablet(BuildContext context) {
    final screenWidth = getScreenWidth(context);
    return screenWidth >= 600; // Generally tablets are 600dp and above
  }

  /// Check if running on Phone (based on screen size)
  static bool isPhone(BuildContext context) {
    return !isTablet(context);
  }

  // ============ SCREEN SIZE CATEGORIES ============

  /// Check if screen is extra small (< 600dp)
  static bool isExtraSmallScreen(BuildContext context) {
    return getScreenWidth(context) < 600;
  }

  /// Check if screen is small (600dp - 840dp)
  static bool isSmallScreen(BuildContext context) {
    final width = getScreenWidth(context);
    return width >= 600 && width < 840;
  }

  /// Check if screen is medium (840dp - 1200dp)
  static bool isMediumScreen(BuildContext context) {
    final width = getScreenWidth(context);
    return width >= 840 && width < 1200;
  }

  /// Check if screen is large (1200dp - 1600dp)
  static bool isLargeScreen(BuildContext context) {
    final width = getScreenWidth(context);
    return width >= 1200 && width < 1600;
  }

  /// Check if screen is extra large (>= 1600dp)
  static bool isExtraLargeScreen(BuildContext context) {
    return getScreenWidth(context) >= 1600;
  }

  // ============ RESPONSIVE HELPERS ============

  /// Get responsive value based on screen size
  static T getResponsiveValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop()) {
      return desktop ?? tablet ?? mobile;
    } else if (isTablet(context)) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }

  /// Get responsive font size
  static double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = getScreenWidth(context);
    if (screenWidth < 600) {
      return baseFontSize * 0.9; // Smaller for phones
    } else if (screenWidth < 1200) {
      return baseFontSize; // Normal for tablets
    } else {
      return baseFontSize * 1.1; // Larger for desktop
    }
  }

  /// Get responsive padding
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final screenWidth = getScreenWidth(context);
    if (screenWidth < 600) {
      return const EdgeInsets.all(16.0);
    } else if (screenWidth < 1200) {
      return const EdgeInsets.all(24.0);
    } else {
      return const EdgeInsets.all(32.0);
    }
  }

  // ============ SYSTEM UI CONTROLS ============

  /// Hide status bar
  static void hideStatusBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  /// Show status bar
  static void showStatusBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, 
        overlays: SystemUiOverlay.values);
  }

  /// Set status bar color
  static void setStatusBarColor(Color color) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: color),
    );
  }

  /// Set light status bar (dark icons)
  static void setLightStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  /// Set dark status bar (light icons)
  static void setDarkStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  /// Enable full screen mode
  static void enableFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  /// Exit full screen mode
  static void exitFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  // ============ HAPTIC FEEDBACK ============

  /// Light haptic feedback
  static void lightHaptic() {
    HapticFeedback.lightImpact();
  }

  /// Medium haptic feedback
  static void mediumHaptic() {
    HapticFeedback.mediumImpact();
  }

  /// Heavy haptic feedback
  static void heavyHaptic() {
    HapticFeedback.heavyImpact();
  }

  /// Selection haptic feedback
  static void selectionHaptic() {
    HapticFeedback.selectionClick();
  }

  /// Vibrate device
  static void vibrate() {
    HapticFeedback.vibrate();
  }

  // ============ DEVICE INFO ============

  /// Get device type string
  static String getDeviceType(BuildContext context) {
    if (isDesktop()) {
      return 'Desktop';
    } else if (isTablet(context)) {
      return 'Tablet';
    } else if (isMobile()) {
      return 'Mobile';
    } else if (isWeb()) {
      return 'Web';
    } else {
      return 'Unknown';
    }
  }

  /// Get platform name
  static String getPlatformName() {
    if (isAndroid()) {
      return 'Android';
    } else if (isIOS()) {
      return 'iOS';
    } else if (isWeb()) {
      return 'Web';
    } else {
      return defaultTargetPlatform.name;
    }
  }

  /// Get screen size category
  static String getScreenSizeCategory(BuildContext context) {
    if (isExtraSmallScreen(context)) {
      return 'Extra Small';
    } else if (isSmallScreen(context)) {
      return 'Small';
    } else if (isMediumScreen(context)) {
      return 'Medium';
    } else if (isLargeScreen(context)) {
      return 'Large';
    } else {
      return 'Extra Large';
    }
  }

  // ============ UTILITY FUNCTIONS ============

  /// Hide keyboard
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  /// Show keyboard
  static void showKeyboard(BuildContext context, FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  /// Check if device has notch/safe area
  static bool hasNotch(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return padding.top > 20; // Typical status bar height is 20-24
  }

  /// Get safe area insets
  static EdgeInsets getSafeAreaInsets(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// Launch URL (requires url_launcher package)
  static void launchURL(String url) {
    // Note: This requires url_launcher package
    // You can uncomment and use this if you have the package installed
    // launchUrl(Uri.parse(url));
  }

  /// Copy text to clipboard
  static void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  /// Get text from clipboard
  static Future<String?> getFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text;
  }

  /// Check if device supports haptic feedback
  static bool supportsHapticFeedback() {
    return isMobile(); // Generally mobile devices support haptic feedback
  }

  /// Get current brightness
  static Brightness getCurrentBrightness(BuildContext context) {
    return MediaQuery.of(context).platformBrightness;
  }

  /// Check if device is in dark mode
  static bool isDarkMode(BuildContext context) {
    return getCurrentBrightness(context) == Brightness.dark;
  }

  /// Check if device is in light mode
  static bool isLightMode(BuildContext context) {
    return getCurrentBrightness(context) == Brightness.light;
  }
}