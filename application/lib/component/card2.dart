import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Favorito/config/SizeManager.dart';

class card2 extends StatefulWidget {
  String ratings;
  Function function;
  var va;
  card2({this.ratings, this.function, this.va});

  @override
  _card2State createState() => _card2State();
}

class _card2State extends State<card2> {
  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return InkWell(
      onTap: widget.function,
      child: Card(
        child: Container(
          width: sm.w(42),
          height: sm.w(42),
          padding: EdgeInsets.symmetric(vertical: sm.h(1)),
          child: Column(
            children: [
              Text(
                "Ratings",
                //textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontFamily: "Gilroy-Medium",
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.60),
              ),
              SizedBox(height: sm.h(2)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      widget.ratings,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontFamily: "Gilroy-Medium",
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.60,
                      ),
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/icon/star.svg',
                    alignment: Alignment.center,
                    height: sm.h(4),
                  ),
                ],
              ),
              SizedBox(height: sm.h(2)),
              Text(
                "${widget.va} Ratings",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.26,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
