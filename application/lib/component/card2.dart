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
    final h = MediaQuery.of(context).textScaleFactor;
    return InkWell(
      onTap: widget.function,
      child: Card(
        elevation: 8,
        shadowColor: Colors.grey.withOpacity(0.2),
        child: Container(
          width: sm.w(42),
          height: sm.w(42),
          padding: EdgeInsets.symmetric(vertical: sm.h(2), horizontal: sm.w(4)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Ratings",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontFamily: "Gilroy-Medium",
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.60),
              ),
              SizedBox(height: sm.h(2)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      widget.ratings,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontFamily: "Gilroy-Medium",
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.60,
                      ),
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/icon/star.svg',
                    matchTextDirection: true,
                    alignment: Alignment.center,
                    height: sm.h(4),
                  ),
                ],
              ),
              SizedBox(height: sm.h(2)),
              Center(
                child: Text(
                  "${widget.va} Ratings",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.26,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
