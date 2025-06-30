import 'package:fixme/widgets/home_services_header.dart';
import 'package:fixme/widgets/home_services_list.dart';
import 'package:flutter/material.dart';

class AsapHomeServices extends StatelessWidget {
  const AsapHomeServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: const [
            HomeServicesHeader(), // stays fixed at top
            Expanded(
              child: HomeServicesList(), // scrollable
            ),
          ],
        ),
      ),
    );
  }
}
