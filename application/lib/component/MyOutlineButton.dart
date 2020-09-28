import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';

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
        width: sm.scaledWidth(6.5),
        height: sm.scaledHeight(6.5),
        margin: EdgeInsets.symmetric(
          horizontal: sm.scaledWidth(14),
          vertical: sm.scaledHeight(2),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Color(0xffdd2626),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(title,
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.red, fontSize: 16, letterSpacing: 1)),
        ),
      ),
    );
  }
}
