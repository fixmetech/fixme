import 'package:flutter/material.dart';

enum ServiceType { vehicle, home }

class CustomerProfileHistory extends StatefulWidget {
  const CustomerProfileHistory({super.key});

  @override
  State<CustomerProfileHistory> createState() => _CustomerProfileHistoryState();
}

class _CustomerProfileHistoryState extends State<CustomerProfileHistory>
    with SingleTickerProviderStateMixin {
  ServiceType selectedService = ServiceType.vehicle;
  bool showAll = false;
  String searchQuery = '';
  late TabController _tabController;

  // Enhanced sample vehicle history with more details
  final List<ServiceHistoryModel> vehicleHistory = [
    ServiceHistoryModel(
      id: 'VH001',
      date: DateTime(2025, 8, 21),
      serviceType: 'Car Brake Repair',
      technicianName: 'Nimal Chaminda',
      technicianContact: '0778588336',
      payment: 25000.00,
      status: ServiceStatus.completed,
      rating: 4.5,
      comment: 'Thank you so much for the excellent service!',
      serviceCategory: 'Brake System',
      duration: '2 hours',
    ),
    ServiceHistoryModel(
      id: 'VH002',
      date: DateTime(2025, 9, 15),
      serviceType: 'Oil Change & Filter Replacement',
      technicianName: 'Sunil Perera',
      technicianContact: '0771234567',
      payment: 3500.00,
      status: ServiceStatus.completed,
      rating: 5.0,
      comment: 'Quick and professional service.',
      serviceCategory: 'Maintenance',
      duration: '45 minutes',
    ),
    ServiceHistoryModel(
      id: 'VH003',
      date: DateTime(2025, 10, 10),
      serviceType: 'Engine Diagnostic Check',
      technicianName: 'Kamal Silva',
      technicianContact: '0769876543',
      payment: 15000.00,
      status: ServiceStatus.completed,
      rating: 4.0,
      comment: 'Good diagnostic service, found the issue quickly.',
      serviceCategory: 'Engine',
      duration: '1.5 hours',
    ),
    ServiceHistoryModel(
      id: 'VH004',
      date: DateTime(2025, 11, 5),
      serviceType: 'Tire Replacement (Set of 4)',
      technicianName: 'Ravi Fernando',
      technicianContact: '0712345678',
      payment: 40000.00,
      status: ServiceStatus.completed,
      rating: 4.8,
      comment: 'High quality tires, excellent installation.',
      serviceCategory: 'Tires',
      duration: '1 hour',
    ),
  ];

  // Enhanced sample home history
  final List<ServiceHistoryModel> homeHistory = [
    ServiceHistoryModel(
      id: 'HH001',
      date: DateTime(2025, 8, 21),
      serviceType: 'Water Pump Repair',
      technicianName: 'Lakmal Jayasinghe',
      technicianContact: '0776543210',
      payment: 2500.00,
      status: ServiceStatus.completed,
      rating: 4.2,
      comment: 'Fixed the pumping issue efficiently.',
      serviceCategory: 'Plumbing',
      duration: '1 hour',
    ),
    ServiceHistoryModel(
      id: 'HH002',
      date: DateTime(2025, 9, 10),
      serviceType: 'Gas Line Leak Repair',
      technicianName: 'Pradeep Kumar',
      technicianContact: '0775555555',
      payment: 20000.00,
      status: ServiceStatus.completed,
      rating: 5.0,
      comment: 'Safety first! Great work on gas leak repair.',
      serviceCategory: 'Gas Systems',
      duration: '3 hours',
    ),
    ServiceHistoryModel(
      id: 'HH003',
      date: DateTime(2025, 10, 1),
      serviceType: 'Roof Tile Replacement',
      technicianName: 'Ajith Bandara',
      technicianContact: '0773333333',
      payment: 50000.00,
      status: ServiceStatus.completed,
      rating: 4.7,
      comment: 'Professional roofing work, very satisfied.',
      serviceCategory: 'Roofing',
      duration: '6 hours',
    ),
    ServiceHistoryModel(
      id: 'HH004',
      date: DateTime(2025, 11, 11),
      serviceType: 'Window Frame Replacement',
      technicianName: 'Chamara Wickrama',
      technicianContact: '0774444444',
      payment: 15000.00,
      status: ServiceStatus.completed,
      rating: 4.3,
      comment: 'Good quality windows, neat installation.',
      serviceCategory: 'Windows & Doors',
      duration: '2 hours',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedService = _tabController.index == 0
            ? ServiceType.vehicle
            : ServiceType.home;
        showAll = false;
      });
    });
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
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildTabBar(),
          Expanded(child: _buildTabBarView()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Service History',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Colors.blue[800],
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0,
      centerTitle: true,
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue[800],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_getCurrentHistory().length} Records',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.history, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                'Track all your service records',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchQuery = value.toLowerCase();
          });
        },
        decoration: InputDecoration(
          hintText: 'Search services...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                searchQuery = '';
              });
            },
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          fillColor: Colors.grey[100],
          filled: true,
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.blue[800],
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        tabs: const [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.directions_car, size: 20),
                SizedBox(width: 8),
                Text('Vehicle'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home, size: 20),
                SizedBox(width: 8),
                Text('Home'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildHistoryContent(vehicleHistory),
        _buildHistoryContent(homeHistory),
      ],
    );
  }

  Widget _buildHistoryContent(List<ServiceHistoryModel> history) {
    final filteredHistory = _getFilteredHistory(history);
    final displayHistory = showAll
        ? filteredHistory
        : filteredHistory.take(3).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (filteredHistory.isEmpty)
            _buildEmptyState()
          else
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: displayHistory.length,
                      itemBuilder: (context, index) {
                        return _buildServiceCard(displayHistory[index]);
                      },
                    ),
                  ),
                  if (!showAll && filteredHistory.length > 3)
                    _buildViewAllButton(filteredHistory.length - 3),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(ServiceHistoryModel service) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showServiceDetails(service),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      service.serviceType,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  _buildStatusChip(service.status),
                ],
              ),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.calendar_today,
                  _formatDate(service.date)),
              const SizedBox(height: 4),
              _buildInfoRow(Icons.person, service.technicianName),
              const SizedBox(height: 4),
              _buildInfoRow(Icons.phone, service.technicianContact),
              const SizedBox(height: 4),
              _buildInfoRow(Icons.access_time, service.duration),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rs. ${service.payment.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  _buildRating(service.rating),
                ],
              ),
              if (service.comment.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.comment, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          service.comment,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(ServiceStatus status) {
    Color color;
    String text;

    switch (status) {
      case ServiceStatus.completed:
        color = Colors.green;
        text = 'Completed';
        break;
      case ServiceStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        break;
      case ServiceStatus.cancelled:
        color = Colors.red;
        text = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildRating(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, color: Colors.amber[600], size: 16),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildViewAllButton(int remainingCount) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: OutlinedButton.icon(
        onPressed: () {
          setState(() {
            showAll = true;
          });
        },
        icon: const Icon(Icons.expand_more),
        label: Text('View All ($remainingCount more)'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.blue[800],
          side: BorderSide(color: Colors.blue[800]!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No service history found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            searchQuery.isNotEmpty
                ? 'Try adjusting your search terms'
                : 'Your service records will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  List<ServiceHistoryModel> _getCurrentHistory() {
    return selectedService == ServiceType.vehicle
        ? vehicleHistory
        : homeHistory;
  }

  List<ServiceHistoryModel> _getFilteredHistory(List<ServiceHistoryModel> history) {
    if (searchQuery.isEmpty) return history;

    return history.where((service) {
      return service.serviceType.toLowerCase().contains(searchQuery) ||
          service.technicianName.toLowerCase().contains(searchQuery) ||
          service.serviceCategory.toLowerCase().contains(searchQuery);
    }).toList();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showServiceDetails(ServiceHistoryModel service) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(service.serviceType),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Service ID', service.id),
                _buildDetailRow('Date', _formatDate(service.date)),
                _buildDetailRow('Technician', service.technicianName),
                _buildDetailRow('Contact', service.technicianContact),
                _buildDetailRow('Category', service.serviceCategory),
                _buildDetailRow('Duration', service.duration),
                _buildDetailRow('Payment', 'Rs. ${service.payment.toStringAsFixed(2)}'),
                _buildDetailRow('Rating', '${service.rating}/5.0'),
                if (service.comment.isNotEmpty)
                  _buildDetailRow('Comment', service.comment),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle repeat service
                _showRepeatServiceDialog(service);
              },
              child: const Text('Book Again'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _showRepeatServiceDialog(ServiceHistoryModel service) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Book Similar Service'),
          content: Text('Would you like to book "${service.serviceType}" again?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Service booking functionality would be implemented here'),
                  ),
                );
              },
              child: const Text('Book Now'),
            ),
          ],
        );
      },
    );
  }
}

// Data Models
class ServiceHistoryModel {
  final String id;
  final DateTime date;
  final String serviceType;
  final String technicianName;
  final String technicianContact;
  final double payment;
  final ServiceStatus status;
  final double rating;
  final String comment;
  final String serviceCategory;
  final String duration;

  ServiceHistoryModel({
    required this.id,
    required this.date,
    required this.serviceType,
    required this.technicianName,
    required this.technicianContact,
    required this.payment,
    required this.status,
    required this.rating,
    required this.comment,
    required this.serviceCategory,
    required this.duration,
  });
}

enum ServiceStatus { completed, pending, cancelled }