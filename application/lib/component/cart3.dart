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
        child: Container(
      width: sm.w(42),
      height: sm.w(42),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.only(top: sm.h(2), left: sm.w(2)),
          child: Text(txt1,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding:
                EdgeInsets.only(top: sm.h(2), left: sm.w(3), bottom: sm.h(2)),
            child: Text(title,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
          ),
        ),
        SizedBox(height: sm.h(2))
      ]),
    ));
  }
}
