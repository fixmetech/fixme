import 'package:flutter/material.dart';

class HomeServicesList extends StatelessWidget {
  const HomeServicesList({super.key});

  final List<Map<String, dynamic>> services = const [
    {"label": "Plumbing Support", "icon": Icons.plumbing, "color": Colors.blue},
    {"label": "Carpentry Support", "icon": Icons.build, "color": Colors.orange},
    {"label": "Electrical Support", "icon": Icons.electrical_services, "color": Colors.amber},
    {"label": "Cleaning", "icon": Icons.cleaning_services, "color": Colors.green},
    {"label": "Painting", "icon": Icons.format_paint, "color": Colors.purple},
    {"label": "Landscaping", "icon": Icons.park, "color": Color.fromARGB(255, 45, 47, 47)},
    {"label": "Appliance Repair", "icon": Icons.build_circle, "color": Colors.red},
    {"label": "Renovation Services", "icon": Icons.construction, "color": Colors.indigo},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade50,
            Colors.white,
            Colors.blue.shade50,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Services list
            ...services.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> service = entry.value;
              
              return TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 200 + (index * 50)),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.grey.shade50,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: service['color'].withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: service['color'].withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${service['label']} clicked"),
                            backgroundColor: service['color'],
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            // Icon container with gradient
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    service['color'].withOpacity(0.1),
                                    service['color'].withOpacity(0.2),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: service['color'].withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                service['icon'],
                                color: service['color'],
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 20),
                            // Service details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    service['label'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Professional & reliable service',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Arrow icon with subtle animation
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: service['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: service['color'],
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
            // Bottom spacing
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}