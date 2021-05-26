import 'package:GroceriesApplication/models/order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatefulWidget {
  final Order order;
  final bool isLoggedIn;
  final IconData icon;

  OrderCard({
    this.order,
    this.isLoggedIn,
    this.icon,
  });
  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 10,
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        shadowColor: Color.fromRGBO(105, 105, 105, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: GestureDetector(
          onTap: () {
            //Nothing as of now
          },
          child: _getOrderList(context),
        ),
      ),
    );
  }

  Widget _getOrderList(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.local_grocery_store,size: 50,color: Colors.orange,),
      title: Text(
        widget.order.orderOriginatorName,
        style: TextStyle(
          fontSize: 16.0,
          fontFamily: "PoppinsMedium",
          fontStyle: FontStyle.normal,
          color: Colors.black,
          letterSpacing: 0.6,
          fontWeight: FontWeight.w400,
        ),
      ),
      subtitle: Text(
        widget.order.orderOriginatorAddress,
        style: TextStyle(
          fontSize: 14.0,
          fontFamily: "PoppinsMedium",
          fontStyle: FontStyle.normal,
          color: Colors.black,
          letterSpacing: 0.2,
          fontWeight: FontWeight.w300,
        ),
      ),
      trailing: Icon(widget.icon),
    );
  }
}
