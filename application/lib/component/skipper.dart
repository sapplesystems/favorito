import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';

class skipper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Positioned(
      right: -sm.scaledWidth(8),
      top: -sm.scaledHeight(4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(sm.scaledHeight(20)),
          color: Color(0xffdd2626),
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
