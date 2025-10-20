import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final VoidCallback? onView;
  final VoidCallback? onCancel;
  final VoidCallback? onReschedule;

  const BookingCard({
    super.key,
    required this.booking,
    this.onView,
    this.onCancel,
    this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    final status = booking['status']?.toString().toLowerCase() ?? 'unknown';
    final paymentStatus = booking['paymentDetails']?['status']?.toString().toLowerCase() ?? 'unpaid';
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onView,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with service category and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking['serviceCategory'] ?? 'Service',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        if (booking['serviceSpecialization'] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              booking['serviceSpecialization'],
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusChip(status),
                ],
              ),

              const Divider(height: 24),

              // Scheduled date and time
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.blue[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Scheduled',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _getScheduledDateTime(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Technician details (if assigned)
              if (booking['technicianDetails'] != null) ...[
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Colors.blue[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Technician',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            booking['technicianDetails']['name'] ?? 'Not assigned',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],

              // Price estimate and payment status
              Row(
                children: [
                  Icon(Icons.payments_outlined, size: 16, color: Colors.blue[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Estimated Price',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Rs ${booking['priceEstimate'] ?? 0}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        _buildPaymentStatusChip(paymentStatus),
                      ],
                    ),
                  ),
                ],
              ),

              // Description (if available)
              if (booking['description'] != null && booking['description'].toString().isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  booking['description'],
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              // Action buttons
              if (status == 'pending' || status == 'confirmed') ...[
                const Divider(height: 24),
                Row(
                  children: [
                    if (onReschedule != null)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onReschedule,
                          icon: const Icon(Icons.schedule, size: 18),
                          label: const Text('Reschedule'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    if (onReschedule != null && onCancel != null)
                      const SizedBox(width: 12),
                    if (onCancel != null)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onCancel,
                          icon: const Icon(Icons.cancel_outlined, size: 18),
                          label: const Text('Cancel'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red[700],
                            side: BorderSide(color: Colors.red[300]!),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                  ],
                ),
              ],

              // Booked at timestamp
              const SizedBox(height: 8),
              Text(
                'Booked ${_getFormattedBookingTime()}',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getScheduledDateTime() {
    try {
      final scheduledDate = booking['scheduledDate'];
      final scheduledTime = booking['scheduledTime'];

      if (scheduledDate == null) return 'Not scheduled';

      DateTime dateTime;
      if (scheduledDate is DateTime) {
        dateTime = scheduledDate;
      } else {
        dateTime = (scheduledDate as dynamic).toDate();
      }

      final dateStr = DateFormat('MMM dd, yyyy').format(dateTime);
      final timeStr = scheduledTime ?? 'Time TBD';

      return '$dateStr at $timeStr';
    } catch (e) {
      return 'Not scheduled';
    }
  }

  String _getFormattedBookingTime() {
    try {
      final bookingDate = booking['bookingDate'] ?? booking['createdAt'];
      if (bookingDate == null) return '';

      DateTime dateTime;
      if (bookingDate is DateTime) {
        dateTime = bookingDate;
      } else {
        dateTime = (bookingDate as dynamic).toDate();
      }

      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return 'on ${DateFormat('MMM dd').format(dateTime)}';
      }
    } catch (e) {
      return '';
    }
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    String displayText;

    switch (status) {
      case 'confirmed':
        backgroundColor = Colors.green[50]!;
        textColor = Colors.green[700]!;
        displayText = 'Confirmed';
        break;
      case 'pending':
        backgroundColor = Colors.orange[50]!;
        textColor = Colors.orange[700]!;
        displayText = 'Pending';
        break;
      case 'cancelled':
      case 'canceled':
        backgroundColor = Colors.red[50]!;
        textColor = Colors.red[700]!;
        displayText = 'Cancelled';
        break;
      case 'completed':
        backgroundColor = Colors.blue[50]!;
        textColor = Colors.blue[700]!;
        displayText = 'Completed';
        break;
      default:
        backgroundColor = Colors.grey[100]!;
        textColor = Colors.grey[700]!;
        displayText = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPaymentStatusChip(String paymentStatus) {
    Color backgroundColor;
    Color textColor;
    String displayText;

    switch (paymentStatus) {
      case 'paid':
        backgroundColor = Colors.green[50]!;
        textColor = Colors.green[700]!;
        displayText = 'Paid';
        break;
      case 'unpaid':
        backgroundColor = Colors.orange[50]!;
        textColor = Colors.orange[700]!;
        displayText = 'Unpaid';
        break;
      case 'pending':
        backgroundColor = Colors.amber[50]!;
        textColor = Colors.amber[800]!;
        displayText = 'Payment Pending';
        break;
      case 'failed':
        backgroundColor = Colors.red[50]!;
        textColor = Colors.red[700]!;
        displayText = 'Payment Failed';
        break;
      default:
        backgroundColor = Colors.grey[100]!;
        textColor = Colors.grey[700]!;
        displayText = paymentStatus;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textColor.withOpacity(0.3), width: 1),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
