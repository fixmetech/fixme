import 'package:fixme/features/my_booking/widgets/booking_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fixme/features/my_booking/widgets/activity_list.dart';
import 'package:fixme/features/my_booking/controller/bookings_controller.dart';
import 'package:fixme/models/job_request.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final BookingsController c = Get.put(BookingsController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => c.fetchBookings());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue[50],
        surfaceTintColor: Colors.blue[50],
        automaticallyImplyLeading: false,
        title: const Text(
          'My Bookings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Tab bar
          Container(
            color: Colors.blue[50],
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.blue[700],
              dividerColor: Colors.transparent,
              unselectedLabelColor: Colors.grey[500],
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 3, color: Colors.blue[600]!),
                insets: const EdgeInsets.symmetric(horizontal: 16),
              ),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              labelPadding: const EdgeInsets.symmetric(horizontal: 24),
              tabAlignment: TabAlignment.start,
              tabs: const [
                Tab(text: 'Ongoing'),
                Tab(text: 'Bookings'),
                Tab(text: 'Completed'),
                Tab(text: 'Cancelled'),
              ],
            ),
          ),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _tabView('Ongoing'),
                _tabView('Bookings'),
                _tabView('Completed'),
                _tabView('Cancelled'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabView(String type) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Obx(() {
        if (c.loading.value)
          return const Center(child: CircularProgressIndicator());

        if (c.error.value != null) {
          return RefreshIndicator(
            onRefresh: c.refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Failed to load bookings',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          c.error.value ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: c.fetchBookings,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
          final bookings = c.scheduledBookings;
          final items = c.activities
              .where((activity) => _matchesType(activity, type))
              .toList();
          // sort items by date descending
          items.sort((a, b) {
            final aTime = a.updatedAt ?? a.createdAt;
            final bTime = b.updatedAt ?? b.createdAt;
            return bTime.compareTo(aTime); // descending = recent first
          });

          return RefreshIndicator(
            onRefresh: c.refresh,
            child: (type != 'Bookings' && items.isEmpty) || (type == 'Bookings' && bookings.isEmpty)
                ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.inbox,
                                size: 56,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No $type bookings yet',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'You have no bookings in this category. Pull down to refresh.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : type == 'Bookings' 
                    ? BookingList(type: type, bookings: bookings)
                    : ActivityList(type: type, activities: items),
          );
      }),
    );
  }

  bool _matchesType(JobRequest job, String type) {
    final status = job.status.toLowerCase();
    switch (type) {
      case 'Ongoing':
        return status == 'technicianfinished' ||
            status == 'estimateapproved' ||
            status == 'searchingtechnician' ||
            status == 'confirmed';
      case 'Completed':
        return status == 'completed' || status == 'finished';
      case 'Cancelled':
        return status == 'cancelled' || status == 'canceled';
      default:
        return false;
    }
  }
}
