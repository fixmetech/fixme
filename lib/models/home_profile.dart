class HomeProfile {
  final String id;
  final String name;
  final String address;
  final String city;
  final String postalCode;
  final String homeType;
  final String imageUrl;
  bool isDefault;
  final String area;
  final String phone;
  final String? landmark;
  final Map<String, dynamic>? map;
  final Map<String, dynamic>? owner;

  HomeProfile({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.homeType,
    required this.imageUrl,
    required this.isDefault,
    required this.area,
    required this.phone,
    this.landmark,
    this.map,
    this.owner,
  });

  factory HomeProfile.fromMap(Map<String, dynamic> map) {
    return HomeProfile(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      postalCode: map['postalCode'] ?? '',
      homeType: map['homeType'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      isDefault: map['isDefault'] ?? false,
      area: map['area'] ?? '',
      phone: map['phone'] ?? '',
      landmark: map['landmark'],
      map: map['map'],
      owner: map['owner'],
    );
  }

  // Convert HomeProfile object to Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'postalCode': postalCode,
      'homeType': homeType,
      'imageUrl': imageUrl,
      'isDefault': isDefault,
      'area': area,
      'phone': phone,
      'landmark': landmark,
      'map': map,
      'owner': owner,
    };
  }

  // Create a copy with updated values
  HomeProfile copyWith({
    String? id,
    String? name,
    String? address,
    String? city,
    String? postalCode,
    String? homeType,
    String? imageUrl,
    bool? isDefault,
    String? area,
    String? phone,
    String? landmark,
    Map<String, dynamic>? map,
    Map<String, dynamic>? owner,
  }) {
    return HomeProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      homeType: homeType ?? this.homeType,
      imageUrl: imageUrl ?? this.imageUrl,
      isDefault: isDefault ?? this.isDefault,
      area: area ?? this.area,
      phone: phone ?? this.phone,
      landmark: landmark ?? this.landmark,
      map: map ?? this.map,
      owner: owner ?? this.owner,
    );
  }
}
