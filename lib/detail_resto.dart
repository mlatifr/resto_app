import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:resto_app/restaurant.dart';

class DetailResto extends StatelessWidget {
  static const routeName = '/detailResto';
  final RestaurantModel? restaurantModel;
  const DetailResto({super.key, this.restaurantModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
