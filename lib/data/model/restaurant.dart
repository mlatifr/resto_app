import 'dart:convert';

RestoListModel restoModelFromJson(String str) =>
    RestoListModel.fromJson(json.decode(str));

class RestoListModel {
  RestoListModel({
    required this.restaurants,
  });

  List<Restaurant> restaurants;

  factory RestoListModel.fromJson(Map<String, dynamic> json) => RestoListModel(
        restaurants: List<Restaurant>.from(json["restaurants"]
            .map((x) => Restaurant.fromJson(x))
            .where((resto) =>
                resto.name != null &&
                resto.pictureId != null &&
                resto.city != null &&
                resto.rating != null)),
      );
}

class Restaurant {
  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  late String id;
  late String name;
  late String description;
  late String pictureId;
  late String city;
  late double? rating;

  Restaurant.fromMap(Map<String, dynamic> map) {
    id = map['id'].toString();
    name = map['name'];
    description = map['description'];
    pictureId = map['pictureId'];
    city = map['city'];
    rating = map['rating'];
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pictureId': pictureId,
      'city': city,
      'rating': rating,
    };
  }

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        pictureId: json["pictureId"],
        city: json["city"],
        rating: json["rating"].toDouble(),
      );
}
