import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Keep consistent with your other controllers
const String kBackendBaseUrl = String.fromEnvironment(
  'BACKEND_URL',
  defaultValue: 'http://10.0.2.2:3000', // Android emulator -> localhost
);

class FinishPinResult {
  final bool ok;
  final int? finishPin;
  final String? message;

  FinishPinResult({required this.ok, this.finishPin, this.message});
}

class FinishJobController {
  Future<FinishPinResult> issueFinishPin({
    required String jobId,
    String? idToken, // include if your backend enforces auth
  }) async {
    try {
      final uri = Uri.parse('$kBackendBaseUrl/api/jobs/$jobId/finish-pin');
      final resp = await http
          .post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (idToken != null && idToken.isNotEmpty)
            'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode({}), // no payload needed; backend will generate
      )
          .timeout(const Duration(seconds: 12));

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        final pin = data['finishPin'];
        return FinishPinResult(
          ok: true,
          finishPin: (pin is num) ? pin.toInt() : int.tryParse('$pin'),
          message: (data['message'] as String?) ?? 'Finish PIN generated',
        );
      }

      // Parse backend error JSON if present
      try {
        final err = jsonDecode(resp.body) as Map<String, dynamic>;
        return FinishPinResult(
          ok: false,
          message:
          (err['error'] as String?) ?? 'HTTP ${resp.statusCode}: ${resp.reasonPhrase}',
        );
      } catch (_) {
        return FinishPinResult(
          ok: false,
          message: 'HTTP ${resp.statusCode}: ${resp.body}',
        );
      }
    } on TimeoutException {
      return FinishPinResult(ok: false, message: 'Request timed out');
    } catch (e) {
      return FinishPinResult(ok: false, message: 'Network error: $e');
    }
  }
}
