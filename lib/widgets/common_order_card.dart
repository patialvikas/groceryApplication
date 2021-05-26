import 'package:GroceriesApplication/models/release_order.dart';
import 'package:GroceriesApplication/models/store.dart';
import 'package:GroceriesApplication/models/user.dart';
import 'package:GroceriesApplication/services/cloudFirestore/app_store_service.dart';
import 'package:GroceriesApplication/widgets/divider_with_text.dart';
import 'package:GroceriesApplication/widgets/order_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommonOrderCard extends StatefulWidget {
  final ReleaseOrder order;
  final bool isLoggedIn;
  final IconData icon;

  CommonOrderCard({
    this.order,
    this.isLoggedIn,
    this.icon,
  });
  @override
  _CommonOrderCardState createState() => _CommonOrderCardState();
}

class _CommonOrderCardState extends State<CommonOrderCard> {
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
    final cloudStoreService =
        Provider.of<AppStoreService>(context, listen: false);
    return StreamBuilder(
      stream: cloudStoreService.getUserById(widget.order.userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        DocumentSnapshot ds = snapshot.data;
        User user = User.fromMap(ds.data());
        return _getTile(context, user);
      },
    );
  }

  Widget _getTile(BuildContext context, User user) {
    return ExpansionTile(
      title: ListTile(
        leading: Icon(
          Icons.local_grocery_store,
          size: 50,
          color: Colors.orange,
        ),
        title: Text(
          '${user.firstName} ${user.lastName}',
          style: TextStyle(
            fontSize: 16.0,
            fontFamily: "PoppinsMedium",
            fontStyle: FontStyle.normal,
            color: Colors.black,
            letterSpacing: 0.6,
            fontWeight: FontWeight.w400,
          ),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$ ' + widget.order.totalCost.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: "PoppinsMedium",
                fontStyle: FontStyle.normal,
                color: Colors.black,
                letterSpacing: 0.2,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              widget.order.status,
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: "PoppinsMedium",
                fontStyle: FontStyle.normal,
                color: Colors.black,
                letterSpacing: 0.2,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              widget.order.orderItemList.length.toString() + ' Item(s)',
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: "PoppinsMedium",
                fontStyle: FontStyle.normal,
                color: Colors.black,
                letterSpacing: 0.2,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: new DividerWithText(
            dividerText: 'Customer Details',
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text('Customer Name: '),
              Text(
                '${user.firstName} ${user.lastName}',
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: "PoppinsMedium",
                  fontStyle: FontStyle.normal,
                  color: Colors.black,
                  letterSpacing: 0.3,
                  fontWeight: FontWeight.w300,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text('Customer Email: '),
              Text(
                '${user.email}',
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: "PoppinsMedium",
                  fontStyle: FontStyle.normal,
                  color: Colors.black,
                  letterSpacing: 0.3,
                  fontWeight: FontWeight.w300,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: new DividerWithText(
            dividerText: 'Order Details',
          ),
        ),
        OrderDetails(
          order: widget.order,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
