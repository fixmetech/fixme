import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  final String title;
  final String assist;
  final String contact;
  final String address;
  final String time;
  final VoidCallback? onCancel;
  final VoidCallback? onView;

  const ActivityCard({
    super.key,
    required this.title,
    required this.assist,
    required this.contact,
    required this.address,
    required this.time,
    this.onCancel,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Service Icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getServiceColor(title).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getServiceIcon(title),
                        color: _getServiceColor(title),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Title and Time
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              time,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Technician Info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.blue[100],
                        child: Text(
                          assist.split(' ').map((n) => n[0]).join(),
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              assist,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  contact,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Rating
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              size: 12,
                              color: Colors.amber[600],
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '4.8',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.amber[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Address
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        address,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Action Buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[25],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onView,
                    icon: const Icon(Icons.visibility_outlined, size: 16),
                    label: const Text('View Details'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      side: BorderSide(color: Colors.grey[300]!),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Track Button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      // Handle track
                    },
                    icon: Icon(
                      Icons.location_on,
                      color: Colors.blue[600],
                      size: 20,
                    ),
                    tooltip: 'Track',
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // Call Button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      // Handle call
                    },
                    icon: Icon(
                      Icons.phone,
                      color: Colors.green[600],
                      size: 20,
                    ),
                    tooltip: 'Call',
                  ),
                ),
                
                // Commented Cancel Button
                // Expanded(
                //   child: ElevatedButton.icon(
                //     onPressed: onCancel,
                //     icon: const Icon(Icons.close, size: 16),
                //     label: const Text('Cancel'),
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.red[50],
                //       foregroundColor: Colors.red[600],
                //       elevation: 0,
                //       padding: const EdgeInsets.symmetric(vertical: 8),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(8),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getServiceIcon(String title) {
    if (title.toLowerCase().contains('paint')) {
      return Icons.format_paint;
    } else if (title.toLowerCase().contains('car')) {
      return Icons.car_repair;
    } else if (title.toLowerCase().contains('electrical')) {
      return Icons.electrical_services;
    } else if (title.toLowerCase().contains('plumb')) {
      return Icons.plumbing;
    }
    return Icons.handyman;
  }

  Color _getServiceColor(String title) {
    if (title.toLowerCase().contains('paint')) {
      return Colors.purple;
    } else if (title.toLowerCase().contains('car')) {
      return Colors.blue;
    } else if (title.toLowerCase().contains('electrical')) {
      return Colors.orange;
    } else if (title.toLowerCase().contains('plumb')) {
      return Colors.teal;
    }
    return Colors.grey;
  }
}