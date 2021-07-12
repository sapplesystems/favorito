import 'package:Favorito/myCss.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';

String fontfamily = 'Gilroy-Regular';

class MyTheme {
  ThemeData themeDataDark = ThemeData(
      fontFamily: fontfamily,
      appBarTheme: AppBarTheme(
          shadowColor: myRed,
          foregroundColor: myRed,
          color: myBackGround,
          textTheme: TextTheme(
              headline1: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                  letterSpacing: 1.2,
                  fontFamily: 'Gilroy-ExtraBold',
                  color: Colors.black))),
      textTheme: TextTheme(
          headline1:
              TextStyle(fontFamily: 'Gilroy-ExtraBold', color: Colors.white),
          headline2: TextStyle(fontFamily: 'Gilroy-Heavy', color: Colors.white),
          headline3: TextStyle(fontFamily: 'Gilroy-Bold', color: Colors.white),
          headline4:
              TextStyle(fontFamily: 'Gilroy-Medium', color: Colors.white),
          headline5:
              TextStyle(fontFamily: 'Gilroy-Regular', color: Colors.white),
          headline6:
              TextStyle(fontFamily: 'Gilroy-Light', color: Colors.white)),
      primaryColor: myRed,
      accentColor: myRedLight,
      cardTheme: CardTheme(shape: roundedRectangleBorder, elevation: 2),
      iconTheme: IconThemeData(color: Colors.white),
      scaffoldBackgroundColor: myBackGround,
      bottomAppBarColor: Colors.white,
      bottomAppBarTheme: BottomAppBarTheme(color: myBackGround, elevation: 10),
      primarySwatch: Colors.red,
      visualDensity: VisualDensity.adaptivePlatformDensity);

  ThemeData themeDataLight = ThemeData(
      fontFamily: fontfamily,
      textTheme: TextTheme(
          headline1:
              TextStyle(fontFamily: 'Gilroy-ExtraBold', color: Colors.black),
          headline2: TextStyle(fontFamily: 'Gilroy-Heavy', color: Colors.black),
          headline3: TextStyle(fontFamily: 'Gilroy-Bold', color: Colors.black),
          headline4:
              TextStyle(fontFamily: 'Gilroy-Medium', color: Colors.black),
          headline5:
              TextStyle(fontFamily: 'Gilroy-Regular', color: Colors.black),
          headline6:
              TextStyle(fontFamily: 'Gilroy-Light', color: Colors.black)),
      primaryColor: myRed,
      accentColor: myRedLight,
      appBarTheme: AppBarTheme(
          textTheme: TextTheme(
              headline1: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                  letterSpacing: 1.2,
                  fontFamily: 'Gilroy-ExtraBold',
                  color: Colors.black)),
          color: myBackGround,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black)),
      cardTheme: CardTheme(shape: roundedRectangleBorder, elevation: 2),
      iconTheme: IconThemeData(color: Colors.red),
      scaffoldBackgroundColor: myBackGround,
      bottomAppBarColor: myBackGround,
      bottomAppBarTheme: BottomAppBarTheme(color: myBackGround, elevation: 10),
      primarySwatch: Colors.red,
      visualDensity: VisualDensity.adaptivePlatformDensity);
}
