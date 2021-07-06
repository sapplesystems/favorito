import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';

class TxtBorder extends StatelessWidget {
  String txt;
  Color bosrderColor;
  double w;
  TxtBorder({this.txt, this.bosrderColor, this.w});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: w,
      padding: EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: bosrderColor, width: 1)),
      child: Text(
        txt,
        textAlign: TextAlign.center,
        style: TextStyle(color: myRed),
      ),
    );
  }
}
