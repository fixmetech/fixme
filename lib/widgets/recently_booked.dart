import 'package:fixme/widgets/recent_booking_card.dart';
import 'package:flutter/material.dart';

class RecentlyBooked extends StatelessWidget {
  const RecentlyBooked({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Arrow
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Recently Booked',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.arrow_forward_ios),
            ],
          ),
          const SizedBox(height: 8),
          Container(height: 2, width: 120, color: Colors.pinkAccent),
          const SizedBox(height: 12),

          // Scrollable cards
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                BookingCard(
                  title: 'Car Repair',
                  name: 'Aloka Bandara',
                  date: '12/03/2024',
                  imageUrl: 'https://wallpapers.com/images/hd/default-user-profile-icon-c8ljd88k8vow846e.png',
                  rating: 4,
                ),
                SizedBox(width: 12),
                BookingCard(
                  title: 'House Cleaning',
                  name: 'Januda',
                  date: '19/03/2024',
                  imageUrl: 'https://wallpapers.com/images/hd/default-user-profile-icon-c8ljd88k8vow846e.png',
                  rating: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
