import 'package:GroceriesApplication/screens/public/authenticate_screen.dart';
import 'package:GroceriesApplication/styles/styles.dart';
import 'package:GroceriesApplication/utility/route/app_slide_right_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class WelcomeScreen extends StatelessWidget {
  static String tag = 'welcome-page';
  WelcomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/welcomebg.png'),
                  fit: BoxFit.fill),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.08,
            left: MediaQuery.of(context).size.width * 0.25,
            right: MediaQuery.of(context).size.width * 0.25,
            child: Column(
              children: <Widget>[
                Image.asset('assets/images/grocery-logo.png'),
                Image.asset('assets/images/wc.png')
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: MediaQuery.of(context).size.width * 0.12,
            right: MediaQuery.of(context).size.width * 0.12,
            child: Container(
              alignment: Alignment.center,
              height: 140.0,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 25.0),
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 45.0,
                    decoration: BoxDecoration(
                      color: Color(0xFF0C0D0E),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: RawMaterialButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          AppSlideRightRoute(
                            page: AuthenticationScreen(
                              popupType: 'login',
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'LOGIN',
                        style: hintStylewhitetextPSB(),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 45.0,
                    decoration: BoxDecoration(
                        color: green,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: RawMaterialButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          AppSlideRightRoute(
                            page: AuthenticationScreen(
                              popupType: 'signup',
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'SIGN UP',
                        style: hintStylewhitetextPSB(),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
