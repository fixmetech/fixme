import 'package:fixme/features/ongoing_request/completed_job.dart';
import 'package:flutter/material.dart';

class MakePaymentScreen extends StatefulWidget {
  final String pin;
  final int requestId;
  final int estimatedCost;
  final String finishOtp;

  const MakePaymentScreen({
    Key? key,
    this.pin = "434024",
    this.requestId = 16,
    this.estimatedCost = 5000,
    this.finishOtp = "205699",
  }) : super(key: key);

  @override
  State<MakePaymentScreen> createState() => _MakePaymentScreenState();
}

class _MakePaymentScreenState extends State<MakePaymentScreen> {
  String? selectedPaymentMethod;

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
          'Job Details: #${widget.requestId}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                child: _PinBox(pin: widget.pin),
              ),
              const SizedBox(height: 24),

              // Step 2: Estimated Job Cost
              _buildStepItem(
                stepNumber: 2,
                isCompleted: true,
                isActive: false,
                title: 'Estimated Job Cost',
                description: 'You accepted the estimated job cost.',
                child: _CostSection(cost: widget.estimatedCost),
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

              // Step 4: Finish Job (Completed)
              _buildStepItem(
                stepNumber: 4, // <-- Fix: should be 4!
                title: 'Finish Job',
                description: 'Finalize the Job by sharing an OTP with the technician.',
                isCompleted: true,
                isActive: false,
                child: _FinishOtpSection(finishOtp: widget.finishOtp),
              ),
              const SizedBox(height: 24),

              // Step 5: Select Payment Method
              _buildStepItem(
                stepNumber: 5,
                isCompleted: false,
                isActive: true,
                title: 'Select Payment Method',
                description: 'Choose how you want to pay for the service.',
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      // Cash Button (immediate navigation)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedPaymentMethod = 'Cash';
                            });
                            // Delay for button effect then navigate
                            Future.delayed(const Duration(milliseconds: 100), () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CompletedJobScreen(),
                                ),
                              );
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedPaymentMethod == 'Cash'
                                ? Colors.green
                                : Colors.white,
                            foregroundColor: selectedPaymentMethod == 'Cash'
                                ? Colors.white
                                : Colors.black87,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                              side: BorderSide(
                                color: selectedPaymentMethod == 'Cash'
                                    ? Colors.green
                                    : Colors.grey[300]!,
                              ),
                            ),
                            elevation: selectedPaymentMethod == 'Cash' ? 2 : 0,
                          ),
                          child: const Text(
                            '💰 Cash',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Card Button (just highlight selection, no navigation yet)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedPaymentMethod = 'Card';
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedPaymentMethod == 'Card'
                                ? Colors.green
                                : Colors.white,
                            foregroundColor: selectedPaymentMethod == 'Card'
                                ? Colors.white
                                : Colors.black87,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                              side: BorderSide(
                                color: selectedPaymentMethod == 'Card'
                                    ? Colors.green
                                    : Colors.grey[300]!,
                              ),
                            ),
                            elevation: selectedPaymentMethod == 'Card' ? 2 : 0,
                          ),
                          child: const Text(
                            '💳 Card',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
        const Text(
          'Accepted Estimated Price: ',
          style: TextStyle(
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
