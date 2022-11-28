import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resto_app/data/model/restaurant.dart';
import 'package:resto_app/getx/list_fav_resto_controller.dart';

class ListFavoriteResto extends StatelessWidget {
  ListFavoriteResto({super.key});
  TextEditingController idController = TextEditingController(text: "1");
  TextEditingController nameController = TextEditingController(text: "name");
  TextEditingController descriptionController =
      TextEditingController(text: "description");
  TextEditingController pictureIdController = TextEditingController(text: "14");
  TextEditingController cityController = TextEditingController(text: "SBY");
  TextEditingController ratingController = TextEditingController(text: "1.0");

  final RestoFavController _restoFavoriteController =
      Get.put(RestoFavController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("List Resto Favorite")),
      body: Center(
          child: Column(
        children: [
          TextField(controller: idController),
          TextField(controller: nameController),
          TextField(controller: descriptionController),
          TextField(controller: pictureIdController),
          TextField(controller: cityController),
          TextField(controller: ratingController),
          ElevatedButton(
              onPressed: (() {
                Restaurant _resto = Restaurant(
                    id: idController.text,
                    name: nameController.text,
                    description: descriptionController.text,
                    pictureId: pictureIdController.text,
                    city: cityController.text,
                    rating: double.parse(ratingController.text));
                _restoFavoriteController.addFavoriteResto(_resto);
                _restoFavoriteController.getListFavResto();
              }),
              child: const Text('add new resto')),
          ElevatedButton(onPressed: (() {}), child: const Text('Get Fav Notes'))
        ],
      )),
    );
  }
}
