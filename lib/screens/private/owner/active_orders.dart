import 'package:GroceriesApplication/models/release_order.dart';
import 'package:GroceriesApplication/models/store.dart';
import 'package:GroceriesApplication/services/cloudFirestore/app_store_service.dart';
import 'package:GroceriesApplication/widgets/common_order_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ActiveOrders extends StatelessWidget {
  final Store store;
  ActiveOrders({
    this.store,
  });
  @override
  Widget build(BuildContext context) {
    final cloudStoreService =
        Provider.of<AppStoreService>(context, listen: false);
    return StreamBuilder<Object>(
      stream: cloudStoreService.getAllOrdersByStoreId(store.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        QuerySnapshot qs = snapshot.data;
        if (qs.docs.length > 0) {
          List<ReleaseOrder> releaseOrderList = qs.docs.map((e) {
            ReleaseOrder relOrder = ReleaseOrder.fromMap(e.data());
            relOrder.id = e.id;
            return relOrder;
          }).toList();
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: releaseOrderList.length,
            itemBuilder: (context, index) {
              return CommonOrderCard(
                isLoggedIn: true,
                order: releaseOrderList.elementAt(index),
                icon: Icons.more_vert,
              );
            },
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
