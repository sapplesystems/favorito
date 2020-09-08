import 'package:flutter/material.dart';

class roundedButton extends StatelessWidget {
  Color clr;
  String title;
  Function clicker;
  roundedButton({this.clr, this.title, this.clicker});
  @override
  Widget build(BuildContext context) {
    clr == null ? (clr = Color(0xffdd2626)) : (clr = clr);
    return GestureDetector(
      onTap: clicker,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: clr,
          ),
          padding: const EdgeInsets.only(
            left: 109,
            right: 91,
            top: 20,
            bottom: 17,
          ),
          child: Text(title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: "Gilroy-Bold",
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1))),
    );
  }
}
