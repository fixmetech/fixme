import 'package:flutter/material.dart';

class TermsAndConditionsDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'FixMe Terms and Conditions',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.7,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'By accessing or using the FixMe mobile application (the "App"), you agree to be bound by these Terms and Conditions. Please read them carefully.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),

                  // Section 1
                  Text(
                    '1. Introduction to FixMe Services',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildBullet('FixMe is a Flutter-based mobile application designed to connect users with nearby service providers in real-time.'),
                  _buildBullet('The App offers two main categories of services: Vehicle Services and Home Services.'),
                  _buildBullet('The "Find Now" option allows you to instantly locate and connect with available service providers in your vicinity for repair and maintenance services, similar to platforms like Uber and PickMe.'),
                  const SizedBox(height: 16),

                  // Section 2
                  Text(
                    '2. Technician Verification',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildBullet('FixMe implements a verification process for all technicians registering on the platform.'),
                  _buildBullet('Technicians must upload a photo of their NIC, a real-time selfie, and verify their phone number through OTP.'),
                  _buildBullet('Technicians must prove skills via certificates or evidence of past work (images/videos).'),
                  const SizedBox(height: 8),
                  Text(
                    'Technician Badges:',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  _buildBadge('🟢 "Verified Professional"', 'ID and professional certificate verified by FixMe'),
                  _buildBadge('🔵 "Verified by Experience"', 'ID verified with evidence of past work and references'),
                  _buildBadge('🟡 "On Probation"', 'Limited approval pending first customer reviews'),
                  const SizedBox(height: 16),

                  // Section 3
                  Text(
                    '3. Payment Terms and Process',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Compulsory Visiting Fee:',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  _buildBullet('0 – 5 km: LKR 200'),
                  _buildBullet('5 – 10 km: LKR 500'),
                  _buildBullet('10 km and above: LKR 1000'),
                  const SizedBox(height: 8),
                  _buildBullet('Visiting fee is payable upon technician arrival, regardless of job acceptance.'),
                  _buildBullet('You must explicitly approve estimated costs through the App before work begins.'),
                  _buildBullet('If you reject the estimated cost, only the visiting fee will be charged.'),
                  _buildBullet('Final payment can be processed through PayHere or paid in cash to the technician.'),
                  const SizedBox(height: 16),

                  // Section 4
                  Text(
                    '4. Customer Feedback and Complaint Resolution',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildBullet('Your feedback and ratings are crucial for the FixMe platform, particularly for technicians "On Probation."'),
                  _buildBullet('Complaints are reviewed by FixMe moderators, who may issue refunds or take corrective action.'),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  static Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, left: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 16)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  static Widget _buildBadge(String badge, String description) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            badge,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
