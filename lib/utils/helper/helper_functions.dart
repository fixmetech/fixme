import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FixMeHelperFunctions {
  FixMeHelperFunctions._();

  // ============ SNACKBAR & ALERTS ============

  /// Show a simple snackbar with message
  static void showSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Show a colored snackbar with custom styling
  static void showColoredSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  /// Show success snackbar
  static void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  /// Show error snackbar
  static void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  /// Show warning snackbar
  static void showWarningSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  /// Show info snackbar
  static void showInfoSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  /// Show a simple alert dialog
  static void showAlert(String title, String message) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Show confirmation dialog
  static void showConfirmationDialog(
    String title,
    String message,
    VoidCallback onConfirm, {
    String confirmText = 'Yes',
    String cancelText = 'No',
  }) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(cancelText),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }

  /// Show loading dialog
  static void showLoadingDialog(String message) {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(message),
            ],
          ),
        );
      },
    );
  }

  /// Hide loading dialog
  static void hideLoadingDialog() {
    Navigator.of(Get.context!).pop();
  }

  // ============ BOTTOM SHEETS ============

  /// Show bottom sheet
  static void showBottomSheet(Widget child) {
    showModalBottomSheet(
      context: Get.context!,
      builder: (context) => child,
    );
  }

  /// Show custom bottom sheet
  static void showCustomBottomSheet({
    required Widget child,
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => child,
    );
  }

  // ============ NAVIGATION HELPERS ============

  /// Navigate to screen and clear stack
  static void navigateToScreenAndClearStack(String routeName) {
    Get.offAllNamed(routeName);
  }

  /// Navigate to screen
  static void navigateToScreen(String routeName) {
    Get.toNamed(routeName);
  }

  /// Navigate back
  static void navigateBack() {
    Get.back();
  }

  /// Navigate to screen with data
  static void navigateToScreenWithData(String routeName, dynamic data) {
    Get.toNamed(routeName, arguments: data);
  }

  // ============ COLOR UTILITIES ============

  /// Get color from hex string
  static Color? getColorFromHex(String hexString) {
    try {
      hexString = hexString.replaceAll('#', '');
      if (hexString.length == 6) {
        hexString = 'FF$hexString';
      }
      return Color(int.parse(hexString, radix: 16));
    } catch (e) {
      return null;
    }
  }

  /// Convert color to hex string
  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  /// Check if color is dark
  static bool isDarkColor(Color color) {
    return color.computeLuminance() < 0.5;
  }

  /// Check if color is light
  static bool isLightColor(Color color) {
    return color.computeLuminance() >= 0.5;
  }

  // ============ STRING UTILITIES ============

  /// Capitalize first letter
  static String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Capitalize each word
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => capitalizeFirst(word)).join(' ');
  }

  /// Remove extra spaces
  static String removeExtraSpaces(String text) {
    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// Check if string is email
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Check if string is phone number
  static bool isValidPhoneNumber(String phone) {
    return RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$').hasMatch(phone);
  }

  /// Check if string is URL
  static bool isValidURL(String url) {
    return RegExp(r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$').hasMatch(url);
  }

  /// Format phone number
  static String formatPhoneNumber(String phone) {
    // Remove all non-digit characters
    phone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Format as (XXX) XXX-XXXX for US numbers
    if (phone.length == 10) {
      return '(${phone.substring(0, 3)}) ${phone.substring(3, 6)}-${phone.substring(6)}';
    }
    return phone;
  }

  // ============ DATE & TIME UTILITIES ============

  /// Format date to string
  static String formatDate(DateTime date, {String format = 'dd/MM/yyyy'}) {
    switch (format) {
      case 'dd/MM/yyyy':
        return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      case 'MM/dd/yyyy':
        return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
      case 'yyyy-MM-dd':
        return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      default:
        return date.toString().split(' ')[0];
    }
  }

  /// Format time to string
  static String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// Get time ago string
  static String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  // ============ LIST UTILITIES ============

  /// Check if list is null or empty
  static bool isNullOrEmpty(List? list) {
    return list == null || list.isEmpty;
  }

  /// Get safe list item
  static T? getSafeListItem<T>(List<T>? list, int index) {
    if (isNullOrEmpty(list) || index < 0 || index >= list!.length) {
      return null;
    }
    return list[index];
  }

  /// Remove duplicates from list
  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }

  // ============ NETWORK UTILITIES ============

  /// Check if device has internet connection
  static Future<bool> hasInternetConnection() async {
    try {
      // This is a simple check - for production use connectivity_plus package
      return true; // Placeholder
    } catch (e) {
      return false;
    }
  }

  // ============ THEME UTILITIES ============

  /// Get current theme mode
  static ThemeMode getCurrentThemeMode() {
    return Get.isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  /// Toggle theme mode
  static void toggleThemeMode() {
    Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
  }

  /// Check if dark mode is enabled
  static bool isDarkModeEnabled() {
    return Get.isDarkMode;
  }

  // ============ VALIDATION UTILITIES ============

  /// Validate required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate email
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!isValidEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validate password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  /// Validate phone number
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (!isValidPhoneNumber(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  // ============ STORAGE UTILITIES ============

  /// Save data to local storage (requires GetStorage or SharedPreferences)
  static void saveToLocalStorage(String key, dynamic value) {
    // Implementation depends on your storage solution
    // GetStorage().write(key, value);
  }

  /// Read data from local storage
  static T? readFromLocalStorage<T>(String key) {
    // Implementation depends on your storage solution
    // return GetStorage().read<T>(key);
    return null;
  }

  /// Remove data from local storage
  static void removeFromLocalStorage(String key) {
    // Implementation depends on your storage solution
    // GetStorage().remove(key);
  }

  /// Clear all local storage
  static void clearLocalStorage() {
    // Implementation depends on your storage solution
    // GetStorage().erase();
  }

  // ============ MISCELLANEOUS UTILITIES ============

  /// Generate random string
  static String generateRandomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(length, (index) => chars[(DateTime.now().millisecondsSinceEpoch + index) % chars.length]).join();
  }

  /// Show custom toast (requires fluttertoast package)
  static void showToast(String message) {
    // Implementation with fluttertoast package
    // Fluttertoast.showToast(
    //   msg: message,
    //   toastLength: Toast.LENGTH_SHORT,
    //   gravity: ToastGravity.BOTTOM,
    // );
  }
}