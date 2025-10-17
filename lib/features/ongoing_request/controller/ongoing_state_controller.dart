import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;

/// Same base URL convention used elsewhere
const String kBackendBaseUrl = String.fromEnvironment(
  'BACKEND_URL',
  defaultValue: 'http://10.0.2.2:3000', // Android emulator -> your localhost
);

class OngoingJobDetails {
  final String id;
  final int pin;
  final num? estimatedCost;
  final String status;

  OngoingJobDetails({
    required this.id,
    required this.pin,
    required this.status,
    this.estimatedCost,
  });

  factory OngoingJobDetails.fromJson(Map<String, dynamic> j) {
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

    return OngoingJobDetails(
      id: j['id'] as String,
      pin: parsePin(j['pin']),
      estimatedCost: parseCost(j['estimatedCost']),
      status: (j['status'] as String?) ?? '',
    );
  }
}

class OngoingStateApi {
  /// Load full job doc (PIN, estimate, status)
  Future<OngoingJobDetails> fetchJob(String jobId, {String? idToken}) async {
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
      return OngoingJobDetails.fromJson(data);
    }

    try {
      final err = jsonDecode(resp.body) as Map<String, dynamic>;
      throw Exception(err['error'] ?? 'HTTP ${resp.statusCode}');
    } catch (_) {
      throw Exception('HTTP ${resp.statusCode}: ${resp.body}');
    }
  }

  /// Lightweight status check
  Future<String> getJobStatus(String jobId, {String? idToken}) async {
    final uri = Uri.parse('$kBackendBaseUrl/api/jobs/$jobId/status');
    final resp = await http
        .get(uri, headers: {
      'Accept': 'application/json',
      if (idToken != null && idToken.isNotEmpty)
        'Authorization': 'Bearer $idToken',
    })
        .timeout(const Duration(seconds: 10));

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      return (data['status'] as String?) ?? '';
    }

    try {
      final err = jsonDecode(resp.body) as Map<String, dynamic>;
      throw Exception(err['error'] ?? 'HTTP ${resp.statusCode}');
    } catch (_) {
      throw Exception('HTTP ${resp.statusCode}: ${resp.body}');
    }
  }
}

/// Simple poller you can drive from your screen’s initState/dispose without changing the UI.
class OngoingStateController {
  final OngoingStateApi _api = OngoingStateApi();
  Timer? _pollTimer;

  /// Load the current job (to show PIN & accepted estimate).
  Future<OngoingJobDetails> loadJob(String jobId, {String? idToken}) {
    return _api.fetchJob(jobId, idToken: idToken);
  }

  /// Start polling the job status until it becomes 'TechnicianFinish'.
  /// Calls `onReached()` once when the target status is reached.
  /// Returns a function you can call to cancel.
  VoidCallback startPollingUntilFinish({
    required String jobId,
    String? idToken,
    Duration interval = const Duration(seconds: 3),
    Duration? maxDuration, // optional timeout
    required VoidCallback onReached,
    void Function(Object error)? onError,
  }) {
    _pollTimer?.cancel();
    int elapsedMs = 0;
    _pollTimer = Timer.periodic(interval, (t) async {
      try {
        elapsedMs += interval.inMilliseconds;
        if (maxDuration != null && elapsedMs > maxDuration.inMilliseconds) {
          // Time out silently; caller may choose what to do (stay on page / show info)
          return;
        }

        final status = await _api.getJobStatus(jobId, idToken: idToken);
        if (status == 'TechnicianFinish') {
          t.cancel();
          onReached();
        }
      } catch (e) {
        // Keep polling, but allow caller to log/notice errors
        if (onError != null) onError(e);
      }
    });

    return () {
      _pollTimer?.cancel();
    };
  }

  void cancel() {
    _pollTimer?.cancel();
  }
}
