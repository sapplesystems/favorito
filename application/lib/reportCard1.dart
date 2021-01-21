import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';

class reportCard1 extends StatefulWidget {
  @override
  _reportCard1State createState() => _reportCard1State();
}

class _reportCard1State extends State<reportCard1> {
  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Stack(children: [
      Stack(children: [
        Container(
            width: 162,
            height: 173,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Column(children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: sm.w(5), top: sm.w(5)),
                    child: Text(
                      "860",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontFamily: "Gilroy-Medium",
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: sm.w(5)),
                    child: Text(
                      "Check-in(s) ",
                      style: TextStyle(
                        color: Color(0xff9996a3),
                        fontSize: 13,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.16,
                      ),
                    ),
                  ),
                ],
              )
            ]))
      ]),
      Positioned(
          left: 24,
          top: 120,
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Opacity(
                opacity: 0.50,
                child: Container(
                    width: 3.10, height: 3.56, color: Color(0xffefefef))),
            SizedBox(width: 3.77),
            Opacity(
                opacity: 0.50,
                child: Container(
                    width: 3.10, height: 1.46, color: Color(0xffefefef))),
            SizedBox(width: 3.77),
            Opacity(
                opacity: 0.50,
                child: Container(
                    width: 3.10, height: 7.28, color: Color(0xffefefef))),
            SizedBox(width: 3.77),
            Opacity(
                opacity: 0.50,
                child: Container(
                    width: 3.10, height: 32.98, color: Color(0xffefefef))),
            SizedBox(width: 3.77),
            Opacity(
                opacity: 0.50,
                child: Container(
                    width: 3.10, height: 32.65, color: Color(0xffefefef))),
            SizedBox(width: 3.77),
            Opacity(
                opacity: 0.50,
                child: Container(
                    width: 3.10, height: 6.56, color: Color(0xffefefef))),
            SizedBox(width: 3.77),
            Opacity(
                opacity: 0.50,
                child: Container(
                    width: 3.10, height: 7.89, color: Color(0xffefefef))),
            SizedBox(width: 3.77),
            Opacity(
                opacity: 0.50,
                child: Container(
                    width: 3.10, height: 21.41, color: Color(0xffefefef))),
            SizedBox(width: 3.77),
            Opacity(
                opacity: 0.50,
                child: Container(
                    width: 3.10, height: 10.12, color: Color(0xffefefef))),
            SizedBox(width: 3.77),
            Opacity(
              opacity: 0.50,
              child: Container(
                width: 3.10,
                height: 21.39,
                color: Colors.green,
              ),
            ),
            SizedBox(width: 3.77),
            Opacity(
                opacity: 0.50,
                child: Container(
                    width: 3.10, height: 3.56, color: Color(0xffefefef))),
            SizedBox(width: 3.77),
            Opacity(
                opacity: 0.50,
                child: Container(
                    width: 3.10, height: 1.46, color: Color(0xffefefef))),
            SizedBox(width: 3.77),
            Opacity(
                opacity: 0.50,
                child: Container(
                    width: 3.10, height: 7.28, color: Color(0xffefefef))),
            SizedBox(width: 3.77),
            Opacity(
                opacity: 0.50,
                child: Container(
                    width: 3.10, height: 32.98, color: Color(0xffefefef))),
            SizedBox(width: 3.77),
            Opacity(
                opacity: 0.50,
                child: Container(
                  width: 3.10,
                  height: 32.65,
                  color: Color(0xffefefef),
                )),
            SizedBox(width: 3.77),
            Opacity(
                opacity: 0.50,
                child: Container(
                    width: 3.10, height: 6.56, color: Color(0xffefefef))),
            SizedBox(width: 3.77),
            Opacity(
                opacity: 0.50,
                child:
                    Container(width: 3.10, height: 21.39, color: Colors.blue))
          ]))
    ]);
  }
}
