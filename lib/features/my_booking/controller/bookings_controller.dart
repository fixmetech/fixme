import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:fixme/data/repositories/bookings_repository.dart';
import 'package:fixme/models/job_request.dart';

class BookingsController extends GetxController {
  final RxList<JobRequest> activities = <JobRequest>[].obs;
  final RxBool loading = false.obs;
  final RxnString error = RxnString(); // <-- added this line
  final _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    final user = _auth.currentUser;
    if (user == null) {
      error.value = 'User not signed in';
      return;
    }

    loading.value = true;
    error.value = null;
    try {
      final list = await BookingsRepository.getUserBookings(user.uid);
      // Convert Map<String, dynamic> to JobRequest objects
      final jobRequests = list.map((data) => JobRequest.fromMap(data)).toList();
      activities.assignAll(jobRequests);
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }

  Future<void> refresh() async {
    await fetchBookings();
  }
}
