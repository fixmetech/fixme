import 'package:flutter/material.dart';
import 'package:fixme/models/job_request.dart';
import 'package:intl/intl.dart';

class ActivityCard extends StatelessWidget {
  final JobRequest jobRequest;
  final VoidCallback? onCancel;
  final VoidCallback? onView;
  final VoidCallback? onTrack;
  final VoidCallback? onCall;

  const ActivityCard({
    super.key,
    required this.jobRequest,
    this.onCancel,
    this.onView,
    this.onTrack,
    this.onCall,
  });

  String _getFormattedTime() {
    try {
      final now = DateTime.now();
      final diff = now.difference(jobRequest.createdAt);
      
      if (diff.inMinutes < 60) {
        return '${diff.inMinutes}m ago';
      } else if (diff.inHours < 24) {
        return '${diff.inHours}h ago';
      } else if (diff.inDays < 7) {
        return '${diff.inDays}d ago';
      } else {
        return DateFormat('MMM dd, yyyy').format(jobRequest.createdAt);
      }
    } catch (e) {
      return DateFormat('MMM dd, yyyy').format(jobRequest.createdAt);
    }
  }

  String _getPropertyTitle() {
    if (jobRequest.propertyInfo.type == 'vehicle') {
      final details = jobRequest.propertyInfo.details;
      return '${details['brand'] ?? ''} ${details['model'] ?? ''}'.trim();
    } else {
      return jobRequest.propertyInfo.details['propertyType'] ?? 'Property';
    }
  }

  String _getPropertySubtitle() {
    if (jobRequest.propertyInfo.type == 'vehicle') {
      final details = jobRequest.propertyInfo.details;
      return '${details['year'] ?? ''} • ${details['registrationNumber'] ?? ''}'.trim();
    } else {
      return jobRequest.propertyInfo.details['address'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final serviceCategory = jobRequest.serviceCategory;
    final issues = jobRequest.selectedIssues;
    final status = jobRequest.status;
    final propertyTitle = _getPropertyTitle();
    final propertySubtitle = _getPropertySubtitle();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Service Icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getServiceColor(serviceCategory).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getServiceIcon(serviceCategory),
                        color: _getServiceColor(serviceCategory),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Title and Status
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            propertyTitle.isEmpty ? serviceCategory.toUpperCase() : propertyTitle,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(status).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  status.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: _getStatusColor(status),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _getFormattedTime(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                // Property Subtitle
                if (propertySubtitle.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        jobRequest.propertyInfo.type == 'vehicle' 
                          ? Icons.directions_car 
                          : Icons.home,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          propertySubtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                
                const SizedBox(height: 12),
                
                // Selected Issues
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.build_circle_outlined,
                            size: 16,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Issues Reported',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: issues.map((issue) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Text(
                              issue,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[800],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                
                
                
                // Location
                if (jobRequest.customerLocation != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Lat: ${jobRequest.customerLocation!.latitude.toStringAsFixed(4)}, '
                          'Lng: ${jobRequest.customerLocation!.longitude.toStringAsFixed(4)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                
                // Technician Info (if assigned)
                if (jobRequest.technicianId != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.green[100],
                          child: Icon(
                            Icons.person,
                            size: 18,
                            color: Colors.green[700],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Technician Assigned',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'ID: ${jobRequest.technicianId}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Action Buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[25],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onView,
                    icon: const Icon(Icons.visibility_outlined, size: 16),
                    label: const Text('View Details'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      side: BorderSide(color: Colors.grey[300]!),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Track Button
                if (jobRequest.customerLocation != null)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: onTrack,
                      icon: Icon(
                        Icons.location_on,
                        color: Colors.blue[600],
                        size: 20,
                      ),
                      tooltip: 'Track',
                    ),
                  ),
                
                if (jobRequest.customerLocation != null)
                  const SizedBox(width: 8),
                
                // Call Button (if technician assigned)
                if (jobRequest.technicianId != null)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: onCall,
                      icon: Icon(
                        Icons.phone,
                        color: Colors.green[600],
                        size: 20,
                      ),
                      tooltip: 'Call',
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    final statusLower = status.toLowerCase();
    switch (statusLower) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getServiceIcon(String serviceCategory) {
    final category = serviceCategory.toLowerCase();
    switch (category) {
      case 'vehicles':
        return Icons.car_repair;
      case 'home':
        return Icons.home_repair_service;
      case 'paint':
        return Icons.format_paint;
      case 'electrical':
        return Icons.electrical_services;
      case 'plumbing':
        return Icons.plumbing;
      default:
        return Icons.handyman;
    }
  }

  Color _getServiceColor(String serviceCategory) {
    final category = serviceCategory.toLowerCase();
    switch (category) {
      case 'vehicles':
        return Colors.blue;
      case 'home':
        return Colors.green;
      case 'paint':
        return Colors.purple;
      case 'electrical':
        return Colors.orange;
      case 'plumbing':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}
