import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:resto_app/restaurant.dart';

import 'article.dart';

void main() {
  runApp(const MyApp());
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
    );
  }
}

RestaurantModel? convertResto;

class MyHomePage extends StatelessWidget {
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
            FutureBuilder<String>(
              future: DefaultAssetBundle.of(context)
                  .loadString('assets/local_restaurant.json'),
              builder: (context, snapshot) {
                convertResto = restaurantModelFromJson(snapshot.data);
                // print("hasil: ${convertResto!.restaurants[0].city}");
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: convertResto!.restaurants.length,
                  itemBuilder: (context, index) {
                    return WidgetCardFood(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      index: index,
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
    return Container(
      color: Colors.redAccent,
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
  const WidgetCardFood(
      {Key? key,
      required this.screenWidth,
      required this.screenHeight,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          color: Colors.amber,
          width: screenWidth / 2,
          height: screenHeight * .1517,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            child: Image.network(
              "https://restaurant-api.dicoding.dev/images/medium/22",
              fit: BoxFit.fill,
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
                color: Colors.black12,
                width: screenWidth / 2,
                height: screenHeight * .0505,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${convertResto?.restaurants[index].name}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Container(
                color: Colors.black26,
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
                          "${convertResto?.restaurants[index].city}",
                        )
                      ],
                    )),
              ),
              Container(
                color: Colors.black26,
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
                          "${convertResto?.restaurants[index].rating}",
                        )
                      ],
                    )),
              ),
            ],
          ),
        )
      ],
    );
  }
}
