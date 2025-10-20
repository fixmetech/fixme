import 'package:fixme/features/my_booking/widgets/activity_card.dart';
import 'package:fixme/features/ongoing_request/controller/ongoing_state_controller.dart';
import 'package:fixme/features/ongoing_request/screens/estimated_job_cost.dart';
import 'package:fixme/features/ongoing_request/screens/finish_job.dart';
import 'package:fixme/features/ongoing_request/screens/ongoing_state.dart';
import 'package:fixme/models/job_request.dart';
import 'package:fixme/screens/services/find_help.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';

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
              switch (jobRequest.status.toLowerCase()) {
                case 'technicianconfirmed':
                  Get.to(() => ServiceRequestScreen(jobRequestId: jobRequest.jobId ?? ''));
                  break;
                case 'estimateapproved':  
                  Get.to(() => OngoingScreen(jobId: jobRequest.jobId ?? ''));
                  break;
                case 'technicianfinished':
                  Get.to(() => FinishJobScreen(jobId: jobRequest.jobId ?? ''));
                  break;
                default:
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Viewing job ${jobRequest.jobId}')),
                  );
              }
            },
            onTrack: () {
              // Navigate to FindHelp page with the job request
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FindHelp(
                    jobRequest: jobRequest,
                    initialState: _getInitialStateForStatus(jobRequest.status),
                  ),
                ),
              );
            },
            onCall: () {
              // Handle call - call technician
              if (jobRequest.technicianId != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Calling technician ${jobRequest.technicianPhone}',
                    ),
                  ),
                );
              }
            },
            onCancel: () {
              // Handle cancel
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Job cancelled')));
            },
          ),
        );
      },
    );
  }

  SearchState _getInitialStateForStatus(String status) {
    final statusLower = status.toLowerCase();
    if (statusLower == 'searchingtechnician') {
      return SearchState.searching;
    } else if ([
      'confirmed',
      'technicianarrived',
      'techniciangettingready',
      'technicianontheway',
    ].contains(statusLower)) {
      return SearchState.found;
    }
    return SearchState.initial;
  }
}
