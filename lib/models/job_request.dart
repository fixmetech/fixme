import 'dart:ffi';

import 'package:fixme/models/vehicle_profile.dart';
import 'package:fixme/models/home_profile.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class JobRequest {
  final String? jobId;
  final String status;
  final LatLng? customerLocation;
  final String? customerAddress;
  final String customerId;
  final String? technicianId;
  final String? technicianName;
  final String? technicianPhone;
  final String serviceCategory;
  final PropertyInfo propertyInfo;
  final List<String> selectedIssues;
  final String? description;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? estimateStatus;
  final int? estimatedCost;

  JobRequest({
    this.jobId,
    required this.status,
    this.customerLocation,
    this.customerAddress,
    required this.customerId,
    this.technicianId,
    this.technicianName,
    this.technicianPhone,
    required this.serviceCategory,
    required this.propertyInfo,
    required this.selectedIssues,
    this.description,
    required this.createdAt,
    this.updatedAt,
    this.estimateStatus,
    this.estimatedCost,
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
      customerAddress: map['customerAddress'],
      customerId: map['customerId'] ?? '',
      technicianId: map['technicianId'],
      technicianName: map['technicianName'],
      technicianPhone: map['technicianPhone'],
      serviceCategory: map['serviceCategory'] ?? '',
      propertyInfo: PropertyInfo.fromMap(map['propertyInfo'] ?? {}),
      selectedIssues: List<String>.from(map['selectedIssues'] ?? []),
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      estimateStatus: map['estimateStatus'],
      estimatedCost: map['estimatedCost']?.toInt(),
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
      'customerAddress': customerAddress,
      'customerId': customerId,
      'technicianId': technicianId,
      'serviceCategory': serviceCategory,
      'propertyInfo': propertyInfo.toMap(),
      'selectedIssues': selectedIssues,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'estimateStatus': estimateStatus,
      'estimatedCost': estimatedCost,
    };
  }

  // Create a copy with updated values
  JobRequest copyWith({
    String? jobId,
    String? status,
    LatLng? customerLocation,
    String? customerAddress,
    String? customerId,
    String? technicianId,
    String? technicianName,
    String? technicianPhone,
    String? serviceCategory,
    PropertyInfo? propertyInfo,
    List<String>? selectedIssues,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? estimateStatus,
    int? estimatedCost,
  }) {
    return JobRequest(
      jobId: jobId ?? this.jobId,
      status: status ?? this.status,
      customerLocation: customerLocation ?? this.customerLocation,
      customerAddress: customerAddress ?? this.customerAddress,
      customerId: customerId ?? this.customerId,
      technicianId: technicianId ?? this.technicianId,
      technicianName: technicianName ?? this.technicianName,
      technicianPhone: technicianPhone ?? this.technicianPhone,
      serviceCategory: serviceCategory ?? this.serviceCategory,
      propertyInfo: propertyInfo ?? this.propertyInfo,
      selectedIssues: selectedIssues ?? this.selectedIssues,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      estimateStatus: estimateStatus ?? this.estimateStatus,
      estimatedCost: estimatedCost ?? this.estimatedCost,
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
