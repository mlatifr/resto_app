import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resto_app/data/model/restaurant.dart';
import 'package:resto_app/getx/detail_resto_controller.dart';
import 'package:resto_app/getx/list_fav_resto_controller.dart';
import 'package:resto_app/main.dart';

class DetailResto extends StatefulWidget {
  static const routeName = '/detailResto';
  final Restaurant? resto;
  const DetailResto({
    super.key,
    this.resto,
  });

  @override
  State<DetailResto> createState() => _DetailRestoState();
}

class _DetailRestoState extends State<DetailResto> {
  @override
  void initState() {
    super.initState();
    cekListFavRestoById(widget.resto!.id);
  }

  cekListFavRestoById(id) {
    restoFavController.getRestoById("$id").then((value) {
      restoFavController.valueIcon.value = value;
    });
  }

  snackbarFavorite(String msg) {
    final snackBar =
        SnackBar(content: Text(msg), duration: const Duration(seconds: 1));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  final RestoFavController restoFavController = RestoFavController();
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as DetailRestoArguments;
    final DetailRestoController detailRestoController =
        Get.put(DetailRestoController(id: args.id));
    double screenHeight = Get.height;
    return SafeArea(
        child: Scaffold(
            body: NestedScrollView(
                headerSliverBuilder: (context, isScrolled) {
                  return [
                    SliverAppBar(
                      leading: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        child: IconButton(
                          onPressed: (() => Navigator.pop(context)),
                          icon: const Icon(Icons.arrow_back),
                          color: Colors.white,
                        ),
                      ),
                      expandedHeight: screenHeight * .25,
                      flexibleSpace: Stack(clipBehavior: Clip.none, children: [
                        Obx(
                          () {
                            if (detailRestoController.isLoading.isTrue) {
                              return const WidgetLoading();
                            } else {
                              return Positioned.fill(
                                  child:
                                      detailRestoController.isLoading.isFalse &&
                                              detailRestoController
                                                  .haveConection.isTrue
                                          ? Hero(
                                              tag: detailRestoController
                                                  .detailResto()
                                                  .pictureId,
                                              child: Image.network(
                                                "https://restaurant-api.dicoding.dev/images/large/${detailRestoController.detailResto().pictureId}",
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : const Center(
                                              child: Text(
                                                  "Mohon maaf, sepertinya internet anda sedang terganggu"),
                                            ));
                            }
                          },
                        ),
                        Positioned(
                          right: 5,
                          bottom: -30,
                          child: ElevatedButton(
                            onPressed: () async {
                              cekListFavRestoById(widget.resto!.id);
                              Restaurant resto = Restaurant(
                                  id: detailRestoController.detailResto().id,
                                  name:
                                      detailRestoController.detailResto().name,
                                  description: detailRestoController
                                      .detailResto()
                                      .description,
                                  pictureId: detailRestoController
                                      .detailResto()
                                      .pictureId,
                                  city:
                                      detailRestoController.detailResto().city,
                                  rating: detailRestoController
                                      .detailResto()
                                      .rating);
                              if (restoFavController.valueIcon.value == false) {
                                await restoFavController
                                    .addFavoriteResto(resto);
                                restoFavController.valueIcon.value = true;
                                snackbarFavorite(
                                    "${resto.name} added to favorite");
                              } else {
                                await restoFavController.deleteResto(resto.id);
                                restoFavController.valueIcon.value = false;
                                snackbarFavorite("${resto.name} deleted");
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(15),
                                backgroundColor: Colors.white),
                            child: Column(
                              children: [
                                Obx(
                                  () => Icon(
                                    Icons.favorite,
                                    color: restoFavController.valueIcon.isFalse
                                        ? Colors.grey
                                        : Colors.red,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ]),
                    ),
                  ];
                },
                body: Obx(
                  () => Stack(
                    children: [
                      ListView(
                        padding: const EdgeInsets.all(20),
                        shrinkWrap: true,
                        children: [
                          if (detailRestoController.isLoading.isTrue)
                            const WidgetLoading(),
                          if (detailRestoController.isLoading.isFalse &&
                              detailRestoController.haveConection.isFalse)
                            const WidgetNoInternetConnection(),
                          if (detailRestoController.isLoading.isFalse &&
                              detailRestoController.haveConection.isTrue)
                            Obx(
                              () => Text(
                                detailRestoController.detailResto().name,
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                          const SizedBox(height: 2),
                          if (detailRestoController.isLoading.isFalse &&
                              detailRestoController.haveConection.isTrue)
                            Row(
                              children: [
                                const Icon(Icons.location_on),
                                Obx(
                                  () => Text(
                                    detailRestoController.detailResto().city,
                                  ),
                                )
                              ],
                            ),
                          const SizedBox(height: 2),
                          if (detailRestoController.isLoading.isFalse &&
                              detailRestoController.haveConection.isTrue)
                            Row(
                              children: [
                                const Icon(Icons.star),
                                Obx(
                                  () => Text(
                                    "${detailRestoController.detailResto().rating}",
                                  ),
                                )
                              ],
                            ),
                          const SizedBox(height: 2),
                          if (detailRestoController.isLoading.isFalse &&
                              detailRestoController.haveConection.isTrue)
                            Obx(
                              () => Text(
                                detailRestoController.detailResto().description,
                                maxLines: 100,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          const SizedBox(height: 12),
                          if (detailRestoController.isLoading.isFalse &&
                              detailRestoController.haveConection.isTrue)
                            const Text(
                              "Foods",
                              style: TextStyle(fontSize: 18),
                            ),
                          const SizedBox(height: 12),
                          if (detailRestoController.isLoading.isFalse &&
                              detailRestoController.haveConection.isTrue)
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .121,
                                child: Obx(
                                  () => ListView.builder(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: detailRestoController
                                        .detailResto()
                                        .menus
                                        .foods
                                        .length,
                                    itemBuilder: (context, index) {
                                      return Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(15)),
                                            child: Container(
                                              color: Colors.lightBlueAccent,
                                              padding: const EdgeInsets.all(10),
                                              child: Text(detailRestoController
                                                  .detailResto()
                                                  .menus
                                                  .foods[index]
                                                  .name),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                )),
                          const SizedBox(height: 30),
                          if (detailRestoController.isLoading.isFalse &&
                              detailRestoController.haveConection.isTrue)
                            const Text(
                              "Drinks",
                              style: TextStyle(fontSize: 18),
                            ),
                          const SizedBox(height: 12),
                          if (detailRestoController.isLoading.isFalse &&
                              detailRestoController.haveConection.isTrue)
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .121,
                                child: Obx(
                                  () => ListView.builder(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: detailRestoController
                                        .detailResto()
                                        .menus
                                        .drinks
                                        .length,
                                    itemBuilder: (context, index) {
                                      return Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(15)),
                                            child: Container(
                                              color: Colors.lightBlueAccent,
                                              padding: const EdgeInsets.all(10),
                                              child: Text(detailRestoController
                                                  .detailResto()
                                                  .menus
                                                  .drinks[index]
                                                  .name),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                )),
                        ],
                      ),
                      Positioned(
                        right: 12,
                        child: Container(
                          width: 50,
                          height: 30,
                          color: Colors.transparent,
                          child: GestureDetector(
                            onTap: () async {
                              Restaurant resto = Restaurant(
                                  id: detailRestoController.detailResto().id,
                                  name:
                                      detailRestoController.detailResto().name,
                                  description: detailRestoController
                                      .detailResto()
                                      .description,
                                  pictureId: detailRestoController
                                      .detailResto()
                                      .pictureId,
                                  city:
                                      detailRestoController.detailResto().city,
                                  rating: detailRestoController
                                      .detailResto()
                                      .rating);
                              if (restoFavController.valueIcon.value == false) {
                                await restoFavController
                                    .addFavoriteResto(resto);
                                restoFavController.valueIcon.value = true;
                                snackbarFavorite(
                                    "${resto.name} added to favorite");
                              } else {
                                await restoFavController.deleteResto(resto.id);
                                restoFavController.valueIcon.value = false;
                                snackbarFavorite("${resto.name} deleted");
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ))));
  }
}
