class PropertyModel {
  final int id;
  final String title;
  final String location;
  final int price;
  final String imageUrl;
  final int rooms;
  final int bathrooms;
  final int area;
  final String type;
  final bool isFeatured;
  final bool isActive;
  final double? lat;
  final double? lng;
  final String whatsapp;
  final DateTime createdAt;

  PropertyModel({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    required this.imageUrl,
    required this.rooms,
    required this.bathrooms,
    required this.area,
    required this.type,
    required this.isFeatured,
    required this.isActive,
    this.lat,
    this.lng,
    required this.whatsapp,
    required this.createdAt,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'],
      title: json['title'],
      location: json['location'],
      price: json['price'],
      imageUrl: json['image_url'],
      rooms: json['rooms'],
      bathrooms: json['bathrooms'],
      area: json['area'],
      type: json['type'],
      isFeatured: json['is_featured']?? false,
      isActive: json['is_active']?? true,
      lat: json['lat']?.toDouble(),
      lng: json['lng']?.toDouble(),
      whatsapp: json['whatsapp']?? '9647500000000',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
