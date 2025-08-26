import 'package:fixme/models/vehicle_profile.dart';
import 'package:fixme/models/home_profile.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class JobRequest {
  final String? jobId;
  final String status;
  final LatLng? customerLocation;
  final String customerId;
  final String? techId;
  final PropertyInfo propertyInfo;
  final List<String> selectedIssues;
  final String? description;
  final DateTime createdAt;
  final DateTime? updatedAt;

  JobRequest({
    this.jobId,
    required this.status,
    this.customerLocation,
    required this.customerId,
    this.techId,
    required this.propertyInfo,
    required this.selectedIssues,
    this.description,
    required this.createdAt,
    this.updatedAt,
  });

  // Convert from Map (API/Firestore data) to JobRequest object
  factory JobRequest.fromMap(Map<String, dynamic> map) {
    return JobRequest(
      jobId: map['jobId'],
      status: map['status'] ?? 'pending',
      customerLocation: map['customerLocation'] != null
          ? LatLng(
              map['customerLocation']['latitude']?.toDouble() ?? 0.0,
              map['customerLocation']['longitude']?.toDouble() ?? 0.0,
            )
          : null,
      customerId: map['customerId'] ?? '',
      techId: map['techId'],
      propertyInfo: PropertyInfo.fromMap(map['propertyInfo'] ?? {}),
      selectedIssues: List<String>.from(map['selectedIssues'] ?? []),
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  // Convert JobRequest object to Map (for API/Firestore)
  Map<String, dynamic> toMap() {
    return {
      'jobId': jobId,
      'status': status,
      'customerLocation': customerLocation != null
          ? {
              'latitude': customerLocation!.latitude,
              'longitude': customerLocation!.longitude,
            }
          : null,
      'customerId': customerId,
      'techId': techId,
      'propertyInfo': propertyInfo.toMap(),
      'selectedIssues': selectedIssues,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Create a copy with updated values
  JobRequest copyWith({
    String? jobId,
    String? status,
    LatLng? customerLocation,
    String? customerId,
    String? techId,
    PropertyInfo? propertyInfo,
    List<String>? selectedIssues,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JobRequest(
      jobId: jobId ?? this.jobId,
      status: status ?? this.status,
      customerLocation: customerLocation ?? this.customerLocation,
      customerId: customerId ?? this.customerId,
      techId: techId ?? this.techId,
      propertyInfo: propertyInfo ?? this.propertyInfo,
      selectedIssues: selectedIssues ?? this.selectedIssues,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class PropertyInfo {
  final String type; // 'vehicle' or 'home'
  final String propertyId;
  final Map<String, dynamic> details;

  PropertyInfo({
    required this.type,
    required this.propertyId,
    required this.details,
  });

  // Create PropertyInfo from VehicleProfile
  factory PropertyInfo.fromVehicle(VehicleProfile vehicle) {
    return PropertyInfo(
      type: 'vehicle',
      propertyId: vehicle.id,
      details: vehicle.toMap(),
    );
  }

  // Create PropertyInfo from HomeProfile
  factory PropertyInfo.fromHome(HomeProfile home) {
    return PropertyInfo(
      type: 'home',
      propertyId: home.id ?? '',
      details: home.toMap(),
    );
  }

  // Convert from Map
  factory PropertyInfo.fromMap(Map<String, dynamic> map) {
    return PropertyInfo(
      type: map['type'] ?? '',
      propertyId: map['propertyId'] ?? '',
      details: Map<String, dynamic>.from(map['details'] ?? {}),
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'propertyId': propertyId,
      'details': details,
    };
  }

  // Get VehicleProfile if type is vehicle
  VehicleProfile? get vehicleProfile {
    if (type == 'vehicle') {
      return VehicleProfile.fromMap(details);
    }
    return null;
  }

  // Get HomeProfile if type is home
  HomeProfile? get homeProfile {
    if (type == 'home') {
      return HomeProfile.fromMap(details);
    }
    return null;
  }
}
