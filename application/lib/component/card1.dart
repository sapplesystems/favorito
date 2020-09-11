import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class card1 extends StatefulWidget {
  @override
  _card1State createState() => _card1State();
}

class _card1State extends State<card1> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
          children: [
            Container(
              width: 162,
              height: 173,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
            ),
          ],
        ),
        Positioned(
          left: 24,
          top: 120,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Opacity(
                opacity: 0.50,
                child: Container(
                  width: 3.10,
                  height: 3.56,
                  color: Color(0xffefefef),
                ),
              ),
              SizedBox(width: 3.77),
              Opacity(
                opacity: 0.50,
                child: Container(
                  width: 3.10,
                  height: 1.46,
                  color: Color(0xffefefef),
                ),
              ),
              SizedBox(width: 3.77),
              Opacity(
                opacity: 0.50,
                child: Container(
                  width: 3.10,
                  height: 7.28,
                  color: Color(0xffefefef),
                ),
              ),
              SizedBox(width: 3.77),
              Opacity(
                opacity: 0.50,
                child: Container(
                  width: 3.10,
                  height: 32.98,
                  color: Color(0xffefefef),
                ),
              ),
              SizedBox(width: 3.77),
              Opacity(
                opacity: 0.50,
                child: Container(
                  width: 3.10,
                  height: 32.65,
                  color: Color(0xffefefef),
                ),
              ),
              SizedBox(width: 3.77),
              Opacity(
                opacity: 0.50,
                child: Container(
                  width: 3.10,
                  height: 6.56,
                  color: Color(0xffefefef),
                ),
              ),
              SizedBox(width: 3.77),
              Opacity(
                opacity: 0.50,
                child: Container(
                  width: 3.10,
                  height: 7.89,
                  color: Color(0xffefefef),
                ),
              ),
              SizedBox(width: 3.77),
              Opacity(
                opacity: 0.50,
                child: Container(
                  width: 3.10,
                  height: 21.41,
                  color: Color(0xffefefef),
                ),
              ),
              SizedBox(width: 3.77),
              Opacity(
                opacity: 0.50,
                child: Container(
                  width: 3.10,
                  height: 10.12,
                  color: Color(0xffefefef),
                ),
              ),
              SizedBox(width: 3.77),
              Opacity(
                opacity: 0.50,
                child: Container(
                  width: 3.10,
                  height: 21.39,
                  color: Color(0xffdd2626),
                ),
              ),
              SizedBox(width: 3.77),
              Opacity(
                opacity: 0.50,
                child: Container(
                  width: 3.10,
                  height: 3.56,
                  color: Color(0xffefefef),
                ),
              ),
              SizedBox(width: 3.77),
              Opacity(
                opacity: 0.50,
                child: Container(
                  width: 3.10,
                  height: 1.46,
                  color: Color(0xffefefef),
                ),
              ),
              SizedBox(width: 3.77),
              Opacity(
                opacity: 0.50,
                child: Container(
                  width: 3.10,
                  height: 7.28,
                  color: Color(0xffefefef),
                ),
              ),
              SizedBox(width: 3.77),
              Opacity(
                opacity: 0.50,
                child: Container(
                  width: 3.10,
                  height: 32.98,
                  color: Color(0xffefefef),
                ),
              ),
              SizedBox(width: 3.77),
              Opacity(
                opacity: 0.50,
                child: Container(
                  width: 3.10,
                  height: 32.65,
                  color: Color(0xffefefef),
                ),
              ),
              SizedBox(width: 3.77),
              Opacity(
                opacity: 0.50,
                child: Container(
                  width: 3.10,
                  height: 6.56,
                  color: Color(0xffefefef),
                ),
              ),
              SizedBox(width: 3.77),
              Opacity(
                opacity: 0.50,
                child: Container(
                  width: 3.10,
                  height: 21.39,
                  color: Color(0xffdd2626),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 24,
          top: 47,
          child: SizedBox(
            width: 112,
            height: 17,
            child: Text(
              "Check-in(s) ",
              style: TextStyle(
                color: Color(0xff9996a3),
                fontSize: 13,
                fontFamily: "Roboto",
                fontWeight: FontWeight.w400,
                letterSpacing: 0.26,
              ),
            ),
          ),
        ),
        Positioned(
          left: 24,
          top: 15,
          child: SizedBox(
            width: 58,
            height: 32,
            child: Text(
              "860",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontFamily: "Gilroy-Medium",
                fontWeight: FontWeight.w400,
                letterSpacing: 0.60,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
