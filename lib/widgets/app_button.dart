import 'package:GroceriesApplication/styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  AppButton({
    this.label,
    this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.0, bottom: 20.0),
      width: MediaQuery.of(context).size.width * 0.7,
      height: 49.0,
      decoration: BoxDecoration(
          color: green, borderRadius: BorderRadius.circular(23.0)),
      child: RawMaterialButton(
        onPressed: () {
          onPressed();
        },
        child: Text(
          label,
          style: hintStylewhitetextPSB(),
        ),
      ),
    );
  }
}
