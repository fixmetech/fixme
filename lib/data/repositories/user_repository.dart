import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixme/utils/http/http_client.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /// Get current user data from Firestore
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  /// Update user profile data
  Future<bool> updateUserData(Map<String, dynamic> userData) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      await _firestore.collection('users').doc(user.uid).update(userData);
      return true;
    } catch (e) {
      print('Error updating user data: $e');
      return false;
    }
  }

  /// Stream current user data for real-time updates
  Stream<DocumentSnapshot<Map<String, dynamic>>?> getUserDataStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(null);
    
    return _firestore.collection('users').doc(user.uid).snapshots();
  }

  /// Get user's full name
  Future<String> getFullName() async {
    final userData = await getCurrentUserData();
    if (userData != null) {
      final firstName = userData['firstName'] ?? '';
      final lastName = userData['lastName'] ?? '';
      return '$firstName $lastName'.trim();
    }
    return 'User';
  }

  /// Get user's email
  Future<String> getEmail() async {
    final userData = await getCurrentUserData();
    return userData?['email'] ?? _auth.currentUser?.email ?? '';
  }

  /// Get user's phone
  Future<String> getPhone() async {
    final userData = await getCurrentUserData();
    return userData?['phone'] ?? _auth.currentUser?.phoneNumber ?? '';
  }

  // Get user's Properties
  Future<Map<String, dynamic>> getUserProperties(String propertyType) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('No authenticated user found');
        return {'success': false, 'message': 'User not authenticated', 'data': [], 'count': 0};
      }
      final endpoint = 'api/customers/profile/${user.uid}/properties?propertyType=$propertyType';
      final res = await FixMeHttpHelper.get(endpoint);
      if (res['success'] == true) {
        return res;
      } else {
        print('API returned success: false');
        return {'success': false, 'message': res['message'] ?? 'Unknown error', 'data': [], 'count': 0};
      }
    } catch (e) {
      print('Error in getUserProperties: $e');
      return {'success': false, 'message': e.toString(), 'data': [], 'count': 0};
    }
  }

  // Delete user's property using property id
  Future<bool> deleteUserProperty(String propertyId, String propertyType) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;
      final endpoint = 'api/customers/profile/${user.uid}/property/$propertyId?propertyType=$propertyType';
      final res = await FixMeHttpHelper.delete(endpoint);
      return res['success'] == true;
    } catch (e) {
      print('Error in deleteUserProperty: $e');
      return false;
    }
  }

  /// Add new property
  Future<bool> addUserProperty(Map<String, dynamic> propertyData, String propertyType) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('No authenticated user found for adding property');
        return false;
      }
      
      final endpoint = 'api/customers/profile/${user.uid}/property?propertyType=$propertyType';
      print('Adding property with endpoint: $endpoint');
      print('Property data: $propertyData');
      
      final res = await FixMeHttpHelper.post(endpoint, propertyData);
      print('Add property response: $res');
      
      if (res['success'] == true) {
        print('Property added successfully');
        return true;
      } else {
        print('Failed to add property: ${res['message']}');
        return false;
      }
    } catch (e) {
      print('Error in addUserProperty: $e');
      return false;
    }
  }
}
