import 'package:fixme/widgets/activity_card.dart';
import 'package:flutter/material.dart';

class ActivityList extends StatelessWidget {
  final String type;
  const ActivityList({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> activities = [
      {
        'title': 'Paint Job - Home',
        'assist': 'Bandula Karol',
        'contact': '071123122',
        'address': 'I/2/3 Andro streat, Narahenpita, colombo 08...',
        'time': 'In 10min',
      },
      {
        'title': 'Car Fix - Car',
        'assist': 'Bandula Karol',
        'contact': '071123122',
        'address': 'I/2/3 Andro streat, Narahenpita, colombo 08...',
        'time': 'In 10min',
      },
      {
        'title': 'Electrical Job - Home',
        'assist': 'Bandula Karol',
        'contact': '071123122',
        'address': 'I/2/3 Andro streat, Narahenpita, colombo 08...',
        'time': 'In 10min',
      },
      {
        'title': 'Electrical Job - Home',
        'assist': 'Bandula Karol',
        'contact': '071123122',
        'address': 'I/2/3 Andro streat, Narahenpita, colombo 08...',
        'time': 'In 10min',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: ActivityCard(
            title: activity['title'],
            assist: activity['assist'],
            contact: activity['contact'],
            address: activity['address'],
            time: activity['time'],
            onCancel: () {
              // Handle cancel
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Cancelled')));
            },
            onView: () {
              // Handle view
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Viewing Details')));
            },
          ),
        );
      },
    );
  }
}
