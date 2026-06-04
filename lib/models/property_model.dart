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
    );
  }
}
