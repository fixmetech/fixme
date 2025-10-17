import 'package:fixme/utils/http/http_client.dart';

class BookingsRepository {
  BookingsRepository._();

  /// Fetch bookings for a specific customer/user id.
  /// Returns a list of booking maps or empty list on failure.
  static Future<List<Map<String, dynamic>>> getUserBookings(String userId) async {
    final endpoint = 'api/jobs/my-activities/$userId';
    final res = await FixMeHttpHelper.get(endpoint);
    if (res['success'] == true && res['data'] != null) {
      final data = res['data'];
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      }
      if (data is Map && data['requests'] is List) {
        return List<Map<String, dynamic>>.from(data['requests']);
      }
      return [];
    }

    // If we reach here, consider it an error condition and throw for the UI to handle
    final message = res['message'] ?? 'Failed to fetch bookings';
    throw Exception(message);
  }
}
