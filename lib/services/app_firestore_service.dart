import 'package:GroceriesApplication/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AppFirestoreService {
  final String uid;

  AppFirestoreService({this.uid});

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> addUser({@required User user}) async {
    try {
      await _firestore.collection('users').doc(uid).set(user.toJson());
      return true;
    } catch (e) {
      print('AAAAerror ' + e.toString());
      return false;
    }
  }

  Future<void> updateMessagingToken(String token, String uid) async {
    print('UID ' + uid);
    await _firestore.collection('users').doc(uid).update({'token': token});
  }

  doesUserExists({String email}) async {
    var _result = await _firestore
        .collection('users')
        .where('email', isEqualTo: email.trim())
        .limit(1)
        .get();
    if (_result.docs.length > 0) {
      return 'true';
    }
    return null;
  }

  Stream<User> get groceryAppHero {
    print('UIDDD ' + uid);
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snap) => User.fromMap(snap.data()));
  }
}
