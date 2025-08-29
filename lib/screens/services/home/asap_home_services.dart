import 'package:fixme/widgets/home_services_header.dart';
import 'package:fixme/widgets/home_services_list.dart';
import 'package:flutter/material.dart';

class AsapHomeServices extends StatelessWidget {
  const AsapHomeServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Stack(
        children: [
          // Scrollable list - positioned to fill entire screen with top padding
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(top: 170), // Space for header
              child: Container(
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
                child: const HomeServicesList(),
              ),
            ),
          ),
          // Fixed header - positioned at the top
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: HomeServicesHeader(),
          ),
        ],
      ),
    );
  }
}


