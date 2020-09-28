import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

BoxDecoration bd1 = BoxDecoration(
    color: Colors.white,
    border: Border.all(
      color: Colors.white,
    ),
    borderRadius: BorderRadius.all(Radius.circular(20)));

BoxDecoration bd2 = BoxDecoration(
    color: Colors.white,
    border: Border.all(
      color: Colors.white,
    ),
    borderRadius: BorderRadius.all(Radius.circular(20)));
RoundedRectangleBorder rrb = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(15.0)),
);

RoundedRectangleBorder rrb28 = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(28.0)),
);

RoundedRectangleBorder rrbTop = RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
      topLeft: Radius.circular(28.0), topRight: Radius.circular(28.0)),
);

BoxDecoration bd3 = BoxDecoration(
    color: Colors.white,
    border: Border.all(color: Colors.white),
    borderRadius: BorderRadius.all(Radius.circular(12)));

TextStyle titleStyle = TextStyle(
    color: Colors.black,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: 1);

TextStyle titleStyle1 = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.bold,
    letterSpacing: 1);
TextStyle barTitleStyle =
    TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.w500);
