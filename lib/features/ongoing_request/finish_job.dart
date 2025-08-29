import 'package:fixme/features/ongoing_request/completed_job.dart';
import 'package:fixme/features/ongoing_request/make_payment.dart';
import 'package:flutter/material.dart';

class FinishJobScreen extends StatelessWidget {
  final String pin;
  final int requestId;
  final int estimatedCost;

  const FinishJobScreen({
    Key? key,
    this.pin = "434024",
    this.requestId = 16,
    this.estimatedCost = 5000,
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
        child: Column(
          children: [
            // Step 1: Share PIN
            _buildStepItem(
              stepNumber: 1,
              isCompleted: true,
              isActive: false,
              title: 'Share PIN',
              description: 'Share this PIN with the technician to verify their arrival.',
              child: _PinBox(pin: pin),
            ),
            const SizedBox(height: 24),

            // Step 2: Estimated Job Cost
            _buildStepItem(
              stepNumber: 2,
              isCompleted: true,
              isActive: false,
              title: 'Estimated Job Cost',
              description: 'You accepted the estimated job cost.',
              child: _CostSection(cost: estimatedCost),
            ),
            const SizedBox(height: 24),

            // Step 3: Ongoing
            _buildStepItem(
              stepNumber: 3,
              isCompleted: true,
              isActive: false,
              title: 'Ongoing',
              description: 'Technician finished working on your job.',
            ),
            const SizedBox(height: 24),

            // Step 4: Finish Job
            _buildStepItem(
              stepNumber: 4,
              isCompleted: false,
              isActive: true,
              title: 'Finish Job',
              description: 'Finalize the Job by sharing an OTP with the technician.',
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MakePaymentScreen()),
                  ),
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
                    'Finish Job',
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
        // Step number circle
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
              if (child != null) child,
            ],
          ),
        ),
      ],
    );
  }
}

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

class _CostSection extends StatelessWidget {
  final int cost;
  const _CostSection({required this.cost});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Accepted Estimated Price: ',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Text(
          'Rs. $cost',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 6),
        const Text(
          '✅',
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
