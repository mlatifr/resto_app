import 'package:flutter/material.dart';
import 'package:resto_app/main.dart';

class DetailResto extends StatelessWidget {
  static const routeName = '/detailResto';

  const DetailResto({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as DetailRestoArguments;
    double screenHeight = MediaQuery.of(context).size.height;
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
                  Positioned.fill(
                      child: Image.network(
                    args.restoModel!.restaurants[args.index].pictureId,
                    fit: BoxFit.cover,
                  ))
                ]),
              ),
            ];
          },
          body: ListView(
            padding: const EdgeInsets.all(20),
            shrinkWrap: true,
            children: [
              Text(
                args.restoModel!.restaurants[args.index].name,
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.location_on),
                  Text(
                    args.restoModel!.restaurants[args.index].city,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.star),
                  Text(
                    args.restoModel!.restaurants[args.index].rating.toString(),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                args.restoModel!.restaurants[args.index].description,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 12),
              const Text(
                "Foods",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 35,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: args
                      .restoModel!.restaurants[args.index].menus.foods.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          child: Container(
                            color: Colors.lightBlueAccent,
                            padding: const EdgeInsets.all(10),
                            child: Text(args.restoModel!.restaurants[args.index]
                                .menus.foods[index].name),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        )
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Drinks",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 35,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: args
                      .restoModel!.restaurants[args.index].menus.drinks.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          child: Container(
                            color: Colors.lightBlueAccent,
                            padding: const EdgeInsets.all(10),
                            child: Text(args.restoModel!.restaurants[args.index]
                                .menus.drinks[index].name),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
