import 'dart:ui';

import 'package:Favorito/myCss.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class card3 extends StatelessWidget {
  String txt1;
  String txt2;
  card3({this.txt1, this.txt2});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: context.percentWidth * 44,
        height: context.percentWidth * 46,
        child: Card(
          shape: rrb,
          elevation: 4,
          child: Column(children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 20.0, left: context.percentWidth * 4),
                  child: Text(txt1,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 32.0, left: context.percentWidth * 6),
                  child: Text(txt2,
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
                ),
              ],
            )
          ]),
        ));
  }
}
