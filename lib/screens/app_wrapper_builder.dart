import 'package:GroceriesApplication/services/app_auth_service.dart';
import 'package:GroceriesApplication/services/app_firestore_service.dart';
import 'package:GroceriesApplication/services/cloudFirestore/app_store_service.dart';
import 'package:GroceriesApplication/services/storage/app_storage.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AppWrapperBuilder extends StatelessWidget {
  const AppWrapperBuilder({Key key, @required this.builder}) : super(key: key);
  final Widget Function(BuildContext, AsyncSnapshot<auth.User>) builder;
  @override
  Widget build(BuildContext context) {
    print('PuubWrapper rebuild');
    final authService = Provider.of<AppAuthService>(context, listen: false);
    return StreamBuilder<auth.User>(
      stream: authService.user,
      builder: (context, snapshot) {
        print('StreamBuilder: ${snapshot.connectionState}');
        final auth.User user = snapshot.data;

        if (user != null) {
          return MultiProvider(
            providers: [
              Provider<auth.User>.value(value: user),
              Provider<AppFirestoreService>(
                create: (_) => AppFirestoreService(uid: user.uid),
              ),
              Provider<AppStorage>(
                create: (_) => AppStorage(uid: user.uid),
              ),
              Provider<AppStoreService>(
                create: (_) => AppStoreService(uid: user.uid),
              ),
            ],
            child: builder(context, snapshot),
          );
        }
        return builder(context, snapshot);
      },
    );
  }
}
