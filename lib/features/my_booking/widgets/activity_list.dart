import 'package:fixme/features/my_booking/widgets/activity_card.dart';
import 'package:fixme/models/job_request.dart';
import 'package:flutter/material.dart';

class ActivityList extends StatelessWidget {
  final String type;
  final List<JobRequest>? activities;

  const ActivityList({super.key, required this.type, this.activities});

  @override
  Widget build(BuildContext context) {
    final List<JobRequest> items = activities ?? [];

    return ListView.builder(
      key: PageStorageKey(type),
      padding: const EdgeInsets.all(12),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final jobRequest = items[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: ActivityCard(
            
            jobRequest: jobRequest,
            onView: () {
              // Handle view - navigate to job details
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Viewing job ${jobRequest.jobId}')),
              );
            },
            onTrack: () {
              // Handle track - open map with location
              if (jobRequest.customerLocation != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening map...')),
                );
              }
            },
            onCall: () {
              // Handle call - call technician
              if (jobRequest.technicianId != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Calling technician ${jobRequest.technicianId}'),
                  ),
                );
              }
            },
            onCancel: () {
              // Handle cancel
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Job cancelled')),
              );
            },
          ),
        );
      },
    );
  }
}
