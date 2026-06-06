class PropertyModel {
  final int id;
  final String title;
  final String location;
  final double price;
  final int rooms;
  final int bathrooms;
  final double area;
  final String type;
  final String imageUrl;
  final bool isFeatured;
  final bool isActive;
  final DateTime createdAt;
  final double? latitude;
  final double? longitude;

  PropertyModel({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    required this.rooms,
    required this.bathrooms,
    required this.area,
    required this.type,
    required this.imageUrl,
    required this.isFeatured,
    required this.isActive,
    required this.createdAt,
    this.latitude,
    this.longitude,
  });

  double? get lat => latitude;
  double? get lng => longitude;

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] as int,
      title: json['title'] as String,
      location: json['location'] as String,
      price: (json['price'] as num).toDouble(),
      // تصحيح علامات الاستفهام للتعامل مع القيم الفارغة بشكل آمن
      rooms: json['rooms'] as int? ?? 0,
      bathrooms: json['bathrooms'] as int? ?? 0,
      area: (json['area'] as num?)?.toDouble() ?? 0.0,
      type: json['type'] as String,
      imageUrl: json['image_url'] as String,
      isFeatured: json['is_featured'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'price': price,
      'rooms': rooms,
      'bathrooms': bathrooms,
      'area': area,
      'type': type,
      'image_url': imageUrl,
      'is_featured': isFeatured,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
