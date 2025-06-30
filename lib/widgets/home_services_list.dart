import 'package:flutter/material.dart';

class HomeServicesList extends StatelessWidget {
  const HomeServicesList({super.key});

  final List<Map<String, dynamic>> services = const [
    {"label": "Plumbing Support", "icon": Icons.plumbing},
    {"label": "Carpentry Support", "icon": Icons.build},
    {"label": "Electrical Support", "icon": Icons.electrical_services},
    {"label": "Cleaning", "icon": Icons.cleaning_services},
    {"label": "Painting", "icon": Icons.format_paint},
    {"label": "Landscaping", "icon": Icons.park},
    {"label": "Appliance Repair", "icon": Icons.build},
    {"label": "Renovation Services", "icon": Icons.construction},
    {"label": "Renovation Services", "icon": Icons.construction},
    {"label": "Renovation Services", "icon": Icons.construction},
    {"label": "Renovation Services", "icon": Icons.construction},
    {"label": "Renovation Services", "icon": Icons.construction},
    {"label": "Renovation Services", "icon": Icons.construction},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
      child: Column(
        children: services.map((service) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 4,
              ),
              title: Text(
                service['label'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  service['icon'],
                  color: Colors.blueAccent,
                  size: 20,
                ),
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${service['label']} clicked")),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
