import 'package:fixme/widgets/activity_list.dart';
import 'package:flutter/material.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black54),
            onPressed: () {
              // Handle notifications
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Clean Tab Bar
          Container(
            color: Colors.blue[50],
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.blue[700],
              unselectedLabelColor: Colors.grey[500],
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 3,
                  color: Colors.blue[600]!,
                ),
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
                Tab(text: 'Upcoming'),
                Tab(text: 'Completed'),
                Tab(text: 'Cancelled'),
              ],
            ),
          ),
          
          // Content Area
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTabContent('Ongoing', Icons.settings, Colors.orange),
                _buildTabContent('Upcoming', Icons.schedule, Colors.blue),
                _buildTabContent('Completed', Icons.check_circle, Colors.green),
                _buildTabContent('Cancelled', Icons.cancel, Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(String type, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          // Tab Header with Icon
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  '$type Services',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusCount(type),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Activity List
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ActivityList(type: type),
              ),
            ),
          ),
        
        ],
      ),
    );
  }

  String _getStatusCount(String type) {
    // You can replace this with actual counts from your data
    switch (type) {
      case 'Ongoing':
        return '2 Active';
      case 'Upcoming':
        return '3 Scheduled';
      case 'Completed':
        return '15 Done';
      case 'Cancelled':
        return '1 Cancelled';
      default:
        return '0';
    }
  }
}