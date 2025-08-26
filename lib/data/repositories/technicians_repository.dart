import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixme/utils/http/http_client.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TechniciansRepository extends GetxController {
  static TechniciansRepository get instance => Get.find();

  final _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getNearbyTechnicians(
    Rxn<LatLng> userLocation,
    double radiusInM,
    String? serviceCategory,
  ) async {
    try {
      final response =
          await FixMeHttpHelper.post('api/utility/findNearestTechnicians?serviceCategory=$serviceCategory', {
            'lat': userLocation.value?.latitude,
            'lng': userLocation.value?.longitude,
            'radiusInM': radiusInM,
          });
      if (response['success'] == true){
        print('Technicians fetched successfully');
        return List<Map<String, dynamic>>.from(response['data']);
      }
      else{
        print('Failed to fetch technicians');
        return [];
      }
    } catch (e) {
      print('Error getting technicians: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getTechnicianDetails(String id) async {
    try {
      final doc = await _firestore.collection('technicians').doc(id).get();
      return doc.data();
    } catch (e) {
      print('Error getting technician details: $e');
      return null;
    }
  }

  /// Create a new job request
  Future<Map<String, dynamic>> createJobRequest(Map<String, dynamic> jobData) async {
    try {
      final response = await FixMeHttpHelper.post('api/jobs/create', jobData);
      
      if (response['success'] == true) {
        print('Job request created successfully');
        return response;
      } else {
        print('Failed to create job request: ${response['message']}');
        return {
          'success': false,
          'message': response['message'] ?? 'Failed to create job request',
        };
      }
    } catch (e) {
      print('Error creating job request: $e');
      return {
        'success': false,
        'message': 'Network error: Unable to create job request',
        'error': e.toString(),
      };
    }
  }

  /// Update an existing job request
  Future<Map<String, dynamic>> updateJobRequest(String jobId, Map<String, dynamic> updateData) async {
    try {
      final response = await FixMeHttpHelper.put('api/jobs/$jobId', updateData);
      
      if (response['success'] == true) {
        print('Job request updated successfully');
        return response;
      } else {
        print('Failed to update job request: ${response['message']}');
        return {
          'success': false,
          'message': response['message'] ?? 'Failed to update job request',
        };
      }
    } catch (e) {
      print('Error updating job request: $e');
      return {
        'success': false,
        'message': 'Network error: Unable to update job request',
        'error': e.toString(),
      };
    }
  }
}
