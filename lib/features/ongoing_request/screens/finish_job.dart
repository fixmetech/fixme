import 'package:fixme/features/ongoing_request/screens/completed_job.dart';
import 'package:fixme/features/ongoing_request/screens/make_payment.dart';
import 'package:fixme/mainScreen.dart';
import 'package:flutter/material.dart';

// controllers
import 'package:fixme/features/ongoing_request/controller/finish_job_controller.dart';
import 'package:fixme/features/ongoing_request/controller/ongoing_state_controller.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class FinishJobScreen extends StatefulWidget {
  // REQUIRED: we now always receive the dynamic jobId
  final String jobId;

  // Optional UI fallbacks (used only until fetch completes)
  final String? pin;
  final int? requestId;
  final int? estimatedCost;

  const FinishJobScreen({
    Key? key,
    required this.jobId,          // ← required
    this.pin,
    this.requestId,
    this.estimatedCost,
  }) : super(key: key);

  @override
  State<FinishJobScreen> createState() => _FinishJobScreenState();
}

class _FinishJobScreenState extends State<FinishJobScreen> {
  final FinishJobController _finishCtrl = FinishJobController();
  final OngoingStateController _jobLoader = OngoingStateController();

  String? _livePin;
  int? _liveEstimatedCost;

  @override
  void initState() {
    super.initState();

    // Re-load the job by id, so data is always fresh on this screen, too
    _jobLoader.loadJob(widget.jobId).then((job) {
      if (!mounted) return;
      setState(() {
        _livePin = job.pin?.toString();
        _liveEstimatedCost = (job.estimatedCost ?? widget.estimatedCost ?? 0).toInt();
      });
    }).catchError((e) {
      debugPrint('FinishJobScreen loadJob error: $e'); // non-fatal, use fallbacks
    });
  }

  Future<void> _handleFinish() async {
    final res = await _finishCtrl.issueFinishPin(jobId: widget.jobId);
    if (!mounted) return;

    if (res.ok) {
      if (res.finishPin != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Your finish OTP: ${res.finishPin}')),
        );
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MakePaymentScreen(
            jobId: widget.jobId,                 // required
            requestId: widget.requestId,         // optional UI
            pin: _livePin ?? widget.pin,         // optional UI
            estimatedCost: _liveEstimatedCost ?? widget.estimatedCost, // optional UI
            finishOtp: res.finishPin?.toString(),// optional prefill
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res.message ?? 'Failed to generate finish PIN')),
      );
    }
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
          onPressed: () {
            // Navigate to MainScreen with Activities tab
            Get.offAll(const MainScreen());
          },
        ),
        title: Text(
          'Job Details${widget.requestId != null ? ': #${widget.requestId}' : ''}',
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
            _buildStepItem(
              stepNumber: 1,
              isCompleted: true,
              isActive: false,
              title: 'Share PIN',
              description: 'Share this PIN with the technician to verify their arrival.',
              child: _PinBox(pin: displayPin),
            ),
            const SizedBox(height: 24),

            _buildStepItem(
              stepNumber: 2,
              isCompleted: true,
              isActive: false,
              title: 'Estimated Job Cost',
              description: 'You accepted the estimated job cost.',
              child: _CostSection(cost: displayEstimated),
            ),
            const SizedBox(height: 24),

            _buildStepItem(
              stepNumber: 3,
              isCompleted: true,
              isActive: false,
              title: 'Ongoing',
              description: 'Technician finished working on your job.',
            ),
            const SizedBox(height: 24),

            _buildStepItem(
              stepNumber: 4,
              isCompleted: false,
              isActive: true,
              title: 'Finish Job',
              description: 'Finalize the Job by sharing an OTP with the technician.',
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                child: ElevatedButton(
                  onPressed: _handleFinish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Finish Job',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(color: getStepColor(), shape: BoxShape.circle),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : Text(
              '$stepNumber',
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
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
                  color: isActive ? Colors.blue : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
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
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
      child: Text(
        'PIN: $pin',
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
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
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        Text(
          'Rs. $cost',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(width: 6),
        const Text('✅', style: TextStyle(fontSize: 20)),
      ],
    );
  }
}
