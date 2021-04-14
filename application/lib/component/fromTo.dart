import 'package:Favorito/config/SizeManager.dart';
import 'package:flutter/material.dart';

class fromTo extends StatelessWidget {
  SizeManager sm;
  String txt;
  Color clr;
  Color txtClr;

  fromTo({this.txt, this.clr, this.txtClr});
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Container(
        margin: EdgeInsets.all(2),
        width: sm.w(24),
        height: sm.h(4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: clr, width: 1)),
        child: Align(
            alignment: Alignment.center,
            child: Text(txt, style: TextStyle(color: txtClr ?? clr))));
  }
}
