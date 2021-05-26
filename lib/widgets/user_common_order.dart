import 'package:GroceriesApplication/models/release_order.dart';
import 'package:GroceriesApplication/models/store.dart';
import 'package:GroceriesApplication/services/cloudFirestore/app_store_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserCommonOrder extends StatefulWidget {
  final ReleaseOrder order;
  final bool isLoggedIn;
  final IconData icon;

  UserCommonOrder({
    this.order,
    this.isLoggedIn,
    this.icon,
  });
  @override
  _UserCommonOrderState createState() => _UserCommonOrderState();
}

class _UserCommonOrderState extends State<UserCommonOrder> {
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
      stream: cloudStoreService.getStoreById(widget.order.storeId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        DocumentSnapshot ds = snapshot.data;
        Store st = Store.fromMap(ds.data());
        return _getTile(context, st);
      },
    );
  }

  Widget _getTile(BuildContext context, Store st) {
    return ListTile(
      leading: Icon(
        Icons.local_grocery_store,
        size: 50,
        color: Colors.orange,
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            st.storeName,
            style: TextStyle(
              fontSize: 16.0,
              fontFamily: "PoppinsMedium",
              fontStyle: FontStyle.normal,
              color: Colors.black,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w400,
            ),
          ),
          Row(
            children: [
              Text('Order ID: '),
              Text(
                widget.order.id,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: "PoppinsMedium",
                  fontStyle: FontStyle.normal,
                  color: Colors.black,
                  letterSpacing: 0.6,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
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
    );
  }
}
