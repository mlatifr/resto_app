import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resto_app/data/model/restaurant.dart';
import 'package:resto_app/getx/list_fav_resto_controller.dart';
import 'package:resto_app/main.dart';

class ListFavoriteResto extends StatefulWidget {
  @override
  State<ListFavoriteResto> createState() => _ListFavoriteRestoState();
}

class _ListFavoriteRestoState extends State<ListFavoriteResto> {
  @override
  void initState() {
    super.initState();
    _restoFavoriteController.getListFavResto();
  }

  final RestoFavController _restoFavoriteController =
      Get.put(RestoFavController());

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: const Text("List Resto Favorite")),
      body: Obx(() => ListView(
            shrinkWrap: true,
            children: [
              // if (_restoFavoriteController.isLoading.value) const WidgetLoading(),
              // if (!_restoFavoriteController.isLoading.value)
              //   WidgetJudulHalaman(
              //       screenWidth: screenWidth, screenHeight: screenHeight),
              // if (!_restoFavoriteController.isLoading.value) const Divider(),
              // if (!_restoFavoriteController.isLoading.value)
              //   //Kolom pencarian
              //   WidgetSearch(
              //       screenWidth: screenWidth,
              //       screenHeight: screenHeight,
              //       cariRestoTextController: _cariRestoTextController,
              //       _restoFavoriteController: _restoFavoriteController),
              // if (!_restoFavoriteController.isLoading.value) const Divider(),
              // if (!_restoFavoriteController.haveConection.value &&
              //     !_restoFavoriteController.isLoading.value)
              //   const WidgetNoInternetConnection(),
              // if (!_restoFavoriteController.isLoading.value &&
              //     _restoFavoriteController.haveConection.value)
              // Text("${_restoFavoriteController.listFavResto.length}"),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _restoFavoriteController.listFavResto.length,
                itemBuilder: (context, index) {
                  // return Text(
                  //     _restoFavoriteController.listFavResto[index].name);
                  return (WidgetCardFood(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      index: index,
                      resto: _restoFavoriteController.listFavResto[index]));
                },
              )
            ],
          )),
    );
  }
}
