import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  final String title;
  final String assist;
  final String contact;
  final String address;
  final String time;
  final VoidCallback onCancel;
  final VoidCallback onView;

  const ActivityCard({
    super.key,
    required this.title,
    required this.assist,
    required this.contact,
    required this.address,
    required this.time,
    required this.onCancel,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and time
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const Icon(Icons.access_time),
              const SizedBox(width: 4),
              Text(
                time,
                style: const TextStyle(fontSize: 12),
              )
            ],
          ),
          const SizedBox(height: 8),

          Text('Assist: $assist'),
          Text('Contact: $contact'),

          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  address,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: onCancel,
                icon: const Icon(Icons.close, color: Colors.red),
                label: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onView,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('View'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
