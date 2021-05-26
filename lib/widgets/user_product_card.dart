import 'package:GroceriesApplication/models/cart.dart';
import 'package:GroceriesApplication/models/product.dart';
import 'package:GroceriesApplication/models/store.dart';
import 'package:GroceriesApplication/models/user.dart';
import 'package:GroceriesApplication/services/cloudFirestore/app_store_service.dart';
import 'package:GroceriesApplication/styles/styles.dart';
import 'package:GroceriesApplication/widgets/app_cached_network_image.dart';
import 'package:GroceriesApplication/widgets/app_counter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProductCard extends StatefulWidget {
  final Product product;
  final bool isLoggedIn;
  final Store store;
  final User user;

  UserProductCard({
    this.product,
    this.isLoggedIn,
    this.store,
    this.user,
  });
  @override
  _UserProductCardState createState() => _UserProductCardState();
}

class _UserProductCardState extends State<UserProductCard> {
  String _selectedUnit;
  double _price;
  int _count;

  @override
  void initState() {
    //print('Product '+widget.product.productName);
    _selectedUnit = widget.product.unitPriceComb.keys.first;
    //print('_selectedUnit '+_selectedUnit);
    _price = widget.product.unitPriceComb.values.first;
    _count = 0;
    super.initState();
  }

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
            print('Hit Card');
          },
          child: _getProductCard(context),
        ),
      ),
    );
  }

  Widget _getProductCard(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.33,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: AppCachedNetworkImage(
                imageURL: widget.product.productImageUrl.elementAt(0),
              ),
            ),
          ),
          _getFooter(context),
        ],
      ),
    );
  }

  Widget _getFooter(BuildContext context) {
    final cloudStoreService =
        Provider.of<AppStoreService>(context, listen: false);
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.product.productName,
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: "PoppinsMedium",
                fontStyle: FontStyle.normal,
                color: Colors.black,
                letterSpacing: 0.4,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.product.productDescription,
              style: TextStyle(
                fontSize: 12.0,
                fontFamily: "PoppinsMedium",
                fontStyle: FontStyle.normal,
                color: Colors.black45,
                letterSpacing: 0.3,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          SizedBox(
            height: 2,
          ),
          StreamBuilder(
              stream: cloudStoreService.getCartDetails(widget.store.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox.shrink();
                }
                QuerySnapshot qs = snapshot.data;
                Cart cart;
                if (qs.docs.length > 0) {
                  DocumentSnapshot ds = qs.docs.first;
                  cart = Cart.fromMap(ds.data());
                  cart.id = ds.id;
                  for (CartItem ci in cart.cartItemList) {
                    if (ci.productDoc.id == widget.product.id) {
                      _selectedUnit = ci.selectedUnit;
                      _price = ci.itemCost;
                    }
                  }
                } else {
                  cart = null;
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        for (MapEntry mapEntry
                            in widget.product.unitPriceComb.entries)
                          GestureDetector(
                            onTap: () async {
                              print('GGGGGGG '+_count.toString());
                              if (_count == 0) {
                                setState(() {
                                  _selectedUnit = mapEntry.key;
                                  _price = mapEntry.value;
                                });
                              } else if (cart != null) {
                                for (CartItem ci in cart.cartItemList) {
                                  if (ci.productDoc.id == widget.product.id) {
                                    ci.selectedUnit = mapEntry.key;
                                    ci.itemCost = mapEntry.value;
                                    ci.finalCost = ci.itemCost * ci.quantity;
                                    _selectedUnit = ci.selectedUnit;
                                    _price = ci.itemCost;
                                    print('cicicici ' + ci.toJson().toString());
                                    await _pushItemToCart(cart);
                                    break;
                                  }
                                }
                              }
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
                      '\$ ' + _price.toStringAsFixed(2),
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
                );
              }),
          SizedBox(
            height: 2,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StreamBuilder(
                  stream: cloudStoreService.getCartDetails(widget.store.id),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return SizedBox.shrink();
                    }
                    QuerySnapshot qs = snapshot.data;
                    if (qs.docs.length > 0) {
                      DocumentSnapshot ds = qs.docs.first;
                      Cart cart = Cart.fromMap(ds.data());
                      cart.id = ds.id;
                      print('ID=>' + cart.id);
                      int ccount = 0;
                      for (CartItem ci in cart.cartItemList) {
                        if (ci.productDoc.id == widget.product.id) {
                          _count = ccount = ci.quantity;
                          break;
                        }
                      }
                      return AppCounter(
                        count: ccount,
                        increaseCounter: (int counter) async {
                          if (counter == 0) {
                            return;
                          }
                          _increaseCount(counter);
                          await _pushItemToCart(cart);
                        },
                      );
                    } else {
                      return AppCounter(
                        count: _count,
                        increaseCounter: (int counter) async {
                          if (counter == 0) {
                            return;
                          }
                          _increaseCount(counter);
                          CartItem _item = CartItem(
                            productDoc: cloudStoreService
                                .getProductDocumentReference(widget.product.id),
                            quantity: _count,
                            finalCost: _price * _count,
                            itemCost: _price,
                            selectedUnit: _selectedUnit,
                          );
                          List<CartItem> _itemList = new List<CartItem>();
                          _itemList.add(_item);
                          Cart _cart = Cart(
                            userId: widget.user.uid,
                            storeId: widget.store.id,
                            totalCost: _price * _count,
                            cartItemList: _itemList,
                          );
                          await cloudStoreService.insertToCart(_cart);
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pushItemToCart(Cart cart) async {
    final cloudStoreService =
        Provider.of<AppStoreService>(context, listen: false);
    DocumentReference dr =
        cloudStoreService.getProductDocumentReference(widget.product.id);
    bool flag = false;
    double _totCost = 0.0;
    for (CartItem item in cart.cartItemList) {
      if (dr.id == item.productDoc.id) {
        item.quantity = _count;
        item.finalCost = _count * _price;
        item.itemCost = _price;
        item.selectedUnit = _selectedUnit;
        _totCost += _count * _price;
        flag = true;
        //break;
      }
    }

    if (!flag) {
      CartItem item = CartItem(
        productDoc: dr,
        quantity: _count,
        finalCost: _count * _price,
        itemCost: _price,
        selectedUnit: _selectedUnit,
      );
      cart.cartItemList.add(item);
      cart.totalCost += _count * _price;
    } else {
      cart.totalCost = _totCost;
    }
    final bool _isSuccess =
        await cloudStoreService.pushItemToCart(_count, cart);
  }

  void _increaseCount(int counter) {
    setState(() {
      _count = counter;
    });
  }
}
