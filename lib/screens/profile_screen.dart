import 'package:flutter/material.dart';
import 'file_complaint_screen.dart';
import 'my_complaints_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Saduni Gamage',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('saduniGamage@gmail.com'),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Service History'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Ratings & Reviews'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('File a Complaint'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FileComplaintScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text('My Complaints'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyComplaintsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
