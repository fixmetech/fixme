import 'package:fixme/features/my_booking/widgets/booking_card.dart';
import 'package:flutter/material.dart';

class BookingList extends StatelessWidget {
  final String type;
  final List<Map<String, dynamic>>? bookings;

  const BookingList({super.key, required this.type, this.bookings});

  @override
  Widget build(BuildContext context) {
    final items = bookings ?? [];

    return ListView.builder(
      key: PageStorageKey(type),
      padding: const EdgeInsets.all(12),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final booking = items[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: BookingCard(
            booking: booking,
            onView: () {
              // Handle view - navigate to booking details
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening booking details...')),
              );
            },
            onReschedule: () {
              // Handle reschedule
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reschedule booking...')),
              );
            },
            onCancel: () {
              // Handle cancel - show confirmation dialog
              _showCancelDialog(context, booking);
            },
          ),
        );
      },
    );
  }

  void _showCancelDialog(BuildContext context, Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text(
          'Are you sure you want to cancel this booking? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement actual cancel booking logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booking cancelled')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}
