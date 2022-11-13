import 'package:flutter/material.dart';
import 'package:resto_app/data/model/restaurant.dart';

import 'data/api/api_resto.dart';

void main() {
  runApp(const MyApp());
}

class DetailRestoArguments {
  final RestoListModel? restoModel;
  final int index;

  DetailRestoArguments(this.restoModel, this.index);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Resto App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      initialRoute: MyHomePage.routeName,
      // routes: {DetailResto.routeName: (context) => const DetailResto()},
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
  List<Restaurant> listResto = [];
  @override
  void dispose() {
    _cariRestoTextController.dispose();
    super.dispose();
  }

  late Future<RestoListModel> _futureResto;

  @override
  void initState() {
    super.initState();
    _futureResto = ApiService().getListResto().then((value) {
      listResto = value.restaurants;
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home Page Resto"),
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            WidgetJudulHalaman(
                screenWidth: screenWidth, screenHeight: screenHeight),
            Container(
              color: Colors.blueAccent,
              width: screenWidth,
              height: screenHeight * .07,
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Flexible(
                      child: TextField(
                    controller: _cariRestoTextController,
                    decoration: InputDecoration(
                        hintText: "Cari Resto",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  )),
                  SizedBox(
                    width: screenWidth * .05,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        // print("${_cariRestoTextController.text}");
                        ApiService()
                            .getListRestoQuery(_cariRestoTextController.text)
                            .then((value) {
                          setState(() {
                            listResto = value.restaurants;
                          });
                        });
                      },
                      child: const Icon(Icons.search))
                ],
              ),
            ),
            FutureBuilder<RestoListModel>(
              future: _futureResto,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    children: const [
                      CircularProgressIndicator(),
                      Text("Sabar itu sebagian dari iman >_<")
                    ],
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listResto.length,
                  itemBuilder: (context, index) {
                    return WidgetCardFood(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      index: index,
                      resto: listResto[index],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
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
  const WidgetCardFood(
      {Key? key,
      required this.screenWidth,
      required this.screenHeight,
      required this.index,
      required this.resto})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, DetailResto.routeName,
        //     arguments: DetailRestoArguments(restoModel, index));
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
