import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Same base URL convention used in your project
const String kBackendBaseUrl = String.fromEnvironment(
  'BACKEND_URL',
  defaultValue: 'http://10.0.2.2:3000', // Android emulator -> localhost
);

class FinishPinFetchResult {
  final bool ok;
  final int? finishPin;
  final String? message;

  FinishPinFetchResult({required this.ok, this.finishPin, this.message});
}

class MakePaymentController {
  /// Fetch the final finishPin (OTP) for the job.
  /// Uses a lightweight endpoint: GET /api/jobs/:jobId/finish-pin
  Future<FinishPinFetchResult> getFinishPin({
    required String jobId,
    String? idToken, // include if your backend enforces auth
  }) async {
    try {
      final uri = Uri.parse('$kBackendBaseUrl/api/jobs/$jobId/finish-pin');
      final resp = await http
          .get(uri, headers: {
        'Accept': 'application/json',
        if (idToken != null && idToken.isNotEmpty)
          'Authorization': 'Bearer $idToken',
      })
          .timeout(const Duration(seconds: 12));

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        final pin = data['finishPin'];
        return FinishPinFetchResult(
          ok: true,
          finishPin: (pin is num) ? pin.toInt() : int.tryParse('$pin'),
        );
      }

      // parse backend error if present
      try {
        final err = jsonDecode(resp.body) as Map<String, dynamic>;
        return FinishPinFetchResult(
          ok: false,
          message:
          (err['error'] as String?) ?? 'HTTP ${resp.statusCode}: ${resp.reasonPhrase}',
        );
      } catch (_) {
        return FinishPinFetchResult(
          ok: false,
          message: 'HTTP ${resp.statusCode}: ${resp.body}',
        );
      }
    } on TimeoutException {
      return FinishPinFetchResult(ok: false, message: 'Request timed out');
    } catch (e) {
      return FinishPinFetchResult(ok: false, message: 'Network error: $e');
    }
  }
}
