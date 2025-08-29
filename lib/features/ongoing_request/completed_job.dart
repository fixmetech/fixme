import 'package:fixme/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';

class CompletedJobScreen extends StatelessWidget {
  final String pin;
  final int requestId;
  final int estimatedCost;
  final String finishOtp;
  final String paymentMethod;

  const CompletedJobScreen({
    Key? key,
    this.pin = "434024",
    this.requestId = 16,
    this.estimatedCost = 5000,
    this.finishOtp = "205699",
    this.paymentMethod = "Cash", // Default: Cash, can be passed as Card
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Job Details: #$requestId',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Step 1: Share PIN (Completed)
              _buildStepItem(
                stepNumber: 1,
                title: 'Share PIN',
                description: 'Share this PIN with the technician to verify their arrival.',
                isCompleted: true,
                isActive: false,
                child: _PinBox(pin: pin),
              ),
              const SizedBox(height: 24),
          
              // Step 2: Estimated Job Cost (Completed)
              _buildStepItem(
                stepNumber: 2,
                title: 'Estimated Job Cost',
                description: 'You accepted the estimated job cost.',
                isCompleted: true,
                isActive: false,
                child: _CostSection(cost: estimatedCost),
              ),
              const SizedBox(height: 24),
          
              // Step 3: Ongoing (Completed)
              _buildStepItem(
                stepNumber: 3,
                isCompleted: true,
                isActive: false,
                title: 'Ongoing',
                description: 'Technician finished working on your job.',
              ),
              const SizedBox(height: 24),
          
              // Step 4: Finish Job (Completed)
              _buildStepItem(
                stepNumber: 4,
                title: 'Finish Job',
                description: 'Finalize the Job by sharing an OTP with the technician.',
                isCompleted: true,
                isActive: false,
                child: _FinishOtpSection(finishOtp: finishOtp),
              ),
              const SizedBox(height: 24),
          
              // Step 5: Payment Completed (Completed)
              _buildStepItem(
                stepNumber: 5,
                title: 'Payment Method Selected',
                description: 'You have selected to pay by cash.',
                isCompleted: true,
                isActive: false,
                child: _PaymentSummary(
                  method: paymentMethod
                ),
              ),
              const SizedBox(height: 24),
          
              // Step 6: Review (Active)
              _buildStepItem(
                stepNumber: 6,
                title: 'Review',
                description: 'Rate the technician and leave a review.',
                isCompleted: false,
                isActive: true,
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: ElevatedButton(
                    onPressed: () {
                      _showRatingModal(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Rate Technician',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRatingModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const RatingModal();
      },
    );
  }

  Widget _buildStepItem({
    required int stepNumber,
    required String title,
    required String description,
    required bool isCompleted,
    required bool isActive,
    Widget? child,
  }) {
    Color getStepColor() {
      if (isCompleted) return Colors.green;
      if (isActive) return Colors.blue;
      return Colors.grey;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step number circle or check
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: getStepColor(),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(
              Icons.check,
              color: Colors.white,
              size: 18,
            )
                : Text(
              '$stepNumber',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.blue : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.4,
                ),
              ),
              if (child != null) ...[
                const SizedBox(height: 12),
                child,
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// Payment summary step
class _PaymentSummary extends StatelessWidget {
  final String method;
  const _PaymentSummary({required this.method});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.payment, color: Colors.green, size: 22),
        const SizedBox(width: 8),
        Text(
          'Select to pay by $method',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

// Rating Modal Widget
class RatingModal extends StatefulWidget {
  const RatingModal({Key? key}) : super(key: key);

  @override
  State<RatingModal> createState() => _RatingModalState();
}

class _RatingModalState extends State<RatingModal> {
  int _selectedRating = 0;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Rate Technician',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Star Rating Section
            const Text(
              'How was your experience?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedRating = index + 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      index < _selectedRating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 40,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),

            // Rating text
            if (_selectedRating > 0)
              Center(
                child: Text(
                  _getRatingText(_selectedRating),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            const SizedBox(height: 24),

            // Feedback Section
            const Text(
              'Leave a feedback for the technician',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: _feedbackController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Share your experience with the technician...',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedRating > 0 ? () => _submitRating() : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedRating > 0 ? Colors.green : Colors.grey[300],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: _selectedRating > 0 ? 2 : 0,
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }

  void _submitRating() {
    // Handle rating submission here
    print('Rating: $_selectedRating');
    print('Feedback: ${_feedbackController.text}');

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thank you for your feedback!'),
        backgroundColor: Colors.green,
      ),
    );

    // Close modal
    Navigator.pop(context);
    Get.offAll(HomeScreen());
  }
}

// Reusable PIN box
class _PinBox extends StatelessWidget {
  final String pin;
  const _PinBox({required this.pin});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'PIN: $pin',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

// Reusable Cost Section
class _CostSection extends StatelessWidget {
  final int cost;
  const _CostSection({required this.cost});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                'Accepted Estimated Price:',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              '✅',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Rs. $cost',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

// Reusable Finish OTP Section
class _FinishOtpSection extends StatelessWidget {
  final String finishOtp;
  const _FinishOtpSection({required this.finishOtp});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Finish PIN (OTP):',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'PIN: $finishOtp',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'This Job is successfully completed!',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}