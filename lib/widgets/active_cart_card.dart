import 'package:GroceriesApplication/models/cart.dart';
import 'package:GroceriesApplication/models/store.dart';
import 'package:GroceriesApplication/models/user.dart';
import 'package:GroceriesApplication/screens/private/store/store_wrapper.dart';
import 'package:GroceriesApplication/services/cloudFirestore/app_store_service.dart';
import 'package:GroceriesApplication/utility/route/app_slide_right_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActiveCartCard extends StatefulWidget {
  final Cart cart;
  final bool isLoggedIn;
  final IconData icon;
  final User user;

  ActiveCartCard({
    this.cart,
    this.isLoggedIn,
    this.icon,
    this.user,
  });
  @override
  _ActiveCartCardState createState() => _ActiveCartCardState();
}

class _ActiveCartCardState extends State<ActiveCartCard> {
  @override
  Widget build(BuildContext context) {
    final cloudStoreService =
        Provider.of<AppStoreService>(context, listen: false);
    return widget.cart.cartItemList.length > 0
        ? StreamBuilder(
            stream: cloudStoreService.getStoreById(widget.cart.storeId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox.shrink();
              }

              DocumentSnapshot ds = snapshot.data;
              Store st = Store.fromMap(ds.data());
              st.id = ds.id;

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
                      Navigator.push(
                        context,
                        AppSlideRightRoute(
                          page: StoreWrapper(
                            store: st,
                            user: widget.user,
                            index: 1,
                          ),
                        ),
                      );
                    },
                    child: _getOrderList(context, st.storeName),
                  ),
                ),
              );
            })
        : SizedBox.shrink();
  }

  Widget _getOrderList(BuildContext context, String storeName) {
    final cloudStoreService =
        Provider.of<AppStoreService>(context, listen: false);
    return ListTile(
      leading: Icon(
        Icons.local_grocery_store,
        size: 50,
        color: Colors.orange,
      ),
      title: StreamBuilder(
        stream: cloudStoreService.getStoreById(widget.cart.storeId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox.shrink();
          }

          DocumentSnapshot ds = snapshot.data;
          Store st = Store.fromMap(ds.data());
          st.id = ds.id;
          return Text(
            st.storeName,
            style: TextStyle(
              fontSize: 16.0,
              fontFamily: "PoppinsMedium",
              fontStyle: FontStyle.normal,
              color: Colors.black,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w400,
            ),
          );
        },
      ),
      subtitle: Text(
        widget.cart.totalCost.toString() +
            '\$' +
            ' for ' +
            widget.cart.cartItemList.length.toString() +
            ' item(s)',
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
