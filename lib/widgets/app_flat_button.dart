import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AppFlatButton extends StatelessWidget {
  final String data;
  final Color backgroundColor;
  final Color textColor;
  AppFlatButton({this.data, this.backgroundColor,this.textColor});
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: MediaQuery.of(context).size.width * 0.17,
        height: MediaQuery.of(context).size.width * 0.17,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: backgroundColor,
        ),
        child: Center(
            child: Text(
          '$data',
          style: TextStyle(color: textColor,fontSize: 35, fontWeight: FontWeight.w700),
        )),
      ),
    );
  }
}
