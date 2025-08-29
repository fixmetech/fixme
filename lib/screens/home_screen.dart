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
            // testing
            SizedBox(height: 20), 
            // link to camera screen
            // Center(
            //   child: ElevatedButton(
            //     onPressed: () => Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => TestCameraScreen()),
            //     ),
            //     child: Text('Open Camera Screen'),
            //   ),
            // ),
            //  SizedBox(height: 20),
            // // link to camera screen
            // Center(
            //   child: ElevatedButton(
            //     onPressed: () => Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => JobDetailsScreen()),
            //     ),
            //     child: Text('Share Pin'),
            //   ),
            // ),
            // SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
