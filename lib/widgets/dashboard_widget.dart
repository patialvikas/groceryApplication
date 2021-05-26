import 'package:GroceriesApplication/models/product.dart';
import 'package:GroceriesApplication/models/store.dart';
import 'package:GroceriesApplication/services/cloudFirestore/app_store_service.dart';
import 'package:GroceriesApplication/styles/styles.dart';
import 'package:GroceriesApplication/utility/data/grocery_data.dart';
import 'package:GroceriesApplication/widgets/app_flat_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class DashboardWidget extends StatefulWidget {
  final String uid;
  DashboardWidget({this.uid});
  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

String _getMonthString(int month) {
  switch (month) {
    case DateTime.january:
      return 'Jan';
      break;
    case DateTime.february:
      return 'Feb';
      break;
    case DateTime.march:
      return 'Mar';
      break;
    case DateTime.april:
      return 'Apr';
      break;
    case DateTime.may:
      return 'May';
      break;
    case DateTime.june:
      return 'Jun';
      break;
    case DateTime.july:
      return 'July';
      break;
    case DateTime.august:
      return 'Aug';
      break;
    case DateTime.september:
      return 'Sept';
      break;
    case DateTime.october:
      return 'Oct';
      break;
    case DateTime.november:
      return 'Nov';
      break;
    case DateTime.december:
      return 'Dec';
      break;
    default:
  }
}

class _DashboardWidgetState extends State<DashboardWidget> {
  Widget _getDashboardComponent(
      BuildContext context, int storeCo, int activeCo, int inActiveCo) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          for (Map map in GroceryData.homeDashboardData)
            _getHomeDashboardItem(
                map['label'] == 'Store(s)'
                    ? storeCo.toString()
                    : map['label'] == 'Active\nProduct(s)'
                        ? activeCo.toString()
                        : inActiveCo.toString(),
                map['label'],
                map['backgroundColor'],
                map['textColor']),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cloudStoreService =
        Provider.of<AppStoreService>(context, listen: false);
    return Container(
      color: orange,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: "PoppinsMedium",
                    fontStyle: FontStyle.normal,
                    color: Colors.black,
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  DateTime.now().day.toString() +
                      ' ' +
                      _getMonthString(DateTime.now().month) +
                      ', ' +
                      DateTime.now().year.toString(),
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
          ),
          Expanded(
            child: StreamBuilder(
                stream: cloudStoreService.getStore(widget.uid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  int activeProduct = 0;
                  int inActiveProduct = 0;
                  int storeCount = 0;

                  final QuerySnapshot qs = snapshot.data;
                  Store store;
                  if (qs.docs.length > 0) {
                    storeCount = qs.docs.length;
                    store = Store.fromMap(qs.docs.first.data());
                    store.id = qs.docs.first.id;
                    return StreamBuilder(
                      stream: cloudStoreService.getFullProduct(store.id),
                      builder: (context, snapshot2) {
                        if (!snapshot2.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final QuerySnapshot qs2 = snapshot2.data;

                        if (qs2.docs.length > 0) {
                          Product product;
                          activeProduct = inActiveProduct = 0;
                          for (int i = 0; i < qs2.docs.length; i++) {
                            product = Product.fromMap(qs2.docs[i].data());
                            product.id = qs2.docs[i].id;
                            if (product.isActive) {
                              ++activeProduct;
                            } else {
                              ++inActiveProduct;
                            }
                          }
                        }
                        return _getDashboardComponent(context, storeCount,
                            activeProduct, inActiveProduct);
                      },
                    );
                  }
                  return _getDashboardComponent(
                      context, storeCount, activeProduct, inActiveProduct);
                }),
          ),
        ],
      ),
    );
  }

  Widget _getHomeDashboardItem(
      String count, String label, Color backgroundColor, Color textColor) {
    return Column(
      children: <Widget>[
        Flexible(
          child: AppFlatButton(
            data: count,
            backgroundColor: backgroundColor,
            textColor: textColor,
          ),
        ),
        Flexible(
            child: Text(
          '$label',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.0,
            fontFamily: "PoppinsMedium",
            fontStyle: FontStyle.normal,
            color: Colors.black,
            letterSpacing: 0.1,
            fontWeight: FontWeight.w400,
          ),
        )),
      ],
    );
  }
}
