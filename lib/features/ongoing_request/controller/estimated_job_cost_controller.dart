import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Same base URL pattern you used elsewhere
const String kBackendBaseUrl = String.fromEnvironment(
  'BACKEND_URL',
  defaultValue: 'http://10.0.2.2:3000', // Android emulator -> your localhost
);

class JobRequestDetails {
  final String id;
  final int pin;
  final num? estimatedCost;
  final String status;

  JobRequestDetails({
    required this.id,
    required this.pin,
    required this.status,
    this.estimatedCost,
  });

  factory JobRequestDetails.fromJson(Map<String, dynamic> j) {
    int parsePin(dynamic v) {
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    num? parseCost(dynamic v) {
      if (v == null) return null;
      if (v is num) return v;
      if (v is String) return num.tryParse(v);
      return null;
    }

    return JobRequestDetails(
      id: j['id'] as String,
      pin: parsePin(j['pin']),
      estimatedCost: parseCost(j['estimatedCost']),
      status: (j['status'] as String?) ?? '',
    );
  }
}

class ServiceRequestApi {
  Future<JobRequestDetails> fetchJob(String jobId, {String? idToken}) async {
    final uri = Uri.parse('$kBackendBaseUrl/api/job-requests/$jobId');
    final resp = await http
        .get(uri, headers: {
      'Accept': 'application/json',
      if (idToken != null && idToken.isNotEmpty)
        'Authorization': 'Bearer $idToken',
    })
        .timeout(const Duration(seconds: 10));

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      return JobRequestDetails.fromJson(data);
    }

    try {
      final err = jsonDecode(resp.body) as Map<String, dynamic>;
      throw Exception(err['error'] ?? 'HTTP ${resp.statusCode}');
    } catch (_) {
      throw Exception('HTTP ${resp.statusCode}: ${resp.body}');
    }
  }

  Future<void> approveOrReject({
    required String jobId,
    required String decision, // 'Approved' or 'Rejected'
    String? idToken,
  }) async {
    final uri = Uri.parse('$kBackendBaseUrl/api/jobs/$jobId/estimate-approval');
    final resp = await http
        .post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (idToken != null && idToken.isNotEmpty)
          'Authorization': 'Bearer $idToken',
      },
      body: jsonEncode({'decision': decision}),
    )
        .timeout(const Duration(seconds: 10));

    if (resp.statusCode == 200) return;

    try {
      final err = jsonDecode(resp.body) as Map<String, dynamic>;
      throw Exception(err['error'] ?? 'HTTP ${resp.statusCode}');
    } catch (_) {
      throw Exception('HTTP ${resp.statusCode}: ${resp.body}');
    }
  }
}
