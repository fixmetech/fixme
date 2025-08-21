import 'package:fixme/screens/report_technician.dart';
import 'package:flutter/material.dart';
import 'technician_message_popup.dart';
import 'technician_request_screen.dart';
import 'package:fixme/features/technician_profile/controller/technician_profile_controller.dart';

class TechnicianProfile extends StatelessWidget {
  const TechnicianProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final controller = TechnicianProfileController(); // put this at top of build()

    return Scaffold(
      backgroundColor: const Color(0xffF8F8FA),
      body: FutureBuilder<TechnicianProfileData>(
        future: controller.fetchProfileOnce(),   // <- fetch via backend
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Technician not found'));
          }
          final data = snapshot.data!;
          // 👇 your existing Stack, but swap hardcoded values with `data.*`
          return Stack(
            children: [
              Column(
                children: [
                  // Top Profile Section
                  Container(
                    height: screenHeight * 0.4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.blue[700]!,
                          Colors.blue[600]!,
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.only(
                      top: screenHeight * 0.08,
                      left: 10,
                      right: 10,
                      bottom: 20,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 30), // Space for report button
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 55,
                                backgroundColor: Colors.lightBlueAccent,
                                backgroundImage: (data.profilePictureUrl != null && data.profilePictureUrl!.isNotEmpty)
                                    ? NetworkImage(data.profilePictureUrl!)
                                    : Image.asset('assets/images/select-user-technician.png').image as ImageProvider,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.name ?? 'Technician',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      shadows: [Shadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1))],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      data.serviceCategory ?? 'Professional Technician',
                                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatColumn(
                              (data.totalJobs ?? 0).toString(),
                              "Completed Orders",
                            ),
                            Container( // Request button
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.lightGreenAccent.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.green[600],
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TechnicianRequestScreen(
                                        technicianName: data.name ?? "Technician",
                                        technicianImage: (data.profilePictureUrl != null && data.profilePictureUrl!.isNotEmpty)
                                            ? data.profilePictureUrl!
                                            : 'assets/images/select-user-technician.png',
                                        visitingFee: 75.0, // keep placeholder if not stored
                                      ),
                                    ),
                                  );
                                },

                                icon: const Icon(Icons.handyman, size: 16),
                                label: const Text("Request", style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                            Container( // Message button
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                  side: const BorderSide(color: Colors.white, width: 2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                onPressed: () async {
                                  final result = await showDialog(
                                    context: context,
                                    builder: (context) => TechnicianMessagePopup(
                                      technicianName: data.name ?? 'Technician',
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.message, size: 18),
                                label: const Text("Message", style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                  // Bottom Content Section
                  Expanded(
                    child: Container(
                      width: screenWidth,
                      padding: const EdgeInsets.all(25),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row( // Average Rating header
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.star, color: Colors.orange, size: 24),
                                ),
                                const SizedBox(width: 15),
                                const Text(
                                  "Average Rating",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.orange.withOpacity(0.1), Colors.amber.withOpacity(0.05)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.orange.withOpacity(0.2)),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    (data.rating ?? 0).toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  const Text("/5.0", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey)),
                                  const SizedBox(width: 15),
                                  Column(
                                    children: [
                                      Row(
                                        children: List.generate(
                                          5,
                                          (index) => Icon(
                                            index < (data.rating ?? 0).round()
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.orange,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Based on ${(data.totalJobs ?? 0)} jobs",
                                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            // Reviews section (static in your snippet) — leave as-is or wire to a reviews source later
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.reviews, color: Colors.blue, size: 24),
                                ),
                                const SizedBox(width: 15),
                                const Text(
                                  "Customer Reviews",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildReview("Kasun Mendis", "Great service, arrived on time and fixed my issue quickly!", "2 days ago"),
                            _buildReview("Akith Jayalath", "Very professional and courteous. Highly recommend.", "1 week ago"),
                            _buildReview("Madusha Pabasara", "Affordable and reliable technician. Will book again.", "2 weeks ago"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Report Button - Positioned at top right
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                right: 20,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red[600],
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      // Handle report action
                      _showReportDialog(context);
                    },
                    icon: const Icon(Icons.flag, size: 18),
                    label: const Text(
                      "Report",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              // Back Button - Positioned at top left
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                left: 20,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    onPressed: () {
                      Navigator.of(context).maybePop();
                    },
                    tooltip: 'Back',
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue[700]!),
                      padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      elevation: MaterialStateProperty.all<double>(0),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              Icon(Icons.flag, color: Colors.red[600]),
              const SizedBox(width: 10),
              const Text("Report Technician"),
            ],
          ),
          content: const Text("Are you sure you want to report this technician? Please provide a reason for reporting."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FileComplaintScreen(),
                  ),
                );
              },
              child: const Text("Report"),
            ),
          ],
        );
      },
    );
  }

  static Widget _buildStatColumn(String count, String label) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildReview(String name, String feedback, String timeAgo) {
    return Container(
      margin: const EdgeInsets.only(bottom:5),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              Text(
                timeAgo,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(
              5,
                  (index) => Icon(
                Icons.star,
                color: Colors.orange,
                size: 16,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            feedback,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
