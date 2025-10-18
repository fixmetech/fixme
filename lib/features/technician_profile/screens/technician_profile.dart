import 'package:fixme/screens/report_technician.dart';
import 'package:fixme/screens/file_complaint_screen.dart';
import 'package:fixme/utils/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'technician_message_popup.dart';
import 'technician_request_screen.dart';
import 'package:fixme/features/technician_profile/controller/technician_profile_controller.dart';

class TechnicianProfile extends StatelessWidget {
  final String? technicianId;

  const TechnicianProfile({super.key, this.technicianId});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final controller = TechnicianProfileController(technicianId: technicianId);

    return Scaffold(
      backgroundColor: const Color(0xffF8F8FA),
      body: FutureBuilder<TechnicianProfileData>(
        future: controller.fetchProfileOnce(), // <- fetch via backend
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
                  // --- Top Profile Section ---
                  Container(
                    height: screenHeight * 0.38,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blue[700]!, Colors.blue[600]!],
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
                      left: 16,
                      right: 16,
                      bottom: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: FixMeSizes.appBarHeight,
                        ), // For top spacing or report button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // --- Profile Image ---
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.lightBlueAccent,
                                backgroundImage:
                                    (data.profilePictureUrl != null &&
                                        data.profilePictureUrl!.isNotEmpty)
                                    ? NetworkImage(data.profilePictureUrl!)
                                    : const AssetImage(
                                            'assets/images/select-user-technician.png',
                                          )
                                          as ImageProvider,
                              ),
                            ),

                            const SizedBox(width: 18),

                            // --- Name & Category ---
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.name ?? 'Technician',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black26,
                                          blurRadius: 2,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      data.serviceCategory ??
                                          'Professional Technician',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        // --- Stats + Buttons Row ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // --- Jobs Completed ---
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  (data.totalJobs ?? 0).toString(),
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Jobs Completed",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),

                            // --- Divider ---
                            Container(
                              height: 40,
                              width: 1,
                              color: Colors.white24,
                            ),

                            // --- Request Button ---
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF43A047),
                                    Color(0xFF2E7D32),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.greenAccent.withOpacity(0.4),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.handyman_rounded,
                                  size: 18,
                                ),
                                label: const Text(
                                  "Request",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TechnicianRequestScreen(
                                        technicianName:
                                            data.name ?? "Technician",
                                        technicianImage:
                                            (data.profilePictureUrl != null &&
                                                data
                                                    .profilePictureUrl!
                                                    .isNotEmpty)
                                            ? data.profilePictureUrl!
                                            : 'assets/images/select-user-technician.png',
                                        visitingFee: 75.0,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            // --- Message Icon Button ---
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.15),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.message_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                padding: const EdgeInsets.all(12),
                                onPressed: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) =>
                                        TechnicianMessagePopup(
                                          technicianName:
                                              data.name ?? 'Technician',
                                        ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
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
                            Row(
                              // Average Rating header
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                    size: 24,
                                  ),
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
                                  colors: [
                                    Colors.orange.withOpacity(0.1),
                                    Colors.amber.withOpacity(0.05),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.orange.withOpacity(0.2),
                                ),
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
                                  const Text(
                                    "/5.0",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
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
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
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
                                  child: const Icon(
                                    Icons.reviews,
                                    color: Colors.blue,
                                    size: 24,
                                  ),
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
                            FutureBuilder<List<TechnicianFeedback>>(
                              future: controller.fetchFeedbacks(),
                              builder: (context, reviewSnapshot) {
                                if (reviewSnapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                if (reviewSnapshot.hasError) {
                                  return Text('Failed to load reviews');
                                }
                                final reviews = reviewSnapshot.data ?? [];
                                if (reviews.isEmpty) {
                                  return const Text('No reviews yet.');
                                }
                                return Column(
                                  children: reviews.map((fb) => _buildReview(
                                    fb.customerName ?? "Pabodya Vithana",
                                    fb.review,
                                    _timeAgoSinceDate(fb.createdAt),
                                    fb.rating,
                                  )).toList(),
                                );
                              },
                            ),


                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Report Button - Positioned at top right
              // Report Button - Positioned at top right
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    // 👉 Handle report action here
                    print('Report tapped');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.flag_rounded,
                          size: 18,
                          color: Colors.white.withOpacity(0.95),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Report',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.95),
                            fontWeight: FontWeight.w600,
                            fontSize: 13.5,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Back Button - Positioned at top left
              Positioned(
                top: FixMeSizes.appBarHeight,
                left: 20,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white, // pure white icon
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.of(context).maybePop();
                  },
                  tooltip: 'Back',
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static void _showReportDialog(
    BuildContext context,
    TechnicianProfileData technicianData,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.flag, color: Colors.red[600]),
              const SizedBox(width: 10),
              const Text("Report Technician"),
            ],
          ),
          content: const Text(
            "Are you sure you want to report this technician? Please provide a reason for reporting.",
          ),
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
                    builder: (context) => FileComplaintScreen(
                      selectedTechnician: {
                        'id': technicianData.id ?? 104,
                        'name': technicianData.name ?? 'kasun',
                        'email': technicianData.email ?? 'kasun@gmail.com',
                        'phone': technicianData.phone ?? '0712345678',
                        'profession':
                            technicianData.serviceCategory ?? 'carservice',
                        'badge': technicianData.badgeType ?? 'standard',
                        'rating': technicianData.rating ?? 0.0,
                      },
                    ),
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

  static Widget _buildReview(String name, String feedback, String timeAgo, int rating) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
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
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(
              5,
                  (index) => Icon(
                index < rating ? Icons.star : Icons.star_border,
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

  static String _timeAgoSinceDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays > 7) return '${(difference.inDays / 7).floor()} weeks ago';
    if (difference.inDays > 0) return '${difference.inDays} days ago';
    if (difference.inHours > 0) return '${difference.inHours} hours ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes} minutes ago';
    return 'just now';
  }

}
