import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Match your backend’s JSON (`GET /api/technicians/:id` returns { success, data: {...} })
/// Route exists in your repo under /api/technicians and exposes `/:id`:contentReference[oaicite:2]{index=2}:contentReference[oaicite:3]{index=3}.
class TechnicianProfileData {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? serviceCategory;
  final List<String> specializations;
  final String? serviceDescription;
  final String? address;
  final double? serviceRadius;
  final String? bankName;
  final String? accountNumber;
  final String? branch;
  final String? profilePictureUrl;
  final String? idProofUrl;
  final String? badgeType;
  final double? rating;     // 0..5
  final int? totalJobs;     // overall job count
  final bool? isActive;
  final String? status;

  // Optional nested probationStatus
  final int? probationCompletedJobs;
  final int? probationMaxJobs;

  TechnicianProfileData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.serviceCategory,
    required this.specializations,
    required this.serviceDescription,
    required this.address,
    required this.serviceRadius,
    required this.bankName,
    required this.accountNumber,
    required this.branch,
    required this.profilePictureUrl,
    required this.idProofUrl,
    required this.badgeType,
    required this.rating,
    required this.totalJobs,
    required this.isActive,
    required this.status,
    required this.probationCompletedJobs,
    required this.probationMaxJobs,
  });

  factory TechnicianProfileData.fromBackend(String id, Map<String, dynamic> map) {
    final prob = (map['probationStatus'] as Map?) ?? {};
    return TechnicianProfileData(
      id: id,
      name: map['name'] as String?,
      email: map['email'] as String?,
      phone: map['phone'] as String?,
      serviceCategory: map['serviceCategory'] as String?,
      specializations: (map['specializations'] as List?)
          ?.map((e) => e.toString())
          .toList() ??
          const [],
      serviceDescription: map['serviceDescription'] as String?,
      address: map['address'] as String?,
      serviceRadius: _toDoubleOrNull(map['serviceRadius']),
      bankName: map['bankName'] as String?,
      accountNumber: map['accountNumber'] as String?,
      branch: map['branch'] as String?,
      profilePictureUrl: map['profilePictureUrl'] as String?,
      idProofUrl: map['idProofUrl'] as String?,
      badgeType: map['badgeType'] as String?,
      rating: _toDoubleOrNull(map['rating']) ?? 0,
      totalJobs: _toIntOrNull(map['totalJobs']) ??
          _toIntOrNull(prob['completedJobs']) ??
          0,
      isActive: map['isActive'] as bool?,
      status: map['status'] as String?,
      probationCompletedJobs: _toIntOrNull(prob['completedJobs']),
      probationMaxJobs: _toIntOrNull(prob['maxJobs']),
    );
  }

  static double? _toDoubleOrNull(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }
  static int? _toIntOrNull(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }
}

class TechnicianProfileController extends ChangeNotifier {
  TechnicianProfileController({
    String? technicianId,
    String? baseUrl,
    String? idToken, // optional: if you later protect your route with Firebase auth
  })  : _technicianId = technicianId ?? 'kcdESLLauEJ1UY3bvpkw',
        _baseUrl = baseUrl ?? 'http://10.0.2.2:3000/api/technicians',
        _idToken = idToken;

  final String _technicianId;
  final String _baseUrl;
  final String? _idToken;

  Map<String, String> get _headers {
    final h = <String, String>{'Content-Type': 'application/json'};
    // If you later switch to a protected profile route with verifyFirebaseToken,
    // send the Firebase ID token (Bearer) — see auth.middleware:contentReference[oaicite:4]{index=4}.
    if (_idToken != null && _idToken!.isNotEmpty) {
      h['Authorization'] = 'Bearer $_idToken';
    }
    return h;
  }

  /// One-off fetch via backend
  Future<TechnicianProfileData> fetchProfileOnce() async {
    // Existing public route: GET /api/technicians/:id:contentReference[oaicite:5]{index=5}
    final uri = Uri.parse('$_baseUrl/$_technicianId');
    final res = await http.get(uri, headers: _headers);

    if (res.statusCode != 200) {
      throw StateError('Failed to load profile (${res.statusCode})');
    }

    final decoded = jsonDecode(res.body) as Map<String, dynamic>;
    // Backend wraps the document as { success, data: {...} }
    final ok = decoded['success'] == true;
    if (!ok || decoded['data'] == null) {
      throw StateError('Malformed response from server');
    }

    final data = decoded['data'] as Map<String, dynamic>;
    final id = (data['id'] ?? _technicianId).toString();
    return TechnicianProfileData.fromBackend(id, data);
  }

  /// Optional “live” polling stream (every 20s). Use StreamBuilder if desired.
  Stream<TechnicianProfileData> watchProfile({Duration interval = const Duration(seconds: 20)}) async* {
    while (true) {
      try {
        final value = await fetchProfileOnce();
        yield value;
      } catch (e) {
        // Bubbling an error stops the stream; instead, yield nothing and continue.
        debugPrint('watchProfile error: $e');
      }
      await Future.delayed(interval);
    }
  }
}
