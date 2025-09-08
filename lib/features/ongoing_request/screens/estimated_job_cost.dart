import 'package:fixme/features/ongoing_request/ongoing_state.dart';
import 'package:flutter/material.dart';

// NEW: controller import
import 'package:fixme/features/ongoing_request/controller/estimated_job_cost_controller.dart';

class ServiceRequestScreen extends StatefulWidget {
  /// Firestore document id for the job request
  final String jobId;

  /// UI-only display number (#16). If you pass a real display id, it shows in the title.
  final int requestId;

  const ServiceRequestScreen({
    Key? key,
    this.jobId = '0giWzXu3hWWmCFKvFIdb', // default for quick testing
    this.requestId = 16,
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
    _future = _api.fetchJob(widget.jobId);
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _api.fetchJob(widget.jobId);
    });
  }

  Future<void> _onDecision(String decision, int shownCost) async {
    try {
      await _api.approveOrReject(jobId: widget.jobId, decision: decision);
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
        // Navigate forward in your flow
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OngoingScreen()),
        );
      } else {
        // On reject, you might stay here or pop—current behavior shows a snackbar only.
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
            final pin = job.pin.toString(); // dynamic PIN
            final estimated = (job.estimatedCost ?? 0).toInt(); // dynamic estimate (defaults to 0 if null)

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    // Step 1: Share PIN (unchanged UI)
                    _buildStepItem(
                      stepNumber: 1,
                      isCompleted: true,
                      isActive: false,
                      title: 'Share PIN',
                      description: 'Share this PIN with the technician to verify their arrival.',
                      child: _PinBox(pin: pin),
                    ),
                    const SizedBox(height: 24),

                    // Step 2: Estimated Job Cost (unchanged UI)
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
                onPressed: onAccept ??
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OngoingScreen()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Job cost accepted!')),
                      );
                    },
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
                onPressed: onReject ??
                        () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Job cost rejected!')),
                      );
                    },
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
