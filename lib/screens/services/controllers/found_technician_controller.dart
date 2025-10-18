import 'package:fixme/data/repositories/services_repository.dart';
import 'package:fixme/utils/helper/helper_functions.dart';
import 'package:fixme/utils/loader/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class FoundTechnicianController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  Future<void> cancelBooking({
    required String jobId, 
    String? reason, 
    required BuildContext context
  }) async {
    // Close the dialog first
    Navigator.of(context).pop();
    
    // Show loading
    isLoading.value = true;
    error.value = '';
    
    // Show loading dialog
    FullScreenLoader.showLoader(context: context, text: 'Cancelling booking...', lottieAsset: 'assets/animations/loader1.json');
    
    try {
      final success = await ServicesRepository.cancelJobRequest(jobId, reason);
      
      // Close loading dialog
      FullScreenLoader.hideLoader(context);
      
      if (success) {
        // Show success message
        FixMeHelperFunctions.showSuccessSnackBar(
           'Success', 'Booking cancelled successfully',
        );
        
        // Navigate back to previous screen
        Navigator.of(context).pop();
      } else {
        error.value = 'Failed to cancel the booking. Please try again.';
        // Show error message
        FixMeHelperFunctions.showErrorSnackBar(
          'Error',
          error.value,
        );
      }
    } catch (e) {
      // Close loading dialog
      Get.back();
      
      error.value = 'An error occurred: $e';
      // Show error message
      FixMeHelperFunctions.showErrorSnackBar(
        'Error',
        error.value,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
