import 'package:flutter/material.dart';

import 'common_profile.dart';

class CustomerProfileSupport extends StatefulWidget {
  const CustomerProfileSupport({super.key});

  @override
  State<CustomerProfileSupport> createState() => _CustomerProfileSupportState();
}

class _CustomerProfileSupportState extends State<CustomerProfileSupport> {
  static const String _supportPhone = '1234567890';
  static const String _supportEmail = 'support@example.com';
  static const Color _primaryColor = Color(0xFF1565C0);

  static const List<SupportOption> _faqOptions = [
    SupportOption(
      title: 'Booking Process',
      description: 'Learn how to make bookings easily',
      icon: Icons.question_answer,
      details: '''
To make a booking:
1. Log in to your account
2. Select your desired service
3. Choose a date and time
4. Confirm your booking details
5. Make payment to finalize
For more details, check our booking guide.
      ''',
    ),
    SupportOption(
      title: 'Payment Issues',
      description: 'Get help with payment-related problems',
      icon: Icons.payment,
      details: '''
Common payment issues:
1. Card Declined: Ensure sufficient funds or try another card
2. Payment Failed: Check internet connection and try again
3. Refund Status: Refunds typically process within 5-7 business days
Contact support if issues persist.
      ''',
    ),
    SupportOption(
      title: 'Account Management',
      description: 'Manage your account settings',
      icon: Icons.manage_accounts,
      details: '''
Account management options:
1. Update Profile: Change name, email, or phone
2. Password Reset: Use 'Forgot Password' link
3. Delete Account: Contact support for account deletion
4. Notification Settings: Customize in app settings
      ''',
    ),
    SupportOption(
      title: 'Cancellation & Refunds',
      description: 'Understand refund and cancellation policies',
      icon: Icons.cancel,
    ),
  ];

  static const List<SupportOption> _contactOptions = [
    SupportOption(
      title: 'Call Support',
      description: 'Hotline - 0778566774',
      icon: Icons.phone,
      actionType: SupportActionType.phone,
    ),
    SupportOption(
      title: 'Email Support',
      description: 'fixme@gmail.com',
      icon: Icons.email,
      actionType: SupportActionType.email,
    ),
    SupportOption(
      title: 'Submit Feedback',
      description: 'Send us your suggestions or complaints',
      icon: Icons.feedback,
      actionType: SupportActionType.feedback,
    ),
  ];

  final _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonProfile(
      title: 'Customer Profile',
      selectedIndex: 1,
      onTap: _handleBottomNavigation,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildFAQSection(context),
          const SizedBox(height: 24),
          _buildContactSection(context),
          const SizedBox(height: 24),
          _buildFeedbackButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Support Center',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: _primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'We\'re here to help you with any questions or issues',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildFAQSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Frequently Asked Questions'),
        const SizedBox(height: 12),
        ..._faqOptions.map((option) => _buildSupportCard(context, option)),
      ],
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Contact Support'),
        const SizedBox(height: 12),
        ..._contactOptions.map((option) => _buildSupportCard(context, option)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildSupportCard(BuildContext context, SupportOption option) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(option.icon, color: _primaryColor, size: 24),
        ),
        title: Text(
          option.title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            option.description,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () => _handleSupportOptionTap(context, option),
      ),
    );
  }

  Widget _buildFeedbackButton(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _handleFeedbackNavigation(context),
          icon: const Icon(Icons.rate_review),
          label: const Text('Give Feedback', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }

  void _handleBottomNavigation(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/profile');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/security');
    }
  }

  void _handleSupportOptionTap(BuildContext context, SupportOption option) {
    switch (option.actionType) {
      case SupportActionType.phone:
        _launchPhone(context);
        break;
      case SupportActionType.email:
        _launchEmail(context);
        break;
      case SupportActionType.feedback:
        _handleFeedbackNavigation(context);
        break;
      default:
        _handleFAQTap(context, option);
        break;
    }
  }

  void _handleFAQTap(BuildContext context, SupportOption option) {
    if (option.details != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(option.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Text(option.details!, style: const TextStyle(fontSize: 14)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: _primaryColor)),
            ),
          ],
        ),
      );
    } else {
      _showSnackBar(context, 'Opening ${option.title}...');
    }
  }

  void _handleFeedbackNavigation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Submit Feedback', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _feedbackController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Enter your feedback here',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: _primaryColor)),
          ),
          ElevatedButton(
            onPressed: () {
              if (_feedbackController.text.isNotEmpty) {
                _showSnackBar(context, 'Feedback submitted successfully!');
                Navigator.pop(context);
                _feedbackController.clear();
              } else {
                _showErrorSnackBar(context, 'Please enter your feedback');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _launchPhone(BuildContext context) {
    _showSnackBar(context, 'Phone call feature: $_supportPhone');
  }

  void _launchEmail(BuildContext context) {
    _showSnackBar(context, 'Email feature: $_supportEmail');
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class SupportOption {
  final String title;
  final String description;
  final IconData icon;
  final SupportActionType? actionType;
  final String? details;

  const SupportOption({
    required this.title,
    required this.description,
    required this.icon,
    this.actionType,
    this.details,
  });
}

enum SupportActionType {
  phone,
  email,
  chat,
  feedback,
}