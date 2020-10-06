import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';

class fromTo extends StatelessWidget {
  SizeManager sm;
  String txt;
  Color clr;
  fromTo({this.txt, this.clr});
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Container(
        child: Container(
      margin: EdgeInsets.all(8),
      width: sm.scaledWidth(24),
      height: sm.scaledHeight(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: clr,
          width: 1,
        ),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          txt,
          style: TextStyle(color: clr),
        ),
      ),
    ));
  }
}
