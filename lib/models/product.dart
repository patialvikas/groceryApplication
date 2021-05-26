import 'package:GroceriesApplication/utility/validation/mapping.dart';

class Product {
  String id;
  String productName;
  String productDescription;
  String quantity;
  List<String> productImageUrl;
  String ownerStoreId;
  bool isActive;
  String category;
  Map<String, double> unitPriceComb;

  Product({
    this.id,
    this.productName,
    this.productDescription,
    this.productImageUrl,
    this.ownerStoreId,
    this.isActive,
    this.category,
    this.unitPriceComb,
    this.quantity,
  });

  factory Product.fromMap(Map<dynamic, dynamic> data) {
    data = data ?? {};
    return Product(
      productName: data['productName'],
      productDescription: data['productDescription'],
      productImageUrl: List<String>.from(data['productImageUrl']),
      ownerStoreId: data['ownerStoreId'],
      quantity: data['quantity'],
      category: data['category'] ?? '',
      isActive: data['isActive'],
      unitPriceComb: Mapping.getMap(data['unitPriceComb']),
    );
  }

  

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonUser = new Map<String, dynamic>();
    jsonUser['productName'] = this.productName.trim();
    jsonUser['productDescription'] = this.productDescription.trim();
    jsonUser['productImageUrl'] = this.productImageUrl;
    jsonUser['isActive'] = this.isActive;
    jsonUser['ownerStoreId'] = this.ownerStoreId;
    jsonUser['quantity'] = this.quantity;
    jsonUser['category'] = this.category;
    jsonUser['unitPriceComb'] = this.unitPriceComb;
    return jsonUser;
  }
}
