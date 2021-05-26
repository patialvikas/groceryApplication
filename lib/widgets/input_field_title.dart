import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class InputFieldTitle extends StatelessWidget {
  final String text;
  InputFieldTitle({
    this.text,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      margin: EdgeInsets.only(top: 15.0),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
