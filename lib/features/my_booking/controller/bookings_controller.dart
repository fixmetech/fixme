import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:fixme/data/repositories/bookings_repository.dart';
import 'package:fixme/models/job_request.dart';

class BookingsController extends GetxController {
  final RxList<JobRequest> activities = <JobRequest>[].obs;
  final RxList<Map<String, dynamic>> scheduledBookings =
      <Map<String, dynamic>>[].obs;
  final RxBool loading = false.obs;
  final RxnString error = RxnString(); // <-- added this line
  final _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
    fetchScheduledBookings();
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
      final list = await BookingsRepository.getIntanceUserBookings(user.uid);
      // Convert Map<String, dynamic> to JobRequest objects
      final jobRequests = list.map((data) => JobRequest.fromMap(data)).toList();
      activities.assignAll(jobRequests);
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }

  Future<void> fetchScheduledBookings() async {
    final user = _auth.currentUser;
    if (user == null) {
      error.value = 'User not signed in';
      return;
    }

    loading.value = true;
    error.value = null;
    try {
      final list = await BookingsRepository.getUserBookings(user.uid);

      list.sort((a, b) {
        final aTime = a['updatedAt'] ?? a['createdAt'];
        final bTime = b['updatedAt'] ?? b['createdAt'];
        return bTime.compareTo(aTime);
      });

      scheduledBookings.assignAll(list);
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }

  Future<void> refresh() async {
    await fetchBookings();
    await fetchScheduledBookings();
  }
}
