class ComplaintModel {
  String? id;
  CustomerInfo? customer;
  TechnicianInfo? technician;
  ServiceInfo? service;
  ComplaintDetails? complaint;
  ResolutionInfo? resolution;
  String? createdAt;
  String? updatedAt;

  ComplaintModel({
    this.id,
    this.customer,
    this.technician,
    this.service,
    this.complaint,
    this.resolution,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'customer': customer?.toJson(),
      'technician': technician?.toJson(),
      'service': service?.toJson(),
      'complaint': complaint?.toJson(),
      'resolution': resolution?.toJson(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory ComplaintModel.fromJson(Map<String, dynamic> json, String id) {
    return ComplaintModel(
      id: id,
      customer: json['customer'] != null ? CustomerInfo.fromJson(json['customer']) : null,
      technician: json['technician'] != null ? TechnicianInfo.fromJson(json['technician']) : null,
      service: json['service'] != null ? ServiceInfo.fromJson(json['service']) : null,
      complaint: json['complaint'] != null ? ComplaintDetails.fromJson(json['complaint']) : null,
      resolution: json['resolution'] != null ? ResolutionInfo.fromJson(json['resolution']) : null,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class CustomerInfo {
  String? name;
  String? email;
  String? phone;
  String? avatar;
  String? userId;

  CustomerInfo({
    this.name,
    this.email,
    this.phone,
    this.avatar,
    this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'userId': userId,
    };
  }

  factory CustomerInfo.fromJson(Map<String, dynamic> json) {
    return CustomerInfo(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      avatar: json['avatar'],
      userId: json['userId'],
    );
  }
}

class TechnicianInfo {
  String? name;
  String? email;
  String? phone;
  String? profession;
  String? badge;
  double? rating;
  String? userId;

  TechnicianInfo({
    this.name,
    this.email,
    this.phone,
    this.profession,
    this.badge,
    this.rating,
    this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'profession': profession,
      'badge': badge,
      'rating': rating,
      'userId': userId,
    };
  }

  factory TechnicianInfo.fromJson(Map<String, dynamic> json) {
    return TechnicianInfo(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      profession: json['profession'],
      badge: json['badge'],
      rating: json['rating']?.toDouble(),
      userId: json['userId'],
    );
  }
}

class ServiceInfo {
  String? name;
  String? date;
  String? time;
  double? price;
  String? serviceId;

  ServiceInfo({
    this.name,
    this.date,
    this.time,
    this.price,
    this.serviceId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date': date,
      'time': time,
      'price': price,
      'serviceId': serviceId,
    };
  }

  factory ServiceInfo.fromJson(Map<String, dynamic> json) {
    return ServiceInfo(
      name: json['name'],
      date: json['date'],
      time: json['time'],
      price: json['price']?.toDouble(),
      serviceId: json['serviceId'],
    );
  }
}

class ComplaintDetails {
  String? title;
  String? description;
  String? category;
  String? severity;
  String? submittedAt;
  List<EvidenceFile>? evidence;
  String? status;

  ComplaintDetails({
    this.title,
    this.description,
    this.category,
    this.severity,
    this.submittedAt,
    this.evidence,
    this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'severity': severity,
      'submittedAt': submittedAt,
      'evidence': evidence?.map((e) => e.toJson()).toList(),
      'status': status,
    };
  }

  factory ComplaintDetails.fromJson(Map<String, dynamic> json) {
    return ComplaintDetails(
      title: json['title'],
      description: json['description'],
      category: json['category'],
      severity: json['severity'],
      submittedAt: json['submittedAt'],
      evidence: json['evidence'] != null
          ? (json['evidence'] as List).map((e) => EvidenceFile.fromJson(e)).toList()
          : [],
      status: json['status'],
    );
  }
}

class EvidenceFile {
  String? fileName;
  String? url;
  String? uploadedAt;
  String? localPath; // For files before upload

  EvidenceFile({
    this.fileName,
    this.url,
    this.uploadedAt,
    this.localPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'url': url,
      'uploadedAt': uploadedAt,
    };
  }

  factory EvidenceFile.fromJson(Map<String, dynamic> json) {
    return EvidenceFile(
      fileName: json['fileName'],
      url: json['url'],
      uploadedAt: json['uploadedAt'],
    );
  }
}

class ResolutionInfo {
  String? action;
  double? refundAmount;
  String? notes;
  String? technicianAction;
  String? resolvedAt;
  String? resolvedBy;

  ResolutionInfo({
    this.action,
    this.refundAmount,
    this.notes,
    this.technicianAction,
    this.resolvedAt,
    this.resolvedBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'refundAmount': refundAmount,
      'notes': notes,
      'technicianAction': technicianAction,
      'resolvedAt': resolvedAt,
      'resolvedBy': resolvedBy,
    };
  }

  factory ResolutionInfo.fromJson(Map<String, dynamic> json) {
    return ResolutionInfo(
      action: json['action'],
      refundAmount: json['refundAmount']?.toDouble(),
      notes: json['notes'],
      technicianAction: json['technicianAction'],
      resolvedAt: json['resolvedAt'],
      resolvedBy: json['resolvedBy'],
    );
  }
}

// Enums for better type safety
enum ComplaintCategory {
  serviceQuality('service_quality', 'Service Quality'),
  behavior('behavior', 'Mechanic Behavior'),
  billing('billing', 'Billing Issue'),
  timeliness('timeliness', 'Timeliness'),
  vehicleDamage('vehicle_damage', 'Vehicle Damage'),
  partsQuality('parts_quality', 'Parts Quality'),
  other('other', 'Other');

  const ComplaintCategory(this.value, this.displayName);

  final String value;
  final String displayName;

  static ComplaintCategory fromString(String value) {
    return ComplaintCategory.values.firstWhere(
      (category) => category.value == value,
      orElse: () => ComplaintCategory.other,
    );
  }
}

enum ComplaintSeverity {
  low('low', 'Low'),
  medium('medium', 'Medium'),
  high('high', 'High'),
  urgent('urgent', 'Urgent');

  const ComplaintSeverity(this.value, this.displayName);

  final String value;
  final String displayName;

  static ComplaintSeverity fromString(String value) {
    return ComplaintSeverity.values.firstWhere(
      (severity) => severity.value == value,
      orElse: () => ComplaintSeverity.medium,
    );
  }
}

enum ComplaintStatus {
  pending('pending', 'Pending'),
  investigating('investigating', 'Investigating'),
  resolved('resolved', 'Resolved'),
  rejected('rejected', 'Rejected');

  const ComplaintStatus(this.value, this.displayName);

  final String value;
  final String displayName;

  static ComplaintStatus fromString(String value) {
    return ComplaintStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => ComplaintStatus.pending,
    );
  }
}
