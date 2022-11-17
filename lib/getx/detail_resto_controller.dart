import 'dart:convert';

import 'package:get/get.dart';
import 'package:resto_app/data/model/detail_resto_model.dart';
import 'package:http/http.dart' as http;

class DetailRestoController extends GetxController with StateMixin {
  var onLoading = true;
  final String id;
  var listCategories = <Category>[].obs;
  var listDrinks = <Category>[].obs;
  var listFoods = <Category>[].obs;
  var detailResto = RestaurantDetail(
      id: "id",
      name: "name",
      description: "zzzdescription",
      city: "city",
      address: "address",
      pictureId: "pictureId",
      categories: [],
      menus: Menus(drinks: [], foods: []),
      rating: 1.1,
      customerReviews: []).obs;

  DetailRestoController({required this.id, required this.onLoading});

  @override
  void onInit() {
    getDetailResto(id);
    super.onInit();
  }

  Future getDetailResto(String id) async {
    try {
      String baseUrl = 'https://restaurant-api.dicoding.dev/detail/$id';
      final response = await http.get(Uri.parse(baseUrl));
      var result = jsonDecode(response.body);
      // print("result: $result");
      var resultDecode = DetailRestoModel.fromJson(result);

      detailResto.update((val) {
        val!.id = resultDecode.restaurant.id;
        val.name = resultDecode.restaurant.name;
        val.description = resultDecode.restaurant.description;
        val.city = resultDecode.restaurant.city;
        val.address = resultDecode.restaurant.address;
        val.pictureId = resultDecode.restaurant.pictureId;
        val.categories = resultDecode.restaurant.categories;
        val.menus = resultDecode.restaurant.menus;
        val.rating = resultDecode.restaurant.rating;
        val.customerReviews = resultDecode.restaurant.customerReviews;
      });
      change(detailResto().pictureId, status: RxStatus.success());
      onLoading = false;
      return detailResto;
    } catch (e) {
      return e;
    }
  }
}
