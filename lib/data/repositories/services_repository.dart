import 'package:fixme/utils/http/http_client.dart';

class ServicesRepository {
  ServicesRepository._();

  /// Cancel a service by its ID
  /// 
  /// [serviceId] - The ID of the service to cancel
  /// Returns true if cancellation was successful, false otherwise
  static Future<bool> cancelJobRequest(String jobId, String? reason) async {
    try {
      // Call the API to cancel the job
      final endpoint = 'api/jobs/cancel/$jobId';
      final response = await FixMeHttpHelper.post(endpoint, {
        'reason': reason ?? 'Customer cancelled the booking',
        'cancelledBy': 'customer',
      });
      if (response['success'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
