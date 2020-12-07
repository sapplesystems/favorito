import 'package:flutter/material.dart';

class roundedButton2 extends StatelessWidget {
  String title;
  Color clr;
  Function clicker;
  roundedButton2({this.clicker, this.clr, this.title});
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: clicker,
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
                color: clr,
                border: Border.all(),
                borderRadius: BorderRadius.all(Radius.circular(32))),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 92),
            child: Text(title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: "Gilroy",
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1))));
  }
}
