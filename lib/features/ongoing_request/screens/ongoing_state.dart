import 'package:fixme/features/ongoing_request/screens/finish_job.dart';
import 'package:flutter/material.dart';

// NEW: controller import
import 'package:fixme/features/ongoing_request/controller/ongoing_state_controller.dart';

class OngoingScreen extends StatefulWidget {
  final String pin;
  final int requestId;
  final int estimatedCost;

  // NEW: the Firestore job document id to load/poll
  final String jobId;

  const OngoingScreen({
    Key? key,
    this.pin = "434024",
    this.requestId = 16,
    this.estimatedCost = 5000,
    this.jobId = '0giWzXu3hWWmCFKvFIdb', // default for quick testing
  }) : super(key: key);

  @override
  State<OngoingScreen> createState() => _OngoingScreenState();
}

class _OngoingScreenState extends State<OngoingScreen> {
  // NEW: controller + loaded values used by the existing view
  final OngoingStateController _controller = OngoingStateController();
  String? _livePin;
  int? _liveEstimatedCost;
  VoidCallback? _cancelPoll;

  @override
  void initState() {
    super.initState();

    // 1) load the job once to get live PIN & estimate
    _controller.loadJob(widget.jobId).then((job) {
      if (!mounted) return;
      setState(() {
        _livePin = job.pin.toString();
        _liveEstimatedCost = (job.estimatedCost ?? widget.estimatedCost).toInt();
      });
    }).catchError((e) {
      // Non-fatal: we keep showing defaults if load fails
      debugPrint('loadJob error: $e');
    });

    // 2) start polling until status becomes 'TechnicianFinish'
    _cancelPoll = _controller.startPollingUntilFinish(
      jobId: widget.jobId,
      onReached: () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => FinishJobScreen()),
        );
      },
      onError: (e) => debugPrint('poll error: $e'),
      // maxDuration: const Duration(minutes: 5), // optional
    );
  }

  @override
  void dispose() {
    _cancelPoll?.call();      // NEW: stop the poller
    _controller.cancel();     // safeguard
    super.dispose();
  }

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
          'Ongoing Request: #${widget.requestId}',
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
              // Step 1: Share PIN (UI unchanged) — uses live pin if available
              _buildStepItem(
                stepNumber: 1,
                isCompleted: true,
                isActive: false,
                title: 'Share PIN',
                description: 'Share this PIN with the technician to verify their arrival.',
                child: _PinBox(pin: _livePin ?? widget.pin),
              ),
              const SizedBox(height: 24),

              // Step 2: Estimated Job Cost (UI unchanged) — uses live estimate if available
              _buildStepItem(
                stepNumber: 2,
                isCompleted: true,
                isActive: false,
                title: 'Estimated Job Cost',
                description: 'You accepted the estimated job cost.',
                child: _CostSection(cost: _liveEstimatedCost ?? widget.estimatedCost),
              ),
              const SizedBox(height: 24),

              // Step 3: Ongoing (UI unchanged)
              _buildStepItem(
                stepNumber: 3,
                isCompleted: false,
                isActive: true,
                title: 'Ongoing',
                description: 'Technician is currently working on your job.',
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
      return Colors.grey[400]!;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step number or check
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: getStepColor(),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : Text(
              '$stepNumber',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.blue : Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
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
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}

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
