import 'package:GroceriesApplication/services/app_firestore_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class GroceryAppPushNotificationsService {
  String uid;
  GroceryAppPushNotificationsService._();

  factory GroceryAppPushNotificationsService() => _instance;

  static final GroceryAppPushNotificationsService _instance =
      GroceryAppPushNotificationsService._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;
  AppFirestoreService pServ = AppFirestoreService();
  String token1;

  Future<void> init(String uid) async {
    if (!_initialized) {
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure();
      String token = await _firebaseMessaging.getToken();
      token1 = token;
      print("FirebaseMessaging token: $token");
      await pServ.updateMessagingToken(token, uid);
      //_insert(token, "yyy ", "hhh");
      _initialized = true;
    }
  }

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    print('myBackgroundMessageHandler====');
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  Future<void> config(Function f, BuildContext context) async {
    print('jjjj');
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("KKKKonMessage:");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunchDDDD: $message");
        //_navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResumeFFFF: $message");
        //_navigateToItemDetail(message);
      },
    );
  }

  Future<void> _showItemDialog(
      BuildContext context, Map<String, dynamic> message) async {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Order Status"),
      content: Text(message['data']),
      actions: [
        okButton,
      ],
    );
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _navigateToItemDetail(Map<String, dynamic> message) {}
}
