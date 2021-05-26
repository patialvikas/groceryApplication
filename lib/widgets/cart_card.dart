import 'package:GroceriesApplication/models/cart.dart';
import 'package:GroceriesApplication/models/product.dart';
import 'package:GroceriesApplication/services/cloudFirestore/app_store_service.dart';
import 'package:GroceriesApplication/styles/styles.dart';
import 'package:GroceriesApplication/widgets/app_counter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class CartCard extends StatefulWidget {
  final Product product;
  final int quantity;
  final Cart cart;
  final String selectedUnit;
  final double price;
  CartCard({
    this.product,
    this.quantity,
    this.cart,
    this.selectedUnit,
    this.price,
  });
  @override
  _CartCardState createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  String _selectedUnit;
  double _price;
  int count;
  @override
  void initState() {
    _selectedUnit = widget.selectedUnit;
    _price = widget.price;
    count = widget.quantity;

    super.initState();
    //widget.addToTotal(count*_price);
  }

  Future<void> _pushItemToCart() async {
    Cart cart = widget.cart;
    final cloudStoreService =
        Provider.of<AppStoreService>(context, listen: false);
    DocumentReference dr =
        cloudStoreService.getProductDocumentReference(widget.product.id);
    bool flag = false;
    double _totCost = 0.0;
    for (CartItem item in cart.cartItemList) {
      if (dr.id == item.productDoc.id) {
        item.quantity = count;
        item.finalCost = count * _price;
        item.selectedUnit = _selectedUnit;
        _totCost += count * _price;
        flag = true;
        //break;
      } else {
        _totCost += item.finalCost;
      }
    }

    if (!flag) {
      CartItem item = CartItem(
        productDoc: dr,
        quantity: count,
        finalCost: count * _price,
        selectedUnit: _selectedUnit,
      );
      cart.cartItemList.add(item);
      _totCost += count * _price;
    }
    cart.totalCost = _totCost;
    final bool _isSuccess = await cloudStoreService.pushItemToCart(count, cart);
  }

  void _increaseCounter(int currentCounter) {
    double _cost;
    setState(() {
      count = currentCounter;
      _cost = count * _price;
    });
    _pushItemToCart();
    //widget.addToTotal(_cost);
  }

  @override
  Widget build(BuildContext context) {
    final cloudStoreService =
        Provider.of<AppStoreService>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.grey,
              ),
              child: Image.network(
                widget.product.productImageUrl.elementAt(0),
                fit: BoxFit.fill,
                width: 120,
                height: 120,
              ),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.product.productName,
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        for (MapEntry mapEntry
                            in widget.product.unitPriceComb.entries)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedUnit = mapEntry.key;
                                _price = mapEntry.value;
                              });
                              _pushItemToCart();
                              //widget.addToTotal(count * _price);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: mapEntry.key == _selectedUnit
                                    ? green
                                    : Colors.transparent,
                                border: Border.all(
                                  color: green,
                                  style: BorderStyle.solid,
                                  width: 1,
                                ),
                              ),
                              padding: EdgeInsets.all(2),
                              margin: EdgeInsets.only(right: 4),
                              child: Text(
                                mapEntry.key,
                                style: TextStyle(
                                  color: mapEntry.key == _selectedUnit
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Text(
                      '\$ ' + _price.toString(),
                      style: TextStyle(
                        fontSize: 13.0,
                        fontFamily: "PoppinsMedium",
                        fontStyle: FontStyle.normal,
                        color: Colors.black,
                        letterSpacing: 0.3,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppCounter(
                      count: widget.quantity.toInt(),
                      increaseCounter: _increaseCounter,
                    ),
                    Wrap(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            Cart _cart = widget.cart;
                            List<CartItem> _list = _cart.cartItemList;
                            int index;
                            double totC = 0.0;
                            for (int i = 0; i < _list.length; i++) {
                              if (_list.elementAt(i).productDoc.id ==
                                  widget.product.id) {
                                index = i;
                              } else {
                                totC += _list.elementAt(i).finalCost;
                              }
                            }
                            _list.removeAt(index);
                            _cart.cartItemList = _list;
                            _cart.totalCost = totC;
                            await cloudStoreService.updateCart(_cart);
                          },
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(height: 15),
                Text(
                  '\$ ' + (_price * count).toStringAsFixed(2),
                  style: Theme.of(context).textTheme.title,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
