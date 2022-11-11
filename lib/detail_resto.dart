import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:resto_app/main.dart';
import 'package:resto_app/restaurant.dart';

class DetailResto extends StatelessWidget {
  static const routeName = '/detailResto';

  const DetailResto({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as DetailRestoArguments;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, isScrolled) {
            return [
              SliverAppBar(
                expandedHeight: screenHeight * .25,
                // backgroundColor: Colors.transparent,
                flexibleSpace: Stack(children: [
                  Positioned.fill(
                      child: Image.network(
                    "${args.restoModel!.restaurants[args.index].pictureId}",
                    fit: BoxFit.cover,
                  ))
                ]),
              ),
            ];
          },
          body: Text("${args.index}")),
    );
  }
}
