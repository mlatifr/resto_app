// To parse this JSON data, do
//
//     final restoModel = restoModelFromJson(jsonString);

import 'dart:convert';

RestoListModel restoModelFromJson(String str) =>
    RestoListModel.fromJson(json.decode(str));

class RestoListModel {
  RestoListModel({
    // required this.error,
    // required this.message,
    // required this.count,
    required this.restaurants,
  });

  // bool error;
  // String message;
  // int count;
  List<Restaurant> restaurants;

  factory RestoListModel.fromJson(Map<String, dynamic> json) => RestoListModel(
        // error: json["error"],
        // message: json["message"],
        // count: json["count"],
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

  String id;
  String name;
  String description;
  String pictureId;
  String city;
  double rating;

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        pictureId: json["pictureId"],
        city: json["city"],
        rating: json["rating"].toDouble(),
      );
}
