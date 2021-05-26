import 'package:GroceriesApplication/models/cart.dart';
import 'package:GroceriesApplication/models/user.dart';
import 'package:GroceriesApplication/services/cloudFirestore/app_store_service.dart';
import 'package:GroceriesApplication/widgets/active_cart_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ActiveCart extends StatelessWidget {
  final User user;
  ActiveCart({
    this.user,
  });
  @override
  Widget build(BuildContext context) {
    final cloudStoreService =
        Provider.of<AppStoreService>(context, listen: false);
    return StreamBuilder<Object>(
      stream: cloudStoreService.getAllCartDetails(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        QuerySnapshot qs = snapshot.data;
        if (qs.docs.length > 0) {
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: qs.docs.length,
            itemBuilder: (context, index) {
              Cart cart = Cart.fromMap(qs.docs.elementAt(index).data());
              cart.id = qs.docs.elementAt(index).id;
              //if (cart.cartItemList.length > 0) {
              //flag = true;
              return ActiveCartCard(
                isLoggedIn: true,
                cart: cart,
                user: user,
                icon: Icons.playlist_add_check,
              );
              //}
            },
          );
        } else {
          return Center(
            child: Text('No Active Cart'),
          );
        }
      },
    );
  }
}
