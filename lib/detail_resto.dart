import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resto_app/main.dart';
import 'getx/detail_resto_controller.dart';

class DetailResto extends StatelessWidget {
  static const routeName = '/detailResto';

  const DetailResto({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final DetailRestoController detailRestoController =
        Get.put(DetailRestoController());
    print(detailRestoController.detailResto().id);
    final args =
        ModalRoute.of(context)!.settings.arguments as DetailRestoArguments;

    double screenHeight = Get.height;
    // return Scaffold(
    //   appBar: AppBar(),
    //   // body: Obx(() =>
    //   //     (Text("${detailRestoController.detailResto().menus.foods[0].name}"))),
    // );
    return SafeArea(
        child: Scaffold(
            body: NestedScrollView(
      headerSliverBuilder: (context, isScrolled) {
        return [
          SliverAppBar(
            leading: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
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
              Center(
                  child: Obx((() => Text(
                      "${detailRestoController.detailResto().pictureId}"))))
              // Positioned.fill(
              //     child: Image.network(
              //   restoController.listResto[args.index].pictureId,
              //   fit: BoxFit.cover,
              // ))
            ]),
          ),
        ];
      },
      body: ListView(
        padding: const EdgeInsets.all(20),
        shrinkWrap: true,
        children: [
          Obx(
            () => Text(
              "${detailRestoController.detailResto().name}",
              style: const TextStyle(fontSize: 22),
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.location_on),
              Obx(
                () => Text(
                  "${detailRestoController.detailResto().city}",
                ),
              )
            ],
          ),
          const SizedBox(height: 2),
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
          Obx(
            () => Text(
              "${detailRestoController.detailResto().description}",
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.justify,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Foods",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 12),
          SizedBox(
              height: 35,
              child: Obx(
                () => ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      detailRestoController.detailResto().menus.foods.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          child: Container(
                            color: Colors.lightBlueAccent,
                            padding: const EdgeInsets.all(10),
                            child: Text(
                                "${detailRestoController.detailResto().menus.foods[index].name}"),
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
          const Text(
            "Drinks",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 12),
          SizedBox(
              height: 35,
              child: Obx(
                () => ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      detailRestoController.detailResto().menus.drinks.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          child: Container(
                            color: Colors.lightBlueAccent,
                            padding: const EdgeInsets.all(10),
                            child: Text(
                                "${detailRestoController.detailResto().menus.drinks[index].name}"),
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
    )));
  }
}
