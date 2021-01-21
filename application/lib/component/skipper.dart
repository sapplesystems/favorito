import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/utils/myColors.dart';

class skipper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Positioned(
      right: -sm.w(8),
      top: -sm.h(4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(sm.h(20)),
          color: myRed,
        ),
        padding: const EdgeInsets.only(
          left: 22,
          right: 40,
          top: 38,
          bottom: 21,
        ),
        child: Text(
          "Skip",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w400,
            letterSpacing: 0.90,
          ),
        ),
      ),
    );
  }
}
