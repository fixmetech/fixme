import 'package:fixme/data/repositories/services_repository.dart';
import 'package:fixme/mainScreen.dart';
import 'package:fixme/utils/helper/helper_functions.dart';
import 'package:get/get.dart';

class FoundTechnicianController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  Future<void> cancelBooking({
    required String jobId,
    String? reason,
  }) async {
    try {
      // Close any open dialog safely
      if (Get.isDialogOpen ?? false) {
        Get.back(); // Close the dialog
      }

      // Start loading
      isLoading.value = true;
      error.value = '';

      final success = await ServicesRepository.cancelJobRequest(jobId, reason);

      // Stop loading
      isLoading.value = false;

      if (success) {
        // Show success message (using GetX safe snackbar)
        FixMeHelperFunctions.showSuccessSnackBar(
          'Success',
          'Booking cancelled successfully',
        );

        // Navigate to home screen (clear all previous routes)
        Get.offAll(() => const MainScreen());
      } else {
        error.value = 'Failed to cancel the booking. Please try again.';
        FixMeHelperFunctions.showErrorSnackBar('Error', error.value);
      }
    } catch (e) {
      isLoading.value = false;
      error.value = 'An error occurred: $e';
      FixMeHelperFunctions.showErrorSnackBar('Error', error.value);
    }
  }
}
