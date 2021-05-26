import 'package:GroceriesApplication/styles/colors.dart';
import 'package:flutter/material.dart';

class GroceryTheme {
  GroceryTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColor.LIGHT_BACKGROUND_COLOR,
    primaryColor: AppColor.GREEN,
    primaryColorLight: AppColor.LIGHT_COLOR,
    primaryColorDark: AppColor.DARK_COLOR,
    accentColor: AppColor.LIGHT_BACKGROUND_COLOR,
    appBarTheme: AppBarTheme(
      color: AppColor.LIGHT_BACKGROUND_COLOR,
      elevation: 0,
      /*textTheme: TextTheme(
        headline6: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 30, color: WWColor.PRIMARY_COLOR),
      ),*/
    ),
    bottomAppBarTheme:
        BottomAppBarTheme(color: Colors.white10, elevation: 10.0),
    fontFamily: "Poppins",
    textTheme: TextTheme(
      
      headline6: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.normal,
        color: AppColor.BLACK,
        fontStyle: FontStyle.italic,
      ),
      subtitle2: TextStyle(
        fontSize: 14.0,
        fontStyle: FontStyle.normal,
        color: AppColor.BLACK,
        fontWeight: FontWeight.w400,
      ),


      headline1: TextStyle(
          //fontFamily: 'Poppins',
          fontWeight: FontWeight.normal,
          fontSize: 30,
          color: AppColor.BLACK),
      
      headline5: TextStyle(
        fontSize: 8.0,
        fontStyle: FontStyle.normal,
        color: AppColor.LIGHT_ON_CARD_COLOR_SHADOW,
      ),
      headline3: TextStyle(
        fontSize: 20.0,
        fontStyle: FontStyle.normal,
        color: AppColor.LIGN_ON_SECONDARY_COLOR,
      ),
      subtitle1: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        color: AppColor.LIGN_ON_SECONDARY_COLOR,
      ),
      bodyText1: TextStyle(
        fontSize: 14.0,
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
