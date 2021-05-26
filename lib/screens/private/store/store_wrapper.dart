import 'package:GroceriesApplication/models/cart.dart';
import 'package:GroceriesApplication/models/release_order.dart';
import 'package:GroceriesApplication/models/store.dart';
import 'package:GroceriesApplication/models/user.dart';
import 'package:GroceriesApplication/screens/private/store/store_cart.dart';
import 'package:GroceriesApplication/screens/private/store/store_help.dart';
import 'package:GroceriesApplication/screens/private/store/store_history.dart';
import 'package:GroceriesApplication/screens/private/store/store_shop.dart';
import 'package:GroceriesApplication/services/cloudFirestore/app_store_service.dart';
import 'package:GroceriesApplication/styles/styles.dart';
import 'package:GroceriesApplication/utility/data/grocery_data.dart';
import 'package:GroceriesApplication/widgets/bottom_nav_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreWrapper extends StatefulWidget {
  final Store store;
  final User user;
  final int index;
  StoreWrapper({
    this.store,
    this.user,
    this.index,
  });
  @override
  _StoreWrapperState createState() => _StoreWrapperState();
}

class _StoreWrapperState extends State<StoreWrapper> {
  int _currentIndex;

  @override
  void initState() {
    if (widget.index != null) {
      _currentIndex = widget.index;
    } else {
      _currentIndex = 0;
    }
    super.initState();
  }

  AppBar _getAppBar(BuildContext context) {
    final cloudStoreService =
        Provider.of<AppStoreService>(context, listen: false);
    return AppBar(
      title: Text(widget.store.storeName),
      centerTitle: true,
      actions: [
        GestureDetector(
          onTap: () {
            setState(() {
              _currentIndex = 1;
            });
          },
          child: Stack(
            fit: StackFit.loose,
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.shopping_cart,
                color: green,
              ),
              Positioned(
                top: 3,
                right: 0,
                child: StreamBuilder(
                    stream: cloudStoreService.getCartDetails(widget.store.id),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox.shrink();
                      }
                      QuerySnapshot qs = snapshot.data;
                      if (qs.docs.length > 0) {
                        Cart _cart = Cart.fromMap(qs.docs.first.data());
                        if (_cart.cartItemList.length > 0) {
                          return CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 10,
                            child: Text(
                              _cart.cartItemList.length.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      }
                      return SizedBox.shrink();
                    }),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Icon(
          Icons.phone,
          color: Colors.green,
        ),
        SizedBox(
          width: 10,
        ),
        Icon(
          Icons.feedback,
          color: Colors.grey,
        ),
        SizedBox(
          width: 10,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(context),
      body: _getStoreBody(context),
      bottomNavigationBar: _getBottomNavBar(context),
    );
  }

  Widget _getStoreBody(BuildContext context) {
    final cloudStoreService =
        Provider.of<AppStoreService>(context, listen: false);
    switch (_currentIndex) {
      case 0:
        return StoreSHop(
          store: widget.store,
          user: widget.user,
        );
        break;
      case 1:
        return StreamBuilder(
            stream: cloudStoreService.getCartDetails(widget.store.id),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              QuerySnapshot qs = snapshot.data;
              if (qs.docs.length > 0) {
                Cart _cart = Cart.fromMap(qs.docs.first.data());
                _cart.id = qs.docs.first.id;
                return StoreCart(
                  cart: _cart,
                  user: widget.user,
                );
              } else {
                return Center(
                  child: Text('Empty'),
                );
              }
            });
        break;
      case 2:
        print('UID=>' + widget.user.uid);
        print('StoreUID=>' + widget.store.id);
        return StreamBuilder(
          stream: cloudStoreService.getOrders(widget.user.uid, widget.store.id),
          builder: (context, snap) {
            if (!snap.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            QuerySnapshot qs = snap.data;
            if (qs.docs.length > 0) {
              print('LENGTH =>' + qs.docs.length.toString());
              List<ReleaseOrder> orderList = qs.docs.map((e) {
                print('DATA- '+e.data().toString());
                ReleaseOrder ro = ReleaseOrder.fromMap(e.data());
                ro.id = e.id;
                return ro;
              }).toList();
              return StoreHistory(
                releaseOrderList: orderList,
              );
            } else {
              return Center(
                child: Text('No History'),
              );
            }
          },
        );
        break;
      case 3:
        return StoreHelp();
        break;
      default:
        return StoreSHop();
    }
  }

  void resolveBodyIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _getBottomNavBar(BuildContext context) {
    return BottomNavWidget(
      rootSelectedIndex: _currentIndex,
      setViewForIndex: resolveBodyIndex,
      bottomNavbarData: GroceryData.bottomAppBarStoreItem,
    );
  }
}
