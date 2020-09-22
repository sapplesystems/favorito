import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class rowWithTextNButton extends StatelessWidget {
  String txt1;
  String txt2;
  String check;
  Function function;
  rowWithTextNButton({this.txt1, this.txt2, this.check, this.function});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      padding: EdgeInsets.symmetric(
          vertical: context.percentHeight * 2,
          horizontal: context.percentWidth * 2),
      margin: EdgeInsets.symmetric(
        vertical: context.percentHeight * 1,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(txt1),
          InkWell(
            onTap: function,
            child: Visibility(
              visible: check == "0" ? true : false,
              child: redButton(txt2),
            ),
          )
        ],
      ),
    );
  }

  Widget redButton(String txt2) {
    return Container(
      width: 54,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Color(0xffdd2626),
          width: 1,
        ),
      ),
      child: Text(
        txt2,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
