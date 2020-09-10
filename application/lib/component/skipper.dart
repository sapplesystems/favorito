import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class skipper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: -context.percentWidth * (context.isMobile ? 8 : 3),
      top: -context.percentHeight * 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              (context.percentHeight * context.percentWidth) * 20),
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
