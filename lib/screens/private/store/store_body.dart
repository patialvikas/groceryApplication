import 'package:GroceriesApplication/widgets/app_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class StoreBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          //physics: NeverScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: 10,
            ),
            AppSlider(
              leftText: 'Vegitables',
              rightText: 'See All->',
              isProduct: true,
            ),
            SizedBox(
              height: 10,
            ),
            AppSlider(
              leftText: 'Grocery',
              rightText: 'See All->',
              isProduct: true,
            ),
            SizedBox(
              height: 10,
            ),
            AppSlider(
              leftText: 'Breverage',
              rightText: 'See All->',
              isProduct: true,
            ),
            SizedBox(
              height: 10,
            ),
            AppSlider(
              leftText: 'Meat',
              rightText: 'See All->',
              isProduct: true,
            ),
          ],
        ));
  }
}
