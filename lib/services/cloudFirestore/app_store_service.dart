import 'package:GroceriesApplication/models/card.dart';
import 'package:GroceriesApplication/models/cart.dart';
import 'package:GroceriesApplication/models/product.dart';
import 'package:GroceriesApplication/models/release_order.dart';
import 'package:GroceriesApplication/models/store.dart';
import 'package:GroceriesApplication/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';

class AppStoreService {
  AppStoreService({@required this.uid}) : assert(uid != null);
  final String uid;

  Future<void> updateUser(User user) async {
    print('KKKKK2222222aaaaaa ' + uid);
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'cardList': [
          for (PaymentCard card in user.cardList)
            {
              'type': card.type,
              // 'cardNumber': card.cardNumber,
              'expMonthYear': card.expMonthYear,
              //'ownerName': card.ownerName,
              //'cvv': card.cvv,
            }
        ]
      });
    } catch (e) {
      print('Error ' + e.toString());
    }
  }

  Future<DocumentReference> addStore(Store store) async {
    return await FirebaseFirestore.instance
        .collection('stores')
        .add(store.toJson());
  }

  Stream<QuerySnapshot> getStore(String ownerUID) {
    return FirebaseFirestore.instance
        .collection('stores')
        .where('ownerUid', isEqualTo: ownerUID)
        .limit(1)
        .snapshots();
  }

  Stream<DocumentSnapshot> getStoreById(String storeId) {
    return FirebaseFirestore.instance
        .collection('stores')
        .doc(storeId)
        .snapshots();
  }

  Future<DocumentSnapshot> getStoreByIdFuture(String storeId) {
    return FirebaseFirestore.instance.collection('stores').doc(storeId).get();
  }

  Stream<DocumentSnapshot> getUserById(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots();
  }

  Stream<QuerySnapshot> getAllStore() {
    return FirebaseFirestore.instance.collection('stores').snapshots();
  }

  Stream<QuerySnapshot> getAllSpecificStore(String text) {
    return FirebaseFirestore.instance
        .collection('stores')
        .where(
          'storeName',
        )
        .snapshots();
  }

  Future<void> updateStore(Store store) async {
    return await FirebaseFirestore.instance
        .collection('stores')
        .doc(store.id)
        .update(store.toJson());
  }

  Future<DocumentReference> addProduct(Product product) async {
    return await FirebaseFirestore.instance
        .collection('products')
        .add(product.toJson());
  }

  Stream<DocumentSnapshot> getProduct(String productId) {
    return FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .snapshots();
  }

  Stream<QuerySnapshot> getOrders(String uid, String storeId) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: uid)
        .where('storeId', isEqualTo: storeId)
        .orderBy('creationTime', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getAllOrders(String uid) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: uid)
        .orderBy('creationTime', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getAllOrdersByStoreId(String storeId) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('storeId', isEqualTo: storeId)
        .where('status', whereIn: ['Created', 'Accepted', 'In Progress'])
        .orderBy('creationTime', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getCartDetails(String storeId) {
    return FirebaseFirestore.instance
        .collection('carts')
        .where('userId', isEqualTo: uid)
        .where('storeId', isEqualTo: storeId)
        .limit(1)
        .snapshots();
  }

  Stream<QuerySnapshot> getAllCartDetails() {
    return FirebaseFirestore.instance
        .collection('carts')
        .where('userId', isEqualTo: uid)
        .snapshots();
  }

  Stream<DocumentSnapshot> getCartProduct(DocumentReference docRef) {
    return docRef.get().asStream();
  }

  DocumentReference getProductDocumentReference(String productId) {
    print('productId' + productId);
    return FirebaseFirestore.instance.collection('products').doc(productId);
  }

  Future<bool> insertToCart(Cart cart) async {
    try {
      await FirebaseFirestore.instance.collection('carts').add(cart.toJson());
      return true;
    } catch (e) {
      print('AAAAerror ' + e.toString());
      return false;
    }
  }

  Future<DocumentReference> createOrder(ReleaseOrder order) async {
    try {
      return await FirebaseFirestore.instance
          .collection('orders')
          .add(order.toJson());
    } catch (e) {
      print('EEEEEerror ' + e.toString());
      return null;
    }
  }

  Future<DocumentSnapshot> getVendorAccount(String uid) async {
    try {
      return FirebaseFirestore.instance
          .collection('stripe_vendors')
          .doc(uid)
          .get();
    } catch (e) {
      print('EEEEEerror ' + e.toString());
    }
  }

  Future<DocumentReference> doPayment(double totalPrice, String paymentId,
      String owner, String orderID, String cartId) async {
    try {
      print('totalPricetotalPricetotalPricetotalPricetotalPrice '+totalPrice.toString());
      return await FirebaseFirestore.instance
          .collection('stripe_customers')
          .doc(uid)
          .collection('payments')
          .add({
        'amount': totalPrice,
        'currency': 'usd',
        'payment_method': paymentId,
        'owneruid': owner,
        'orderID': orderID,
        'cartID': cartId,
      });
    } catch (e) {
      print('EEEEEerror ' + e.toString());
      return null;
    }
  }

  Stream<DocumentSnapshot> getPaymentDetails(String paymentID) {
    return FirebaseFirestore.instance
        .collection('stripe_customers')
        .doc(uid)
        .collection('payments')
        .doc(paymentID)
        .snapshots();
  }

  Future<bool> updateOrders(ReleaseOrder releaseOrder) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(releaseOrder.id)
          .update(releaseOrder.toJson());
      return true;
    } catch (e) {
      print('FFFFerror ' + e.toString());
      return false;
    }
  }

  Future<bool> updateCart(Cart cart) async {
    print('REQ DOC ' + cart.id);
    try {
      await FirebaseFirestore.instance
          .collection('carts')
          .doc(cart.id)
          .update(cart.toJson());
      return true;
    } catch (e) {
      print('TTTTerror ' + e.toString());
      return false;
    }
  }

  Future<bool> pushItemToCart(int count, Cart cart) async {
    try {
      await FirebaseFirestore.instance
          .collection('carts')
          .doc(cart.id)
          .set(cart.toJson());
      return true;
    } catch (e) {
      print('CCCCerror ' + e.toString());
      return false;
    }
  }

  Stream<QuerySnapshot> getAllProduct(String ownerStoreID) {
    return FirebaseFirestore.instance
        .collection('products')
        .where('ownerStoreId', isEqualTo: ownerStoreID)
        .where('isActive', isEqualTo: true)
        .snapshots();
  }

  Stream<DocumentSnapshot> getAllCategory() {
    return FirebaseFirestore.instance
        .collection('admin')
        .doc('category')
        .snapshots();
  }

  Stream<QuerySnapshot> getBlockedProduct(String ownerStoreID) {
    return FirebaseFirestore.instance
        .collection('products')
        .where('ownerStoreId', isEqualTo: ownerStoreID)
        .where('isActive', isEqualTo: false)
        .snapshots();
  }

  Stream<DocumentSnapshot> getAccountLink() {
    return FirebaseFirestore.instance
        .collection('stripe_vendors')
        .doc(uid)
        .snapshots();
  }

  Stream<QuerySnapshot> getFullProduct(String ownerStoreID) {
    return FirebaseFirestore.instance
        .collection('products')
        .where('ownerStoreId', isEqualTo: ownerStoreID)
        .snapshots();
  }

  Future<void> deleteProduct(String id) {
    return FirebaseFirestore.instance.collection('products').doc(id).delete();
  }

  Future<void> deleteCart(Cart cart) {
    return FirebaseFirestore.instance.collection('carts').doc(cart.id).delete();
  }

  Future<void> removeProductFromCart(String cartId) {
    return FirebaseFirestore.instance.collection('carts').doc(cartId).delete();
  }

  Future<void> updateProduct(Product product) async {
    return await FirebaseFirestore.instance
        .collection('products')
        .doc(product.id)
        .update(product.toJson());
  }

  Future<void> updateSellerAccount() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({
      'createStripe': true,
    });
  }

  //Payment

  Future<void> addCard(PaymentMethod pm) async {
    return await FirebaseFirestore.instance
        .collection('stripe_customers')
        .doc(uid)
        .collection('payment_methods')
        .doc(pm.id)
        .set(pm.toJson());
  }
}
