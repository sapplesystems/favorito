import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Favorito/config/SizeManager.dart';

class card4 extends StatelessWidget {
  String title;
  String ammount;
  String percent;
  String icon;
  String circleIcon;
  int circleColor;
  card4(
      {this.title,
      this.ammount,
      this.circleIcon,
      this.icon,
      this.percent,
      this.circleColor});
  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Card(
      shadowColor: Colors.grey.withOpacity(0.2),
      elevation: 8,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Container(
          width: sm.w(15),
          height: sm.w(15),
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Color(circleColor)),
          child: Image.asset('assets/icon/$circleIcon.png'),
        ),
        Text(
          title,
          style: TextStyle(
              fontSize: 16, fontFamily: 'Roboto', fontWeight: FontWeight.w400),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: sm.w(6),
            ),
            Text(ammount,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              SvgPicture.asset('assets/icon/$icon.svg'),
              Text("$percent%   ", style: TextStyle(fontSize: 10)),
              // Icon()
            ])
          ],
        )
      ]),
    );
  }
}
