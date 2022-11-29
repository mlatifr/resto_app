import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resto_app/data/model/restaurant.dart';
import 'package:resto_app/getx/list_resto_controller.dart';

import 'ui/detail_resto.dart';
import 'ui/list_favorite_resto.dart';

void main() {
  runApp(const MyApp());
}

class DetailRestoArguments {
  final int index;
  final String id;
  final String pictureId;
  DetailRestoArguments(this.index, this.id, this.pictureId);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Resto App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ListResto(),
      initialRoute: ListResto.routeName,
      routes: {
        '/favoriteRestoList': (context) => ListFavoriteResto(),
      },
    );
  }
}

class ListResto extends StatefulWidget {
  static const routeName = '/';
  const ListResto({super.key});

  @override
  State<ListResto> createState() => _ListRestoState();
}

class _ListRestoState extends State<ListResto> {
  final TextEditingController _cariRestoTextController =
      TextEditingController();

  @override
  void dispose() {
    _cariRestoTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    final RestoController restoController = Get.put(RestoController());
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Home Page Resto"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/favoriteRestoList');
              },
              icon: const Icon(Icons.favorite))
        ],
      ),
      body: Obx(() => ListView(
            shrinkWrap: true,
            children: [
              if (restoController.isLoading.value) const WidgetLoading(),
              if (!restoController.isLoading.value)
                WidgetJudulHalaman(
                    screenWidth: screenWidth, screenHeight: screenHeight),
              if (!restoController.isLoading.value) const Divider(),
              if (!restoController.isLoading.value)
                //Kolom pencarian
                WidgetSearch(
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    cariRestoTextController: _cariRestoTextController,
                    restoController: restoController),
              if (!restoController.isLoading.value) const Divider(),
              if (!restoController.haveConection.value &&
                  !restoController.isLoading.value)
                const WidgetNoInternetConnection(),
              if (!restoController.isLoading.value &&
                  restoController.haveConection.value)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: restoController.listResto.length,
                  itemBuilder: (context, index) {
                    return (WidgetCardFood(
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        index: index,
                        resto: restoController.listResto[index]));
                  },
                )
            ],
          )),
    ));
  }
}

class WidgetNoInternetConnection extends StatelessWidget {
  const WidgetNoInternetConnection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      child: const Text(
        "Mohon maaf, koneksi internetmu sedang terganggu\n"
        "Silahkan cek koneksimu",
        textAlign: TextAlign.justify,
      ),
    );
  }
}

class WidgetCardFood extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final int index;
  final Restaurant? resto;
  const WidgetCardFood({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
    required this.index,
    required this.resto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => DetailResto(resto: resto),
            arguments:
                DetailRestoArguments(index, resto!.id, resto!.pictureId));
      },
      child: Container(
        color: Colors.transparent,
        child: ClipRRect(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                width: screenWidth / 2,
                height: screenHeight * .1517,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  child: Hero(
                    tag: resto!.pictureId,
                    child: Image.network(
                      "https://restaurant-api.dicoding.dev/images/medium/${resto!.pictureId}",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                width: (screenWidth / 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          resto!.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth / 2,
                      height: screenHeight * .0505,
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_pin,
                              ),
                              FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  resto!.city,
                                ),
                              )
                            ],
                          )),
                    ),
                    SizedBox(
                      width: screenWidth / 2,
                      height: screenHeight * .0505,
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                              ),
                              FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  "${resto!.rating}",
                                ),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class WidgetSearch extends StatelessWidget {
  const WidgetSearch({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
    required TextEditingController cariRestoTextController,
    required this.restoController,
  })  : _cariRestoTextController = cariRestoTextController,
        super(key: key);

  final double screenWidth;
  final double screenHeight;
  final TextEditingController _cariRestoTextController;
  final RestoController restoController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth,
      height: screenHeight * .07,
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Flexible(
              child: TextField(
            controller: _cariRestoTextController,
            decoration: InputDecoration(
                hintText: "Cari Resto atau Menu",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15))),
          )),
          SizedBox(
            width: screenWidth * .05,
          ),
          ElevatedButton(
              onPressed: () {
                restoController.isLoading(true);
                if (_cariRestoTextController.text.isEmpty) {
                  restoController.onInit();
                } else {
                  restoController
                      .getListRestoQuery(_cariRestoTextController.text);
                }
              },
              child: const Icon(Icons.search))
        ],
      ),
    );
  }
}

class WidgetLoading extends StatelessWidget {
  const WidgetLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        CircularProgressIndicator(),
        Text(
            "Tenang aja, kami sedang memproses pencarianmu\nPermintaanmu kamu sedang kamu proses")
      ],
    );
  }
}

class WidgetJudulHalaman extends StatelessWidget {
  const WidgetJudulHalaman({
    Key? key,
    required double screenWidth,
    required double screenHeight,
  })  : _screenWidth = screenWidth,
        _screenHeight = screenHeight,
        super(key: key);

  final double _screenWidth;
  final double _screenHeight;

  @override
  Widget build(BuildContext context) {
    return const FittedBox(
      fit: BoxFit.fitWidth,
      child: Center(
          child: Text(
        "Daftar rekomendasi restaurant",
        style: TextStyle(fontWeight: FontWeight.w600),
      )),
    );
  }
}
