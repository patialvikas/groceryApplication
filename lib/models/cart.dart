import 'package:GroceriesApplication/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  String id;
  String userId;
  String storeId;
  List<CartItem> cartItemList;
  double totalCost;
  Cart({
    this.id,
    this.userId,
    this.storeId,
    this.cartItemList,
    this.totalCost,
  });

  factory Cart.fromMap(Map<String, dynamic> data) {
    data = data ?? {};
    return Cart(
      userId: data['userId'],
      storeId: data['storeId'],
      cartItemList: data['cartItemList'] != null
          ? List<CartItem>.from(data['cartItemList'].map((e) {
              CartItem ci = CartItem.fromMap(e);
              return ci;
            }).toList())
          : null,
      totalCost: double.parse(data['totalCost'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonUser = new Map<String, dynamic>();
    jsonUser['userId'] = this.userId;
    jsonUser['storeId'] = this.storeId;
    jsonUser['cartItemList'] = this.cartItemList.map((e) {
      return e.toJson();
    }).toList();
    jsonUser['totalCost'] = this.totalCost;
    return jsonUser;
  }
}

class CartItem {
  int quantity;
  double finalCost;
  String selectedUnit;
  double itemCost;
  DocumentReference productDoc;
  CartItem({
    this.quantity,
    this.finalCost,
    this.selectedUnit,
    this.productDoc,
    this.itemCost,
  });

  factory CartItem.fromMap(Map<String, dynamic> data) {
    data = data ?? {};
    return CartItem(
      quantity: data['quantity'],
      productDoc: data['productDoc'],
      finalCost: data['finalCost'],
      itemCost: data['itemCost'],
      selectedUnit: data['selectedUnit'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonUser = new Map<String, dynamic>();
    jsonUser['quantity'] = this.quantity;
    jsonUser['productDoc'] = this.productDoc;
    jsonUser['finalCost'] = this.finalCost;
    jsonUser['itemCost'] = this.itemCost;
    jsonUser['selectedUnit'] = this.selectedUnit;
    return jsonUser;
  }
}
