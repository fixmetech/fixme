import 'package:fixme/features/ongoing_request/screens/finish_job.dart';
import 'package:fixme/features/ongoing_request/screens/share_pin.dart';
import 'package:fixme/screens/serviceCenterProfile/service_center_profile.dart';
import 'package:fixme/features/technician_profile/screens/technician_profile.dart';
import 'package:fixme/widgets/home_banner.dart';
import 'package:fixme/widgets/home_headers.dart';
import 'package:fixme/widgets/recently_booked.dart';
import 'package:fixme/widgets/service_category_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeHeaders(),
            ServiceGrid(),
            RecentlyBooked(),
            FixMeBanner(),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}