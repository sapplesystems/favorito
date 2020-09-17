import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:velocity_x/velocity_x.dart';

class card2 extends StatefulWidget {
  String ratings;
  card2({this.ratings});

  @override
  _card2State createState() => _card2State();
}

class _card2State extends State<card2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 162,
      height: 180,
      child: Stack(
        children: [
          Positioned(
            left: 33,
            top: 155,
            child: Container(
              width: 25,
              height: 25,
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 162,
                height: 173,
                child: Stack(
                  children: [
                    Positioned(
                      left: 121.39,
                      top: 4.04,
                      child: Visibility(
                        visible: false,
                        child: Container(
                          width: 27.53,
                          height: 90.54,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x117d0000),
                                blurRadius: 4,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
              ),
            ),
          ),
          Positioned(
            left: 40,
            top: 140,
            child: Text(
              "100 Ratings",
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontFamily: "Roboto",
                fontWeight: FontWeight.w400,
                letterSpacing: 0.26,
              ),
            ),
          ),
          Positioned(
            left: 21,
            top: 12,
            child: SizedBox(
              width: 113,
              height: 36,
              child: Text(
                "Ratings",
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
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.ratings,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontFamily: "Gilroy-Medium",
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.60,
                    ),
                  ),
                  SizedBox(width: 7),
                  SvgPicture.asset(
                    'assets/icon/star.svg',
                    alignment: Alignment.center,
                    height: context.percentHeight * 4,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
