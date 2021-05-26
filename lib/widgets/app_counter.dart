import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppCounter extends StatefulWidget {
  final int count;
  final Function increaseCounter;
  const AppCounter({
    Key key,
    this.count,
    this.increaseCounter,
  }) : super(key: key);

  @override
  _AppCounterState createState() => _AppCounterState();
}

class _AppCounterState extends State<AppCounter> {
  int _currentAmount;
  @override
  void initState() {
    if (widget.count != null) {
      _currentAmount = widget.count;
    } else {
      _currentAmount = 0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        GestureDetector(
          child: Container(
            padding: const EdgeInsets.all(1.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
            child: Icon(
              Icons.remove,
              size: 20,
              color: Colors.white,
            ),
          ),
          onTap: () {
            if (_currentAmount != 0) {
              setState(() {
                _currentAmount -= 1;
              });
              widget.increaseCounter(_currentAmount);
            }
          },
        ),
        SizedBox(width: 10),
        Text(
          "$_currentAmount",
          style: TextStyle(
            fontSize: 14.0,
            fontFamily: "PoppinsMedium",
            fontStyle: FontStyle.normal,
            color: Colors.black,
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(width: 10),
        GestureDetector(
          child: Container(
            padding: const EdgeInsets.all(1.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
            child: Icon(
              Icons.add,
              size: 20,
              color: Colors.white,
            ),
          ),
          onTap: () {
            setState(() {
              _currentAmount += 1;
            });
            widget.increaseCounter(_currentAmount);
          },
        ),
      ],
    );
  }
}
