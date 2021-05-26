import 'package:GroceriesApplication/models/product.dart';
import 'package:GroceriesApplication/models/release_order.dart';
import 'package:GroceriesApplication/services/cloudFirestore/app_store_service.dart';
import 'package:GroceriesApplication/styles/styles.dart';
import 'package:GroceriesApplication/widgets/app_cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class OrderDetails extends StatefulWidget {
  final ReleaseOrder order;
  OrderDetails({
    this.order,
  });
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    final cloudStoreService =
        Provider.of<AppStoreService>(context, listen: false);
    return Container(
      child: Column(
        children: [
          for (ReleaseOrderItem relOrderItem in widget.order.orderItemList)
            _getOrderItem(context, relOrderItem),
          Divider(
            thickness: 3,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('Total: '),
                    Text(
                      '${widget.order.totalCost.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: "PoppinsMedium",
                        fontStyle: FontStyle.normal,
                        color: Colors.black,
                        letterSpacing: 0.3,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                (widget.order.status == 'In Progress' || widget.order.status == 'Created')
                    ? Row(
                        children: [
                          /*RaisedButton(
                            child:
                                Text("Reject?", style: hintStylewhitetextPSB()),
                            onPressed: () async {
                              ReleaseOrder rel = widget.order;
                              rel.status = 'Rejected';
                              cloudStoreService.updateOrders(rel);
                            },
                            color: red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),*/
                          SizedBox(
                            width: 10,
                          ),
                          RaisedButton(
                            child:
                                Text("Ready?", style: hintStylewhitetextPSB()),
                            onPressed: () async {
                              ReleaseOrder rel = widget.order;
                              rel.status = 'Ready';
                              cloudStoreService.updateOrders(rel);
                            },
                            color: green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ],
                      )
                    : widget.order.status == 'Accepted'
                        ? Row(
                            children: [
                              RaisedButton(
                                child: Text("Ready For Delivery?",
                                    style: hintStylewhitetextPSB()),
                                onPressed: () async {
                                  ReleaseOrder rel = widget.order;
                                  rel.status = 'Ready';
                                  cloudStoreService.updateOrders(rel);
                                },
                                color: red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          )
                        : widget.order.status == 'Ready'
                            ? Row(
                                children: [
                                  RaisedButton(
                                    child: Text("Delivered?",
                                        style: hintStylewhitetextPSB()),
                                    onPressed: () async {
                                      ReleaseOrder rel = widget.order;
                                      rel.status = 'Delivered';
                                      cloudStoreService.updateOrders(rel);
                                    },
                                    color: red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              )
                            : SizedBox.shrink(),
              ],
            ),
          ),
          Divider(
            thickness: 3,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _getOrderItem(BuildContext context, ReleaseOrderItem relOrderItem) {
    final cloudStoreService =
        Provider.of<AppStoreService>(context, listen: false);
    return StreamBuilder(
        stream: cloudStoreService.getCartProduct(relOrderItem.productReference),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox.shrink();
          }
          DocumentSnapshot ds = snapshot.data;
          Product prod = Product.fromMap(ds.data());
          prod.id = ds.id;
          return Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.grey,
                    ),
                    child: Image.network(
                      prod.productImageUrl.elementAt(0),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        prod.productName,
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
                              Text(
                                '${relOrderItem.quantity.toString()}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: "PoppinsMedium",
                                  fontStyle: FontStyle.normal,
                                  color: Colors.black,
                                  letterSpacing: 0.3,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              SizedBox(width: 15),
                              Container(
                                decoration: BoxDecoration(
                                  color: green,
                                  border: Border.all(
                                    color: green,
                                    style: BorderStyle.solid,
                                    width: 1,
                                  ),
                                ),
                                padding: EdgeInsets.all(2),
                                margin: EdgeInsets.only(right: 4),
                                child: Text(
                                  relOrderItem.selectedUnit,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'x',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontFamily: "PoppinsMedium",
                                  fontStyle: FontStyle.normal,
                                  color: Colors.black,
                                  letterSpacing: 0.3,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              SizedBox(width: 15),
                              Text(
                                '\$ ${relOrderItem.price.toStringAsFixed(2)}',
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
                        ],
                      ),
                      SizedBox(height: 15),
                      Text(
                        '\$ ${(relOrderItem.price * relOrderItem.quantity).toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.title,
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
