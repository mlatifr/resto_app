import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resto_app/data/model/restaurant.dart';
import 'package:resto_app/detail_resto.dart';
import 'package:resto_app/getx/list_resto_controller.dart';

void main() {
  runApp(const MyApp());
}

class DetailRestoArguments {
  final int index;
  final String id;
  final String pictureId;
  DetailRestoArguments(this.index, this.id, this.pictureId);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Resto App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      initialRoute: MyHomePage.routeName,
    );
  }
}

class MyHomePage extends StatefulWidget {
  static const routeName = '/';
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _cariRestoTextController =
      TextEditingController();

  @override
  void dispose() {
    _cariRestoTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = Get.width;
    var screenHeight = Get.height;
    final RestoController restoController = Get.put(RestoController());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home Page Resto"),
        ),
        body: Obx(() {
          return ListView(
            shrinkWrap: true,
            children: [
              WidgetJudulHalaman(
                  screenWidth: screenWidth, screenHeight: screenHeight),
              const Divider(),
              //Kolom pencarian
              Container(
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
                            restoController.getListRestoQuery(
                                _cariRestoTextController.text);
                          }
                        },
                        child: const Icon(Icons.search))
                  ],
                ),
              ),
              const Divider(),
              if (restoController.isLoading.isTrue) const WidgetLoading(),
              //Card list resto
              if (restoController.isLoading.isFalse)
                FutureBuilder(
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        restoController.isLoading.isTrue) {
                      return const WidgetLoading();
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      restoController.isLoading(false);
                    }
                    if (restoController.listResto.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        child: const Center(
                          child: Text(
                            "Mohon maaf\nResto atau menu yang anda cari belum tersedia\n1. Pastikan koneksi internetmu aman\n2. Setelah itu kamu bisa kosongkan text pencarian\n3. Kemudian klik icon cari untuk melihat semua list resto ^_^",
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: restoController.listResto.length,
                      itemBuilder: (context, index) {
                        return WidgetCardFood(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          index: index,
                          resto: restoController.listResto[index],
                        );
                      },
                    );
                  },
                ),
            ],
          );
        }),
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
    return SizedBox(
      width: _screenWidth,
      height: _screenHeight * .08,
      child: const Center(
          child: Text(
        "Daftar rekomendasi restaurant",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      )),
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
        Get.to(() => const DetailResto(),
            arguments:
                DetailRestoArguments(index, resto!.id, resto!.pictureId));
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            width: screenWidth / 2,
            height: screenHeight * .1517,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              child: Image.network(
                "https://restaurant-api.dicoding.dev/images/medium/${resto!.pictureId}",
                fit: BoxFit.cover,
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
                Container(
                  color: Colors.lightBlueAccent,
                  width: screenWidth / 2,
                  height: screenHeight * .0505,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      resto!.name,
                      maxLines: 2,
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
                          Text(
                            resto!.city,
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
                          Text(
                            "${resto!.rating}",
                          )
                        ],
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
