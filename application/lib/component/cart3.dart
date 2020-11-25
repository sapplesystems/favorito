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
    return Container(
        width: sm.scaledWidth(44),
        // height: sm.scaledHeight(22),
        child: Card(
          shape: rrb,
          elevation: 4,
          child: Column(children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20.0, left: sm.scaledWidth(4)),
                  child: Text(txt1,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: 32.0, left: sm.scaledWidth(6)),
                    child: Text(title,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            )
          ]),
        ));
  }
}
