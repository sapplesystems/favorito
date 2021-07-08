import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/utils/myColors.dart';

class MyOutlineButton extends StatelessWidget {
  String title;
  Function function;
  MyOutlineButton({this.title, this.function});
  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return InkWell(
      onTap: function,
      child: Container(
        width: sm.w(65),
        height: sm.h(6.5),
        margin: EdgeInsets.symmetric(
          horizontal: sm.w(14),
          vertical: sm.h(2),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: myRed,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: myRed,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 1)),
        ),
      ),
    );
  }
}
