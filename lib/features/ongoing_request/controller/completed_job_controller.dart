import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Keep consistent with your other controllers
const String kBackendBaseUrl = String.fromEnvironment(
  'BACKEND_URL',
  defaultValue: 'http://10.0.2.2:3000', // Android emulator -> localhost
);

class SubmitReviewResult {
  final bool ok;
  final String? message;

  SubmitReviewResult({required this.ok, this.message});
}

class CompletedJobController {
  Future<SubmitReviewResult> submitReview({
    required String jobId,
    required int rating,       // 1..5
    required String review,    // free text
    String? idToken,           // optional if your backend verifies Firebase ID tokens
  }) async {
    try {
      final uri = Uri.parse('$kBackendBaseUrl/api/jobs/$jobId/review');
      final resp = await http
          .post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (idToken != null && idToken.isNotEmpty)
            'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode({
          'rating': rating,
          'review': review,
        }),
      )
          .timeout(const Duration(seconds: 12));

      if (resp.statusCode == 200) {
        return SubmitReviewResult(ok: true, message: 'Review submitted');
      }

      // parse error (if JSON)
      try {
        final err = jsonDecode(resp.body) as Map<String, dynamic>;
        return SubmitReviewResult(
          ok: false,
          message:
          (err['error'] as String?) ?? 'HTTP ${resp.statusCode}: ${resp.reasonPhrase}',
        );
      } catch (_) {
        return SubmitReviewResult(
          ok: false,
          message: 'HTTP ${resp.statusCode}: ${resp.body}',
        );
      }
    } on TimeoutException {
      return SubmitReviewResult(ok: false, message: 'Request timed out');
    } catch (e) {
      return SubmitReviewResult(ok: false, message: 'Network error: $e');
    }
  }
}
