class VehicleProfile {
  final String id;
  final String plateNumber;
  final String make;
  final String model;
  final String year;
  final String color;
  final String vehicleType;
  bool isDefault;
  final String fuelType;
  final String transmission;
  final String engineCapacity;
  final String mileage;
  final String? imageUrl;
  final Map<String, dynamic>? owner;

  VehicleProfile({
    required this.id,
    required this.plateNumber,
    required this.make,
    required this.model,
    required this.year,
    required this.color,
    required this.vehicleType,
    required this.isDefault,
    required this.fuelType,
    required this.transmission,
    required this.engineCapacity,
    required this.mileage,
    this.imageUrl,
    this.owner,
  });

  // Convert from Map (API/Firestore data) to VehicleProfile object
  factory VehicleProfile.fromMap(Map<String, dynamic> map) {
    return VehicleProfile(
      id: map['id'] ?? '',
      plateNumber: map['plateNumber'] ?? '',
      make: map['make'] ?? '',
      model: map['model'] ?? '',
      year: map['year'] ?? '',
      color: map['color'] ?? '',
      vehicleType: map['vehicleType'] ?? '',
      isDefault: map['isDefault'] ?? false,
      fuelType: map['fuelType'] ?? '',
      transmission: map['transmission'] ?? '',
      engineCapacity: map['engineCapacity'] ?? '',
      mileage: map['mileage'] ?? '',
      imageUrl: map['imageUrl'],
      owner: map['owner'],
    );
  }

  // Convert VehicleProfile object to Map (for API/Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plateNumber': plateNumber,
      'make': make,
      'model': model,
      'year': year,
      'color': color,
      'vehicleType': vehicleType,
      'isDefault': isDefault,
      'fuelType': fuelType,
      'transmission': transmission,
      'engineCapacity': engineCapacity,
      'mileage': mileage,
      'imageUrl': imageUrl,
      'owner': owner,
    };
  }

  // Create a copy with updated values
  VehicleProfile copyWith({
    String? id,
    String? plateNumber,
    String? make,
    String? model,
    String? year,
    String? color,
    String? vehicleType,
    bool? isDefault,
    String? fuelType,
    String? transmission,
    String? engineCapacity,
    String? mileage,
    String? imageUrl,
    Map<String, dynamic>? owner,
  }) {
    return VehicleProfile(
      id: id ?? this.id,
      plateNumber: plateNumber ?? this.plateNumber,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      color: color ?? this.color,
      vehicleType: vehicleType ?? this.vehicleType,
      isDefault: isDefault ?? this.isDefault,
      fuelType: fuelType ?? this.fuelType,
      transmission: transmission ?? this.transmission,
      engineCapacity: engineCapacity ?? this.engineCapacity,
      mileage: mileage ?? this.mileage,
      imageUrl: imageUrl ?? this.imageUrl,
      owner: owner ?? this.owner,
    );
  }
}
