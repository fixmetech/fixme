import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fixme/utils/helper/helper_functions.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

/// Manages the network connectivity status and provides methods to check and handle connectivity changes.
class NetworkManager extends GetxController {
  static NetworkManager get instance => Get.find();
  
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final RxList<ConnectivityResult> _connectionStatus = <ConnectivityResult>[ConnectivityResult.none].obs;
  
  // Getter for connection status
  List<ConnectivityResult> get connectionStatus => _connectionStatus.value;
  
  // Check if device has any network connection
  bool get isConnected => !_connectionStatus.contains(ConnectivityResult.none) && _connectionStatus.isNotEmpty;
  
  // Get primary connection type
  ConnectivityResult get primaryConnectionType => _connectionStatus.isNotEmpty ? _connectionStatus.first : ConnectivityResult.none;
  
  /// Initialize the network manager and set up a stream to continually check the connection status.
  @override
  void onInit() {
    super.onInit();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _initializeConnectionStatus();
  }
  
  /// Initialize connection status on app start
  Future<void> _initializeConnectionStatus() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _connectionStatus.value = result;
    } catch (e) {
      _connectionStatus.value = [ConnectivityResult.none];
    }
  }
  
  /// Update the connection status based on changes in connectivity and show a relevant popup for no internet connection.
  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    _connectionStatus.value = results;
    
    if (results.contains(ConnectivityResult.none) || results.isEmpty) {
      // Show warning only if not in debug mode to avoid spam during development
      if (!kDebugMode) {
        FixMeHelperFunctions.showWarningSnackBar('Network Error','No Internet Connection');
      }
    } else {
      // Verify actual internet connectivity
      final hasInternet = await hasInternetAccess();
      if (!hasInternet && !kDebugMode) {
        // TLoaders.warningSnackBar(title: 'No Internet Access');
       FixMeHelperFunctions.showWarningSnackBar('Network Error','No Internet Access');
      }
    }
  }
  

  /// Check the internet connection status.
  /// Returns 'true' if connected, 'false' otherwise.
  Future<bool> isConnectedToInternet() async {
    try {
      final results = await _connectivity.checkConnectivity();
      if (results.contains(ConnectivityResult.none) || results.isEmpty) {
        return false;
      }
      // Double-check with actual internet access
      return await hasInternetAccess();
    } catch (e) {
      return false;
    }
  }
  
  /// Check if device has actual internet access by pinging a reliable server
  Future<bool> hasInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } catch (e) {
      return false;
    }
  }
  
  /// Get current connectivity status
  Future<List<ConnectivityResult>> checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _connectionStatus.value = results;
      return results;
    } catch (e) {
      _connectionStatus.value = [ConnectivityResult.none];
      return [ConnectivityResult.none];
    }
  }
  
  /// Check if connected to WiFi
  bool get isConnectedToWiFi => _connectionStatus.contains(ConnectivityResult.wifi);
  
  /// Check if connected to mobile data
  bool get isConnectedToMobile => _connectionStatus.contains(ConnectivityResult.mobile);
  
  /// Check if connected to ethernet
  bool get isConnectedToEthernet => _connectionStatus.contains(ConnectivityResult.ethernet);
  
  /// Get connection type as string
  String get connectionType {
    if (_connectionStatus.isEmpty || _connectionStatus.contains(ConnectivityResult.none)) {
      return 'No Connection';
    }
    
    List<String> types = [];
    if (_connectionStatus.contains(ConnectivityResult.wifi)) types.add('WiFi');
    if (_connectionStatus.contains(ConnectivityResult.mobile)) types.add('Mobile Data');
    if (_connectionStatus.contains(ConnectivityResult.ethernet)) types.add('Ethernet');
    
    return types.isNotEmpty ? types.join(', ') : 'Unknown';
  }
  
  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
}

// HELPER FUNCTIONS

/// Global helper function to check internet connectivity
Future<bool> checkInternetConnectivity() async {
  try {
    // Check if NetworkManager is initialized
    if (Get.isRegistered<NetworkManager>()) {
      return await NetworkManager.instance.isConnectedToInternet();
    } else {
      // Fallback if NetworkManager is not initialized
      final connectivity = Connectivity();
      final results = await connectivity.checkConnectivity();
      
      if (results.contains(ConnectivityResult.none) || results.isEmpty) {
        return false;
      }
      
      // Verify actual internet access
      try {
        final internetResult = await InternetAddress.lookup('google.com');
        return internetResult.isNotEmpty && internetResult[0].rawAddress.isNotEmpty;
      } on SocketException catch (_) {
        return false;
      }
    }
  } catch (e) {
    return false;
  }
}

/// Helper function to check connectivity and show appropriate message
Future<bool> checkConnectivityWithMessage({
  String? noConnectionMessage,
  bool showDialog = true,
}) async {
  final isConnected = await checkInternetConnectivity();
  
  if (!isConnected && showDialog) {
    final message = noConnectionMessage ?? 'No internet connection. Please check your connection and try again.';
    
    FixMeHelperFunctions.showWarningSnackBar('Network',message);
  }
  
  return isConnected;
}

/// Helper function to execute a function only if connected to internet
Future<T?> executeIfConnected<T>({
  required Future<T> Function() onConnected,
  VoidCallback? onDisconnected,
  String? noConnectionMessage,
  bool showMessage = true,
}) async {
  final isConnected = await checkInternetConnectivity();
  
  if (isConnected) {
    return await onConnected();
  } else {
    if (showMessage) {
      await checkConnectivityWithMessage(
        noConnectionMessage: noConnectionMessage,
        showDialog: showMessage,
      );
    }
    onDisconnected?.call();
    return null;
  }
}

/// Helper function to retry a function until internet is available
Future<T?> retryUntilConnected<T>({
  required Future<T> Function() function,
  int maxRetries = 3,
  Duration retryDelay = const Duration(seconds: 2),
  String? noConnectionMessage,
}) async {
  int attempts = 0;
  
  while (attempts < maxRetries) {
    final isConnected = await checkInternetConnectivity();
    
    if (isConnected) {
      try {
        return await function();
      } catch (e) {
        attempts++;
        if (attempts >= maxRetries) rethrow;
        await Future.delayed(retryDelay);
      }
    } else {
      attempts++;
      if (attempts >= maxRetries) {
        await checkConnectivityWithMessage(
          noConnectionMessage: noConnectionMessage ?? 'Unable to connect to internet after $maxRetries attempts.',
        );
        return null;
      }
      await Future.delayed(retryDelay);
    }
  }
  
  return null;
}

/// Helper function to get connection status as string
String getConnectionStatus() {
  if (Get.isRegistered<NetworkManager>()) {
    return NetworkManager.instance.connectionType;
  }
  return 'Unknown';
}

/// Helper function to check if connected to WiFi
bool isConnectedToWiFi() {
  if (Get.isRegistered<NetworkManager>()) {
    return NetworkManager.instance.isConnectedToWiFi;
  }
  return false;
}

/// Helper function to check if connected to mobile data
bool isConnectedToMobile() {
  if (Get.isRegistered<NetworkManager>()) {
    return NetworkManager.instance.isConnectedToMobile;
  }
  return false;
}