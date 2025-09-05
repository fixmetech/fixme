// lib/controller/share_pin_controller.dart
import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

/// Set this somewhere central (e.g., via .env or build-time string)
const String kBackendBaseUrl = String.fromEnvironment(
  'BACKEND_URL',
  defaultValue: 'http://10.0.2.2:3000', // Android emulator local
);

class JobRequestDto {
  final String id;
  final String? createdAt;
  final String? updatedAt;
  final String? customerId;
  final String? technicianId;
  final String description;
  final int pin;
  final String serviceCategory;
  final String status;
  final Map<String, dynamic>? customerLocation;
  final Map<String, dynamic>? propertyInfo; // <- typed as object

  JobRequestDto({
    required this.id,
    required this.description,
    required this.pin,
    required this.serviceCategory,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.customerId,
    this.technicianId,
    this.customerLocation,
    this.propertyInfo,
  });

  factory JobRequestDto.fromJson(Map<String, dynamic> j) {
    int parsePin(dynamic v) {
      if (v == null) return 0;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    Map<String, dynamic>? mapOrNull(dynamic v) {
      if (v == null) return null;
      if (v is Map) return Map<String, dynamic>.from(v as Map);
      return null;
    }

    return JobRequestDto(
      id: j['id'] as String,
      createdAt: j['createdAt'] as String?,
      updatedAt: j['updatedAt'] as String?,
      customerId: j['customerId'] as String?,
      technicianId: j['technicianId'] as String?,
      description: (j['description'] as String?) ?? '',
      pin: parsePin(j['pin']),
      serviceCategory: (j['serviceCategory'] as String?) ?? '',
      status: (j['status'] as String?) ?? '',
      customerLocation: mapOrNull(j['customerLocation']),
      propertyInfo: mapOrNull(j['propertyInfo']),
    );
  }
}

class SharePinController extends GetxController {
  final Rxn<JobRequestDto> job = Rxn<JobRequestDto>();
  final RxBool loading = false.obs;
  final RxnString error = RxnString();

  Future<void> fetchJobRequestById(String? jobRequestId) async {
    final id = jobRequestId ?? '0giWzXu3hWWmCFKvFIdb';
    loading.value = true;
    error.value = null;
    try {
      final uri = Uri.parse('$kBackendBaseUrl/api/job-requests/$id');
      // Small timeout to surface connectivity issues quickly
      final resp = await http
          .get(uri, headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        // If your backend verifies Firebase ID tokens, include:
        // 'Authorization': 'Bearer $idToken',
      })
          .timeout(const Duration(seconds: 10));

      final status = resp.statusCode;
      if (status == 200) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        job.value = JobRequestDto.fromJson(data);
      } else {
        final body = resp.body.isNotEmpty ? resp.body : 'Unknown error';
        error.value = 'HTTP $status: $body';
      }
    } on FormatException catch (e) {
      error.value = 'Invalid JSON: $e';
    } on TimeoutException {
      error.value = 'Request timed out. Check server URL/connectivity.';
    } catch (e) {
      error.value = 'Network error: $e';
    } finally {
      loading.value = false;
    }
  }
}
