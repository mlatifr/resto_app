import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:resto_app/detail_resto.dart';
import 'package:resto_app/data/model/restaurant.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
  ApiService().getListResto();
}

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/list';
  Future<RestoListModel> getListResto() async {
    final response = await http.get(Uri.parse("${_baseUrl}"));
    RestoListModel decodeRestoStatus = restoModelFromJson(response.body);
    return decodeRestoStatus;
  }
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

RestoListModel? convertResto;

class MyHomePage extends StatelessWidget {
  static const routeName = '/';
  const MyHomePage({super.key});

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
            FutureBuilder<RestoListModel>(
              future: ApiService().getListResto(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    children: const [
                      CircularProgressIndicator(),
                      Text("Sabar itu sebagian dari iman >,<")
                    ],
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.restaurants.length,
                  itemBuilder: (context, index) {
                    return WidgetCardFood(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      index: index,
                      restoModel: snapshot.data,
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
  final RestoListModel? restoModel;
  const WidgetCardFood(
      {Key? key,
      required this.screenWidth,
      required this.screenHeight,
      required this.index,
      required this.restoModel})
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
                "https://restaurant-api.dicoding.dev/images/medium/${restoModel?.restaurants[index].pictureId}",
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
                      "${restoModel?.restaurants[index].name}",
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
                            "${restoModel?.restaurants[index].city}",
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
                            "${restoModel?.restaurants[index].rating}",
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
