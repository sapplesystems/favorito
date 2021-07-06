import 'dart:ui';

import 'package:Favorito/myCss.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';

class card3 extends StatelessWidget {
  String txt1;
  String title;
  card3({this.txt1, this.title});
  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Card(
        elevation: 8,
        shadowColor: Colors.grey.withOpacity(0.2),
        child: Container(
          width: sm.w(40),
          height: sm.h(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: sm.h(2), horizontal: sm.w(6)),
              child: Text(txt1,
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400)),
            ),
            Padding(
              padding: EdgeInsets.only(top: sm.h(2), left: sm.w(8)),
              child: Text(title,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 45,
                      fontFamily: "Gilroy-Medium",
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.60)),
            ),
            SizedBox(height: sm.h(2))
          ]),
        ));
  }
}
