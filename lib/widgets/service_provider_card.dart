import 'package:flutter/material.dart';

class ServiceProviderCard extends StatelessWidget {
  final String name;
  final double rating;
  final String serviceType;
  final String distance;

  const ServiceProviderCard({
    super.key,
    required this.name,
    required this.rating,
    required this.serviceType,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    Text(rating.toString()),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(serviceType),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16),
                const SizedBox(width: 4),
                Text(distance),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    // View details
                  },
                  child: const Text('Details'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Book service
                  },
                  child: const Text('Book Now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
