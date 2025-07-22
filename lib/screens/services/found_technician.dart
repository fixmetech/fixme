import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:fixme/utils/constants/size.dart';

enum TechnicianStatus { gettingReady, onTheWay, arrived }

class FoundTechnician extends StatefulWidget {
  final Map<String, dynamic> technician;
  final VoidCallback onFindAnother;
  final VoidCallback onCall;

  const FoundTechnician({
    super.key,
    required this.technician,
    required this.onFindAnother,
    required this.onCall,
  });

  @override
  State<FoundTechnician> createState() => _FoundTechnicianState();
}

class _FoundTechnicianState extends State<FoundTechnician>
    with SingleTickerProviderStateMixin {
  TechnicianStatus _currentStatus = TechnicianStatus.gettingReady;
  Timer? _statusTimer;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _startStatusFlow();
  }

  void _startStatusFlow() {
    // Start with getting ready, then transition every 6 seconds
    _statusTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (mounted) {
        setState(() {
          switch (_currentStatus) {
            case TechnicianStatus.gettingReady:
              _currentStatus = TechnicianStatus.onTheWay;
              break;
            case TechnicianStatus.onTheWay:
              _currentStatus = TechnicianStatus.arrived;
              timer.cancel(); // Stop the timer when arrived
              break;
            case TechnicianStatus.arrived:
              // Already arrived, do nothing
              break;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _makePhoneCall(String phoneNumber, BuildContext context) async {
    try {
      final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
      debugPrint('Attempting to launch: $phoneUri');

      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
        debugPrint('Phone call launched successfully');
      } else {
        debugPrint('Cannot launch phone call - no app available');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No phone app available to make calls'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error making phone call: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error making phone call: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildStatusChip() {
    String text;
    Color backgroundColor;
    Color textColor;
    Color borderColor;
    IconData icon;
    bool shouldAnimate = false;

    switch (_currentStatus) {
      case TechnicianStatus.gettingReady:
        text = "Getting Ready";
        backgroundColor = Colors.amber[50]!;
        textColor = Colors.amber[700]!;
        borderColor = Colors.amber[200]!;
        icon = Icons.schedule;
        shouldAnimate = true;
        break;
      case TechnicianStatus.onTheWay:
        text = "Arrive in 10min";
        backgroundColor = Colors.blue[50]!;
        textColor = Colors.blue[700]!;
        borderColor = Colors.blue[200]!;
        icon = Icons.directions_car;

        break;
      case TechnicianStatus.arrived:
        text = "Arrived";
        backgroundColor = Colors.green[50]!;
        textColor = Colors.green[700]!;
        borderColor = Colors.green[200]!;
        icon = Icons.check_circle;
        shouldAnimate = false;
        break;
    }

    if (shouldAnimate) {
      _animationController.repeat(reverse: true);
    } else {
      _animationController.stop();
      _animationController.reset();
    }

    Widget chipContent = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    if (shouldAnimate) {
      return AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale:
                1.0 + (_pulseAnimation.value - 1.0) * 0.3, // Reduce scale range
            child: chipContent,
          );
        },
      );
    }

    return chipContent;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Success header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green[600], size: 20),
                const SizedBox(width: 8),
                Text(
                  "Technician Found!",
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: FixMeSizes.defaultSpace),

          // Technician card
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue[100],
                      child: Text(
                        widget.technician['name']
                            .split(' ')
                            .map((n) => n[0])
                            .join(),
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.technician['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber[600],
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${widget.technician['rating']} • ${widget.technician['completedJobs']} jobs",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.technician['specialization'],
                            style: TextStyle(
                              color: Colors.blue[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Circular phone button positioned at top-left corner
              Positioned(
                top: 8,
                left: 8,
                child: GestureDetector(
                  onTap: () =>
                      _makePhoneCall(widget.technician['phone'], context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.green[500],
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.phone,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: FixMeSizes.defaultSpace),

          // Distance and status chips outside the card
          Row(
            children: [
              Expanded(
                child: _buildInfoChip(
                  Icons.location_on,
                  widget.technician['distance'],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: _buildStatusChip()),
            ],
          ),

          const SizedBox(height: FixMeSizes.defaultSpace),

          // Visiting fee text
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.monetization_on, color: Colors.orange[600], size: 20),
                const SizedBox(width: 8),
                Text(
                  "Visiting fee: Rs.200",
                  style: TextStyle(
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w600,
                    fontSize: FixMeSizes.md,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: FixMeSizes.defaultSpace),

          // Cancel button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // Show confirmation dialog before canceling
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Cancel Booking"),
                      content: const Text(
                        "Are you sure you want to cancel this booking?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("No"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            // Handle cancel action here
                            widget
                                .onFindAnother(); // or create a separate onCancel callback
                          },
                          child: const Text("Yes, Cancel"),
                        ),
                      ],
                    );
                  },
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red[600],
                side: BorderSide(color: Colors.red[600]!),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Cancel Booking",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.blue[600]),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue[700],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
