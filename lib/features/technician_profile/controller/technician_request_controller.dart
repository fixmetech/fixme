
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class TechnicianScheduleJobController {
  static const String baseUrl = 'http://10.0.2.2:3000';
  
  // Create a booking request
  Future<Map<String, dynamic>> createBookingRequest({
    required String userId,
    required String technicianId,
    required String serviceCategory,
    required String serviceSpecialization,
    required String description,
    required DateTime bookingDate,
    required String bookingTime,
    required DateTime scheduledDate,
    required String scheduledTime,
    required Map<String, dynamic> technicianDetails,
    Map<String, dynamic>? vehicleDetails,
    Map<String, dynamic>? paymentDetails,
    double priceEstimate = 0.0,
  }) async {
    try {
      final requestBody = {
        'userId': userId,
        'technicianId': technicianId,
        'serviceCategory': serviceCategory,
        'serviceSpecialization': serviceSpecialization,
        'description': description,
        'bookingDate': bookingDate.toIso8601String(),
        'bookingTime': bookingTime,
        'scheduledDate': scheduledDate.toIso8601String(),
        'scheduledTime': scheduledTime,
        'technicianDetails': technicianDetails,
        'vehicleDetails': vehicleDetails,
        'paymentDetails': paymentDetails ?? {
          'method': 'credit_card',
          'status': 'unpaid',
          'transactionId': null
        },
        'priceEstimate': priceEstimate,
      };

      if (kDebugMode) {
        print('Creating booking request: ${jsonEncode(requestBody)}');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/user/createbooking'),
        headers: {
          'Content-Type': 'application/json',
          // Add authentication header if required
          // 'Authorization': 'Bearer ${await getAuthToken()}',
        },
        body: jsonEncode(requestBody),
      );

      if (kDebugMode) {
        print('Booking response status: ${response.statusCode}');
        print('Booking response body: ${response.body}');
      }

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'data': responseData,
          'message': 'Booking request created successfully'
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'error': errorData['error'] ?? 'Failed to create booking',
          'statusCode': response.statusCode
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating booking request: $e');
      }
      return {
        'success': false,
        'error': 'Network error: ${e.toString()}'
      };
    }
  }

  // Get bookings for a technician
  Future<Map<String, dynamic>> getBookingsByTechnician(String technicianId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/user/technician/$technicianId/bookings'),
        headers: {
          'Content-Type': 'application/json',
          // Add authentication header if required
          // 'Authorization': 'Bearer ${await getAuthToken()}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'data': responseData,
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'error': errorData['error'] ?? 'Failed to fetch bookings'
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching bookings: $e');
      }
      return {
        'success': false,
        'error': 'Network error: ${e.toString()}'
      };
    }
  }

  // Get available time slots for a technician on a specific date
  Future<Map<String, dynamic>> getAvailableTimeSlots(String technicianId, String date) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/user/technician/$technicianId/timeslots?date=$date'),
        headers: {
          'Content-Type': 'application/json',
          // Add authentication header if required
          // 'Authorization': 'Bearer ${await getAuthToken()}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'data': responseData['data'],
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'error': errorData['error'] ?? 'Failed to fetch time slots'
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching time slots: $e');
      }
      return {
        'success': false,
        'error': 'Network error: ${e.toString()}'
      };
    }
  }

  // Helper method to convert time slot to 24-hour format
  String convertTo24HourFormat(String timeSlot) {
    try {
      // Convert "9:00 AM" to "09:00"
      final time = timeSlot.toLowerCase();
      final parts = time.split(' ');
      final timePart = parts[0];
      final period = parts[1];
      
      final hourMinute = timePart.split(':');
      int hour = int.parse(hourMinute[0]);
      final minute = hourMinute[1];
      
      if (period == 'pm' && hour != 12) {
        hour += 12;
      } else if (period == 'am' && hour == 12) {
        hour = 0;
      }
      
      return '${hour.toString().padLeft(2, '0')}:$minute';
    } catch (e) {
      if (kDebugMode) {
        print('Error converting time format: $e');
      }
      return timeSlot; // Return original if conversion fails
    }
  }

  // Get user's registered vehicles
  Future<Map<String, dynamic>> getUserVehicles(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/customers/profile/$userId/properties?propertyType=vehicles'),
        headers: {
          'Content-Type': 'application/json',
          // Add authentication header if required
          // 'Authorization': 'Bearer ${await getAuthToken()}',
        },
      );

      if (kDebugMode) {
        print('Get vehicles response status: ${response.statusCode}');
        print('Get vehicles response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'data': responseData['data'] ?? [],
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'error': errorData['message'] ?? 'Failed to fetch vehicles'
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching vehicles: $e');
      }
      return {
        'success': false,
        'error': 'Network error: ${e.toString()}'
      };
    }
  }

  // Helper method to get authentication token (implement based on your auth system)
  Future<String?> getAuthToken() async {
    // TODO: Implement token retrieval from your authentication system
    // This could be from SharedPreferences, secure storage, etc.
    return null;
  }

  // Helper method to validate booking data
  Map<String, String> validateBookingData({
    required String userId,
    required String technicianId,
    required String description,
    required DateTime? scheduledDate,
    required String? scheduledTime,
    required Map<String, dynamic> technicianDetails,
  }) {
    Map<String, String> errors = {};

    if (userId.isEmpty) {
      errors['userId'] = 'User ID is required';
    }

    if (technicianId.isEmpty) {
      errors['technicianId'] = 'Technician ID is required';
    }

    if (description.length < 20) {
      errors['description'] = 'Description must be at least 20 characters';
    }

    if (description.length > 500) {
      errors['description'] = 'Description must not exceed 500 characters';
    }

    if (scheduledDate == null) {
      errors['scheduledDate'] = 'Scheduled date is required';
    }

    if (scheduledTime == null || scheduledTime.isEmpty) {
      errors['scheduledTime'] = 'Scheduled time is required';
    }

    return errors;
  }
}