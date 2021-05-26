import 'package:GroceriesApplication/screens/app_wrapper.dart';
import 'package:GroceriesApplication/screens/app_wrapper_builder.dart';
import 'package:GroceriesApplication/services/app_auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppAuthService>(
          create: (_) => AppAuthService(),
        ),
      ],
      child: AppWrapperBuilder(
        builder: (context, userSnapshot) {
          return MaterialApp(
            theme: ThemeData(
              primaryColor: Colors.white,
              cursorColor: Colors.black,
              unselectedWidgetColor: Colors.blue,
            ),
            home: AppWrapper(userSnapshot: userSnapshot),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
