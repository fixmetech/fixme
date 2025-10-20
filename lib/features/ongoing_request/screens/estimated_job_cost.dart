import 'package:fixme/features/ongoing_request/screens/ongoing_state.dart';
import 'package:fixme/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:fixme/features/ongoing_request/controller/estimated_job_cost_controller.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class ServiceRequestScreen extends StatefulWidget {
  /// The dynamic job id passed from the previous screen (Share PIN)
  final String jobRequestId;
  final int? requestId; // Optional UI display number

  const ServiceRequestScreen({
    Key? key,
    required this.jobRequestId, // dynamic from backend
    this.requestId,
  }) : super(key: key);

  @override
  State<ServiceRequestScreen> createState() => _ServiceRequestScreenState();
}

class _ServiceRequestScreenState extends State<ServiceRequestScreen> {
  final ServiceRequestApi _api = ServiceRequestApi();
  late Future<JobRequestDetails> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.fetchJob(widget.jobRequestId); // ← dynamic id from SharePin
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _api.fetchJob(widget.jobRequestId);
    });
  }

  Future<void> _onDecision(String decision, int shownCost) async {
    try {
      await _api.approveOrReject(
        jobId: widget.jobRequestId, // ← dynamic
        decision: decision,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            decision == 'Approved'
                ? 'Job cost accepted!'
                : 'Job cost rejected!',
          ),
        ),
      );

      if (decision == 'Approved') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OngoingScreen(
              jobId: widget.jobRequestId,
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Action failed: $e')),
      );
    }
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
          onPressed: () {
            // Navigate to MainScreen with Activities tab
            Get.offAll(const MainScreen());
          },
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
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<JobRequestDetails>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 100),
                  Center(
                    child: Text(
                      'Failed to load: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              );
            }

            final job = snapshot.data!;
            final pin = job.pin.toString();
            final estimated = (job.estimatedCost ?? 0).toInt();

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    _buildStepItem(
                      stepNumber: 1,
                      isCompleted: true,
                      isActive: false,
                      title: 'Share PIN',
                      description:
                      'Share this PIN with the technician to verify their arrival.',
                      child: _PinBox(pin: pin),
                    ),
                    const SizedBox(height: 24),
                    _buildStepItem(
                      stepNumber: 2,
                      isCompleted: false,
                      isActive: true,
                      title: 'Estimated Job Cost',
                      description: 'Accept the estimated job cost to proceed',
                      child: _CostSection(
                        cost: estimated,
                        onAccept: () => _onDecision('Approved', estimated),
                        onReject: () => _onDecision('Rejected', estimated),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
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
      ),
    );
  }
}

class _CostSection extends StatelessWidget {
  final int cost;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const _CostSection({
    required this.cost,
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rs. $cost',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: onAccept,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'ACCEPT',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: onReject,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'REJECT',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
