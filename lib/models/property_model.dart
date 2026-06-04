class PropertyModel {
  final int id;
  final String title;
  final String location;
  final String imageUrl;
  final int price;
  final int rooms;
  final int bathrooms;
  final int area;
  final String whatsapp;
  final double? lat; // خط العرض
  final double? lng; // خط الطول
  final String? addressUrl; // رابط خرائط جوجل
  final bool isFeatured; // مميز؟
  final bool isActive; // منشور/مخفي
  final DateTime createdAt;

  PropertyModel({
    required this.id,
    required this.title,
    required this.location,
    required this.imageUrl,
    required this.price,
    required this.rooms,
    required this.bathrooms,
    required this.area,
    required this.whatsapp,
    this.lat,
    this.lng,
    this.addressUrl,
    this.isFeatured = false,
    this.isActive = true,
    required this.createdAt,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'],
      title: json['title'],
      location: json['location'],
      imageUrl: json['image_url'],
      price: json['price'],
      rooms: json['rooms'],
      bathrooms: json['bathrooms'],
      area: json['area'],
      whatsapp: json['whatsapp'],
      lat: json['lat']?.toDouble(),
      lng: json['lng']?.toDouble(),
      addressUrl: json['address_url'],
      isFeatured: json['is_featured']?? false,
      isActive: json['is_active']?? true,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'location': location,
      'image_url': imageUrl,
      'price': price,
      'rooms': rooms,
      'bathrooms': bathrooms,
      'area': area,
      'whatsapp': whatsapp,
      'lat': lat,
      'lng': lng,
      'address_url': addressUrl,
      'is_featured': isFeatured,
      'is_active': isActive,
    };
  }
}
