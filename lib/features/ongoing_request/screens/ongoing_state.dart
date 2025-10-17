import 'package:fixme/features/ongoing_request/screens/finish_job.dart';
import 'package:flutter/material.dart';

// controller
import 'package:fixme/features/ongoing_request/controller/ongoing_state_controller.dart';

class OngoingScreen extends StatefulWidget {
  /// Firestore/DB job document id – REQUIRED and passed from previous screen
  final String jobId;

  /// Optional UI display values (fallbacks until live data loads)
  final String? pin;
  final int? requestId;
  final int? estimatedCost;

  const OngoingScreen({
    Key? key,
    required this.jobId,         // ← dynamic job id (required)
    this.pin,                    // optional UI fallback
    this.requestId,              // optional UI fallback
    this.estimatedCost,          // optional UI fallback
  }) : super(key: key);

  @override
  State<OngoingScreen> createState() => _OngoingScreenState();
}

class _OngoingScreenState extends State<OngoingScreen> {
  final OngoingStateController _controller = OngoingStateController();

  String? _livePin;
  int? _liveEstimatedCost;
  VoidCallback? _cancelPoll;

  @override
  void initState() {
    super.initState();

    // 1) Load once with the dynamic jobId
    _controller.loadJob(widget.jobId).then((job) {
      if (!mounted) return;
      setState(() {
        _livePin = job.pin.toString();
        _liveEstimatedCost = (job.estimatedCost ?? widget.estimatedCost ?? 0).toInt();
      });
    }).catchError((e) {
      debugPrint('loadJob error: $e'); // non-fatal; will use fallbacks
    });

    // 2) Start polling until technician marks finish
    _cancelPoll = _controller.startPollingUntilFinish(
      jobId: widget.jobId,
      onReached: () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => FinishJobScreen(
              jobId: widget.jobId,             // ← REQUIRED
              requestId: widget.requestId ?? 0,
              pin: _livePin ?? widget.pin ?? '—',
              estimatedCost: _liveEstimatedCost ?? widget.estimatedCost ?? 0,
            ),
          ),
        );
      },
      onError: (e) => debugPrint('poll error: $e'),
    );
  }

  @override
  void dispose() {
    _cancelPoll?.call();
    _controller.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayPin = _livePin ?? widget.pin ?? '—';
    final displayEstimated = _liveEstimatedCost ?? widget.estimatedCost ?? 0;

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
          'Ongoing Request${widget.requestId != null ? ': #${widget.requestId}' : ''}',
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
              // Step 1: Share PIN — uses live pin if loaded, else fallback
              _buildStepItem(
                stepNumber: 1,
                isCompleted: true,
                isActive: false,
                title: 'Share PIN',
                description: 'Share this PIN with the technician to verify their arrival.',
                child: _PinBox(pin: displayPin),
              ),
              const SizedBox(height: 24),

              // Step 2: Estimated Job Cost — uses live estimate if loaded, else fallback
              _buildStepItem(
                stepNumber: 2,
                isCompleted: true,
                isActive: false,
                title: 'Estimated Job Cost',
                description: 'You accepted the estimated job cost.',
                child: _CostSection(cost: displayEstimated),
              ),
              const SizedBox(height: 24),

              // Step 3: Ongoing
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
            const Flexible(
              child: Text(
                'Accepted Estimated Price:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            const Text('✅', style: TextStyle(fontSize: 20)),
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
