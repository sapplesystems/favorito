import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/myCss.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/utils/myColors.dart';

class card1 extends StatefulWidget {
  String checkins;
  Function function;
  card1({this.checkins, this.function});
  @override
  _card1State createState() => _card1State();
}

class _card1State extends State<card1> {
  List<double> hList = [
    3.56,
    1.46,
    7.28,
    32.98,
    32.65,
    6.56,
    7.89,
    21.41,
    10.12,
    21.39,
    3.56,
    1.46,
    7.28,
    32.98,
    32.65,
    6.56,
    21.39
  ];

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return InkWell(
      onTap: widget.function,
      child: Card(
        child: Container(
          width: sm.w(42),
          height: sm.w(42),
          padding: EdgeInsets.only(
              bottom: sm.h(2), right: sm.h(3), top: sm.h(1), left: sm.h(2)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.checkins,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontFamily: "Gilroy-Medium",
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.60,
                ),
              ),
              Text(
                "Check-in(s) ",
                style: TextStyle(
                  color: Color(0xff9996a3),
                  fontSize: 13,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.26,
                ),
              ),
              SizedBox(height: sm.h(6)),
              Row(
                children: [
                  for (int i = 0; i < hList.length; i++)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 1.6),
                      width: 3.22,
                      height: hList[i],
                      color: i % 3 == 1 ? myRed : Color(0xffefefef),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
