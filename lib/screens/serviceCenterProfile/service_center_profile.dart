import 'package:flutter/material.dart';

class ServiceCenterProfile extends StatelessWidget {
  const ServiceCenterProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xffF8F8FA),
      body: Stack(
        children: [
          Column(
            children: [
              // Top Profile Section with Background Image
              Container(
                height: screenHeight * 0.42,
                width: double.infinity,
                decoration: BoxDecoration(
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
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  child: Stack(
                    children: [
                      // Background Image
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/service-center.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Dark overlay for better text visibility
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.3),
                              Colors.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                      // Content on top of the image
                      Padding(
                        padding: EdgeInsets.only(
                          top: screenHeight * 0.12,
                          left: 30,
                          right: 30,
                          bottom: 20,
                        ),
                        child: Column(
                          children: [
                            const Spacer(),
                            const SizedBox(height: 34),
                            // Service Center Name
                            const Text(
                              "Royal Auto Service Center",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10.0,
                                    color: Colors.black,
                                    offset: Offset(2.0, 2.0),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildStatColumn("26", "Completed Orders"),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.green.withOpacity(0.4),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.green[600],
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      elevation: 0,
                                    ),
                                    onPressed: () {},
                                    icon: const Icon(Icons.handyman, size: 18),
                                    label: const Text("Book an Appointment", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
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
                              const Text(
                                "4.5",
                                style: TextStyle(
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
                                          (index) => const Icon(Icons.star, color: Colors.orange, size: 24),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    "Based on 26 reviews",
                                    style: TextStyle(
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
                        _buildReview("John Doe", "Great service, arrived on time and fixed my issue quickly!", "2 days ago"),
                        _buildReview("Alice Smith", "Very professional and courteous. Highly recommend.", "1 week ago"),
                        _buildReview("Michael Lee", "Affordable and reliable technician. Will book again.", "2 weeks ago"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Back Button - Positioned at top left in circular box
          Positioned(
            top: MediaQuery.of(context).padding.top + 15,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 24),
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
                tooltip: 'Back',
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(12)),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Report Button - Positioned at top right in circular box
          Positioned(
            top: MediaQuery.of(context).padding.top + 15,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.flag, color: Colors.red, size: 24),
                onPressed: () {
                  _showReportDialog(context);
                },
                tooltip: 'Report',
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(12)),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Menu Button - Positioned at top right (next to report button)
          Positioned(
            top: MediaQuery.of(context).padding.top + 15,
            right: 80,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.black87, size: 24),
                onPressed: () {
                  _showMenuDialog(context);
                },
                tooltip: 'More Options',
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(12)),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
              const Text("Report Service Center"),
            ],
          ),
          content: const Text("Are you sure you want to report this service center? Please provide a reason for reporting."),
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
                // Handle report submission
              },
              child: const Text("Report"),
            ),
          ],
        );
      },
    );
  }

  static void _showMenuDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.share, color: Colors.blue),
                title: const Text("Share"),
                onTap: () {
                  Navigator.pop(context);
                  // Handle share action
                },
              ),
              ListTile(
                leading: const Icon(Icons.bookmark, color: Colors.green),
                title: const Text("Save to Favorites"),
                onTap: () {
                  Navigator.pop(context);
                  // Handle favorite action
                },
              ),
              ListTile(
                leading: const Icon(Icons.info, color: Colors.orange),
                title: const Text("More Information"),
                onTap: () {
                  Navigator.pop(context);
                  // Handle info action
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildStatColumn(String count, String label) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 5.0,
                  color: Colors.black,
                  offset: Offset(1.0, 1.0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 12,
              shadows: [
                Shadow(
                  blurRadius: 5.0,
                  color: Colors.black,
                  offset: Offset(1.0, 1.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildReview(String name, String feedback, String timeAgo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
                  (index) => const Icon(
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