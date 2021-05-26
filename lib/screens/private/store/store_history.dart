import 'package:GroceriesApplication/models/release_order.dart';
import 'package:GroceriesApplication/widgets/common_order_card.dart';
import 'package:GroceriesApplication/widgets/user_common_order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StoreHistory extends StatelessWidget {
  final List<ReleaseOrder> releaseOrderList; 
  StoreHistory({
    this.releaseOrderList,
  });
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: releaseOrderList.length,
      itemBuilder: (context, index) {
        return UserCommonOrder(
          isLoggedIn: true,
          order: releaseOrderList.elementAt(index),
          icon: Icons.more_vert,
        );
      },
    );
  }
}
