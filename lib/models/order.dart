import 'package:GroceriesApplication/models/product.dart';

class Order {
  String id;
  String orderOriginatorName;
  String orderOriginatorAddress;
  Map<Product, double> orderList;
  double totalPrice;
  String status;
  DateTime expectedDeliveryDate;

  Order({
    this.id,
    this.orderOriginatorName,
    this.orderOriginatorAddress,
    this.orderList,
    this.totalPrice,
    this.status,
    this.expectedDeliveryDate,
  });

  factory Order.fromMap(Map<dynamic, dynamic> data) {
    data = data ?? {};
    return Order(
      orderOriginatorName: data['orderOriginatorName'],
      orderOriginatorAddress: data['orderOriginatorAddress'],
      orderList: data['orderList'],
      totalPrice: double.parse(data['totalPrice']),
      status: data['status'],
      expectedDeliveryDate: data['expectedDeliveryDate'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonUser = new Map<String, dynamic>();
    jsonUser['orderOriginatorName'] = this.orderOriginatorName;
    jsonUser['orderOriginatorAddress'] = this.orderOriginatorAddress;
    jsonUser['orderList'] = this.orderList;
    jsonUser['totalPrice'] = this.totalPrice;
    jsonUser['status'] = this.status;
    jsonUser['expectedDeliveryDate'] = this.expectedDeliveryDate;
    return jsonUser;
  }
}
