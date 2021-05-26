import 'package:GroceriesApplication/models/product.dart';
import 'package:GroceriesApplication/models/release_order.dart';
import 'package:GroceriesApplication/models/store.dart';
import 'package:GroceriesApplication/models/user.dart';
import 'package:GroceriesApplication/screens/private/buyer/active_cart.dart';
import 'package:GroceriesApplication/screens/private/buyer/buyer_home.dart';
import 'package:GroceriesApplication/screens/private/buyer/user_orders.dart';
import 'package:GroceriesApplication/screens/private/owner/active_orders.dart';
import 'package:GroceriesApplication/screens/private/owner/add_product.dart';
import 'package:GroceriesApplication/screens/private/owner/add_store.dart';
import 'package:GroceriesApplication/screens/private/owner/home_screen.dart';
import 'package:GroceriesApplication/screens/private/owner/owner_setting.dart';
import 'package:GroceriesApplication/services/app_auth_service.dart';
import 'package:GroceriesApplication/services/cloudFirestore/app_store_service.dart';
import 'package:GroceriesApplication/services/notification/grocery_app_push_notification_service.dart';
import 'package:GroceriesApplication/utility/data/grocery_data.dart';
import 'package:GroceriesApplication/widgets/bottom_nav_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class HomeWrapper extends StatefulWidget {
  final User user;
  HomeWrapper({this.user});

  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  int _currentIndex;
  Product _product;
  GroceryAppPushNotificationsService notificationService =
      new GroceryAppPushNotificationsService();

  @override
  void initState() {
    notificationService.init(widget.user.uid);
    _currentIndex = 0;
    super.initState();
  }

  void _gotoAddStore() {
    setState(() {
      _currentIndex = 1;
    });
  }

  void _gotoAddProduct(Product prod) {
    setState(() {
      _product = prod;
      //_throughEdit = true;
      _currentIndex = 2;
    });
  }

  Widget _getOwnerBody(BuildContext context) {
    final cloudStoreService =
        Provider.of<AppStoreService>(context, listen: false);
    switch (_currentIndex) {
      case 0:
        return SafeArea(
          child: HomeScreen(
            user: widget.user,
            gotoAddStore: _gotoAddStore,
            gotoAddProduct: _gotoAddProduct,
          ),
        );
        break;
      case 1:
        return AddStore(
          user: widget.user,
        );
        break;
      case 2:
        return StreamBuilder(
          stream: cloudStoreService.getStore(widget.user.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final QuerySnapshot qs = snapshot.data;
              Store store;
              if (qs.docs.length > 0) {
                store = Store.fromMap(qs.docs.first.data());
                store.id = qs.docs.first.id;
                if (_product != null) {
                  return StreamBuilder(
                    stream: cloudStoreService.getProduct(_product.id),
                    builder: (context, snap) {
                      if (!snap.hasData) {
                        return SizedBox.shrink();
                      }
                      DocumentSnapshot ds = snap.data;
                      Product prod = Product.fromMap(ds.data());
                      prod.id = ds.id;
                      return AddProduct(
                        user: widget.user,
                        store: store,
                        editProduct: prod,
                      );
                    },
                  );
                } else {
                  return AddProduct(
                    user: widget.user,
                    store: store,
                    editProduct: _product,
                  );
                }
              }
              return Center(
                child: Text('Before adding product, you need to add a store.'),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        );
        break;
      case 3:
        return StreamBuilder(
          stream: cloudStoreService.getStore(widget.user.uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            QuerySnapshot qs = snapshot.data;
            if (qs.docs.length > 0) {
              Store store = Store.fromMap(qs.docs.first.data());
              store.id = qs.docs.first.id;
              return ActiveOrders(
                store: store,
              );
            } else {
              return Center(
                child: Text('No Orders'),
              );
            }
          },
        );
        break;
      case 4:
        return OwnerSetting();
        break;
      default:
        return HomeScreen();
    }
  }

  Widget _getCustomerBody(BuildContext context) {
    final cloudStoreService =
        Provider.of<AppStoreService>(context, listen: false);
    switch (_currentIndex) {
      case 0:
        return BuyerHome(
          user: widget.user,
        );
        break;
      case 1:
        return ActiveCart(
          user: widget.user,
        );
        break;
      case 2:
        return StreamBuilder(
          stream: cloudStoreService.getAllOrders(widget.user.uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            QuerySnapshot qs = snapshot.data;
            if (qs.docs.length > 0) {
              List<ReleaseOrder> orderList = qs.docs.map((e) {
                ReleaseOrder ro = ReleaseOrder.fromMap(e.data());
                ro.id = e.id;
                return ro;
              }).toList();
              return UserOrders(
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
        return OwnerSetting(
          user: widget.user,
        );
        break;
      default:
        return BuyerHome();
    }
  }

  Widget _getBody(BuildContext context) {
    if (widget.user.type == 'Selling') {
      return _getOwnerBody(context);
    } else if (widget.user.type == 'Buying') {
      return _getCustomerBody(context);
    } else {
      return Column(
        children: [
          Text(
            'You are neither a customer nor an owner, how you came here?',
          ),
          RaisedButton(
            child: Text('SignOut'),
            onPressed: () async {
              AppAuthService _authService = AppAuthService();
              await _authService.signOut();
            },
          ),
        ],
      );
    }
  }

  AppBar _getOwnerAppBar(BuildContext context) {
    switch (_currentIndex) {
      case 0:
        return null;
        break;
      default:
        return AppBar(
          title: Text('Grocery App'),
        );
    }
  }

  AppBar _getUserAppBar(BuildContext context) {
    return AppBar(
      title: Text('User App'),
    );
  }

  AppBar _getAppBar(BuildContext context) {
    if (widget.user.type == 'Selling') {
      return _getOwnerAppBar(context);
    } else if (widget.user.type == 'Buying') {
      return _getUserAppBar(context);
    } else {
      return AppBar(
        title: Text('No Way'),
      );
    }
  }

  void gotPushMessges(String title, String msgSource) {
    print('GGG BRB ' + msgSource);
  }

  @override
  Widget build(BuildContext context) {
    notificationService.config(gotPushMessges, context);
    return Scaffold(
      appBar: _getAppBar(context),
      body: _getBody(context),
      bottomNavigationBar: _getBottomNavBar(context),
    );
  }

  void resolveBodyIndex(int index) {
    setState(() {
      _product = null;
      _currentIndex = index;
    });
  }

  Widget _getUserBottomNav(BuildContext context) {
    return BottomNavWidget(
      rootSelectedIndex: _currentIndex,
      setViewForIndex: resolveBodyIndex,
      bottomNavbarData: GroceryData.bottomAppBarItemForUser,
    );
  }

  Widget _getOwnerBottomNav(BuildContext context) {
    return BottomNavWidget(
      rootSelectedIndex: _currentIndex,
      setViewForIndex: resolveBodyIndex,
      bottomNavbarData: GroceryData.bottomAppBarItem,
    );
  }

  Widget _getBottomNavBar(BuildContext context) {
    if (widget.user.type == 'Selling') {
      return _getOwnerBottomNav(context);
    } else if (widget.user.type == 'Buying') {
      return _getUserBottomNav(context);
    } else {
      return null;
    }
  }
}
