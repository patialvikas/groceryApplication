import 'dart:collection';

import 'package:GroceriesApplication/models/cart.dart';
import 'package:GroceriesApplication/models/product.dart';
import 'package:GroceriesApplication/models/user.dart';
import 'package:GroceriesApplication/services/cloudFirestore/app_store_service.dart';
import 'package:GroceriesApplication/styles/styles.dart';
import 'package:GroceriesApplication/widgets/card_payment.dart';
import 'package:GroceriesApplication/widgets/cart_card.dart';
import 'package:GroceriesApplication/widgets/delivery_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreCart extends StatefulWidget {
  final Cart cart;
  final User user;
  StoreCart({
    this.cart,
    this.user,
  });
  @override
  _StoreCartState createState() => _StoreCartState();
}

class _StoreCartState extends State<StoreCart> {
  bool _isCheckoutClicked = false;
  double _totalCost;
  Cart mainCart;
  int pageCount;
  PageController _pageController = PageController(
    initialPage: 1,
  );

  Map<int, double> costMap;

  @override
  void initState() {
    _totalCost = widget.cart.totalCost;
    pageCount = 1;
    costMap = HashMap<int, double>();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  double _getTotalCost() {
    double cost = 0.0;
    for (MapEntry mapEntry in costMap.entries) {
      cost += mapEntry.value;
    }
    return cost;
  }

  double totCost = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: PageView.builder(
        itemBuilder: (context, position) {
          if (position == 0) {
            return _getCartContainer(context);
          } else if (position == 1) {
            return DeliveryDetails(
              storeId: widget.cart.storeId,
              cart: widget.cart,
              user: widget.user,
            );
          } else {
            return SizedBox.shrink();
          }
        },
        itemCount: pageCount,
        controller: _pageController,
      ),
    );
  }

  Widget _getCartContainer(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              itemCount: widget.cart.cartItemList.length,
              itemBuilder: (ctx, i) {
                return _getCartCard(context,
                    widget.cart.cartItemList.elementAt(i), i, widget.cart);
              },
            ),
          ),
          Divider(),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("TOTAL", style: Theme.of(context).textTheme.subtitle),
                    Text("\$ " + widget.cart.totalCost.toStringAsFixed(2),
                        style: Theme.of(context).textTheme.headline),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  height: 50,
                  child: RaisedButton(
                    child: Text("CHECKOUT", style: hintStylewhitetextPSB()),
                    onPressed: widget.cart.totalCost <= 0
                        ? null
                        : () async {
                            setState(() {
                              pageCount = 2;
                            });
                            await _pageController.nextPage(
                              duration: Duration(seconds: 1),
                              curve: Curves.easeInOut,
                            );
                          },
                    color: green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  String _selectedUnit;
  double _price;
  int _count;
  Widget _getCartCard(
      BuildContext context, CartItem cart, int i, Cart cartRoot) {
    final cloudStoreService =
        Provider.of<AppStoreService>(context, listen: false);
    totCost += cart.finalCost;
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 5,
      shadowColor: Color.fromRGBO(105, 105, 105, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        color: Colors.grey,
        child: StreamBuilder(
          stream: cloudStoreService.getCartProduct(cart.productDoc),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                margin: EdgeInsets.only(
                  top: 20,
                  bottom: 20,
                ),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            DocumentSnapshot ds = snapshot.data;
            Product p = Product.fromMap(ds.data());
            p.id = ds.id;
            return CartCard(
              product: p,
              quantity: cart.quantity.toInt(),
              cart: cartRoot,
              price: cart.itemCost,
              selectedUnit: cart.selectedUnit,
            );
          },
        ),
      ),
    );
  }
}
