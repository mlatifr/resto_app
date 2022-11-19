import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resto_app/main.dart';
import 'getx/detail_resto_controller.dart';

class DetailResto extends StatefulWidget {
  static const routeName = '/detailResto';
  const DetailResto({
    super.key,
  });

  @override
  State<DetailResto> createState() => _DetailRestoState();
}

class _DetailRestoState extends State<DetailResto> {
  @override
  void initState() {
    super.initState();
  }

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
                        child: Container(
                          color: Colors.lightBlueAccent,
                          child: IconButton(
                            onPressed: (() => Navigator.pop(context)),
                            icon: const Icon(Icons.arrow_back),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      expandedHeight: screenHeight * .25,
                      flexibleSpace: Stack(children: [
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
                                          ? Image.network(
                                              "https://restaurant-api.dicoding.dev/images/large/${detailRestoController.detailResto().pictureId}",
                                              fit: BoxFit.cover,
                                            )
                                          : const Center(
                                              child: Text(
                                                  "Mohon maaf, sepertinya internet anda sedang terganggu"),
                                            ));
                            }
                          },
                        )
                      ]),
                    ),
                  ];
                },
                body: Obx(
                  () => ListView(
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
                            maxLines: 5,
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
                            height: 35,
                            child: Obx(
                              () => ListView.builder(
                                shrinkWrap: true,
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
                                        borderRadius: const BorderRadius.all(
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
                            height: 35,
                            child: Obx(
                              () => ListView.builder(
                                shrinkWrap: true,
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
                                        borderRadius: const BorderRadius.all(
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
                ))));
  }
}
