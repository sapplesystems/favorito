import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

BoxDecoration bd1 = BoxDecoration(
    color: Colors.white,
    border: Border.all(color: Colors.white),
    borderRadius: BorderRadius.all(Radius.circular(20)));

BoxDecoration round30 = BoxDecoration(
    color: Colors.white,
    border: Border.all(color: Colors.white),
    borderRadius: BorderRadius.all(Radius.circular(30)));

BoxDecoration round31 = BoxDecoration(
    color: Colors.white,
    border: Border.all(color: Colors.white),
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(5), topRight: Radius.circular(5)));

BoxDecoration bd1Red = BoxDecoration(
    color: myRed,
    border: Border.all(color: Colors.white),
    borderRadius: BorderRadius.all(Radius.circular(20)));

BoxDecoration bd2 = BoxDecoration(
    color: Colors.white,
    border: Border.all(color: Colors.white),
    borderRadius: BorderRadius.all(Radius.circular(20)));

RoundedRectangleBorder roundedRectangleBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(16.0)));

RoundedRectangleBorder rrb28 = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(28.0)));

RoundedRectangleBorder rrbTop = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(28.0), topRight: Radius.circular(28.0)));

BoxDecoration bd3 = BoxDecoration(
    color: Colors.white,
    border: Border.all(color: Colors.white),
    borderRadius: BorderRadius.all(Radius.circular(12)));

TextStyle titleStyle = TextStyle(
    color: Colors.black,
    fontSize: 26,
    fontFamily: 'Gilroy-Bold',
    letterSpacing: .2);

TextStyle appBarStyle = TextStyle(
    color: Colors.black,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: 3);

TextStyle titleStyle1 = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.bold,
    letterSpacing: 1);

TextStyle barTitleStyle =
    TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.w500);

TextStyle redTextSmall =
    TextStyle(color: myRed, fontSize: 12, fontWeight: FontWeight.w500);

TextStyle geryTextSmall =
    TextStyle(color: myGrey, fontSize: 14, fontWeight: FontWeight.w500);
