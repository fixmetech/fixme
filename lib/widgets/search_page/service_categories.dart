import 'package:flutter/material.dart';

class ServiceCategories extends StatelessWidget {
  final String selectedService;
  final Function(String) onServiceSelected;

  const ServiceCategories({
    Key? key,
    required this.selectedService,
    required this.onServiceSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final services = [
      {'name': 'Service', 'image': 'assets/images/service_center.png'},
      {'name': 'Towing', 'image': 'assets/images/towing1.png'},
      {'name': 'Electricians', 'image': 'assets/images/electrician.png'},
      {'name': 'Plumbers', 'image': 'assets/images/plumbing.png'},
      {'name': 'Gardening', 'image': 'assets/images/gardening.png'},
      {'name': 'Repair', 'image': 'assets/images/plumbing.png'},
    ];

    return Container(
      height: 105,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          final isSelected = selectedService == service['name'];
          
          return GestureDetector(
            onTap: () => onServiceSelected(service['name'] as String),
            child: Container(
              width: 80,
              margin: EdgeInsets.only(right: 16),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color.fromARGB(255, 134, 200, 255) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(40),
                      border: isSelected 
                        ? Border.all(color: const Color.fromARGB(255, 134, 200, 255), width: 2)
                        : Border.all(color: Colors.grey[300]!, width: 1),
                    ),
                    child: ClipRRect(
  borderRadius: BorderRadius.circular(40),
  child: Padding(
    padding: const EdgeInsets.all(10.0),
    child: Image.asset(
      service['image'] as String,
      fit: BoxFit.contain,
    ),
  ),
),
                  ),
                  SizedBox(height: 8),
                  Text(
                    service['name'] as String,
                    style: TextStyle(
                      color: isSelected ?const Color.fromARGB(255, 134, 200, 255) : Colors.grey[700],
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}