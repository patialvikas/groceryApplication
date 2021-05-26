import 'package:GroceriesApplication/models/release_order.dart';
import 'package:GroceriesApplication/widgets/user_common_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class UserOrders extends StatelessWidget {
  final List<ReleaseOrder> releaseOrderList;
  UserOrders({
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
