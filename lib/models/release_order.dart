import 'package:cloud_firestore/cloud_firestore.dart';

class ReleaseOrder {
  String id;
  String userId;
  String storeId;
  double totalCost;
  String status;
  List<ReleaseOrderItem> orderItemList;
  DateTime creationTime;

  ReleaseOrder({
    this.id,
    this.userId,
    this.storeId,
    this.totalCost,
    this.status,
    this.orderItemList,
    this.creationTime,
  });

  factory ReleaseOrder.fromMap(Map<String, dynamic> data) {
    data = data ?? {};
    return ReleaseOrder(
      userId: data['userId'],
      storeId: data['storeId'],
      status: data['status'],
      creationTime:
          data['creationTime'] != null ? data['creationTime'].toDate() : null,
      orderItemList: data['ReleaseOrderItemList'] != null
          ? List<ReleaseOrderItem>.from(data['ReleaseOrderItemList'].map((e) {
              return ReleaseOrderItem.fromMap(e);
            }).toList())
          : null,
      totalCost: double.parse(data['totalCost'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonUser = new Map<String, dynamic>();
    jsonUser['userId'] = this.userId;
    jsonUser['storeId'] = this.storeId;
    jsonUser['status'] = this.status;
    jsonUser['creationTime'] = this.creationTime;
    jsonUser['ReleaseOrderItemList'] = this.orderItemList.map((e) {
      return e.toJson();
    }).toList();
    jsonUser['totalCost'] = this.totalCost;
    return jsonUser;
  }
}

class ReleaseOrderItem {
  final DocumentReference productReference;
  final int quantity;
  final String selectedUnit;
  final double price;
  ReleaseOrderItem({
    this.productReference,
    this.quantity,
    this.selectedUnit,
    this.price,
  });

  factory ReleaseOrderItem.fromMap(Map<String, dynamic> data) {
    data = data ?? {};
    return ReleaseOrderItem(
      quantity: data['quantity'],
      productReference: data['productReference'],
      price: double.parse(data['price'].toString()),
      selectedUnit: data['selectedUnit'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonUser = new Map<String, dynamic>();
    jsonUser['quantity'] = this.quantity;
    jsonUser['productReference'] = this.productReference;
    jsonUser['price'] = this.price;
    jsonUser['selectedUnit'] = this.selectedUnit;
    return jsonUser;
  }
}
