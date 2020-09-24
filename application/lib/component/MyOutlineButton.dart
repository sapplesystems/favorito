import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class MyOutlineButton extends StatelessWidget {
  String title;
  Function function;
  MyOutlineButton({this.title, this.function});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        width: context.percentWidth * 6.5,
        height: context.percentHeight * 6.5,
        margin: EdgeInsets.symmetric(
          horizontal: context.percentWidth * 14,
          vertical: context.percentHeight * 2,
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
