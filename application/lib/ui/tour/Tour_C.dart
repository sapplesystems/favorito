import 'dart:ui';

import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/ui/tour/Tour_A.dart';
import 'package:Favorito/ui/tour/Tour_B.dart';
import 'package:Favorito/ui/tour/Tour_D.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/utils/myString.Dart';

class Tour_c extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
              color: Color(0xff2f2e41),
              child: Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                      bottomLeft: const Radius.circular(28.0),
                      bottomRight: const Radius.circular(28.0),
                    )),
                margin: EdgeInsets.only(bottom: sm.scaledHeight(10)),
                child: Stack(children: [
                  Positioned(
                      bottom: 8,
                      right: 6,
                      child: SvgPicture.asset(
                        'assets/icon/img2.svg',
                        alignment: Alignment.center,
                        height: sm.scaledHeight(20),
                      )),
                  Positioned(
                      top: sm.scaledHeight(20),
                      left: sm.scaledWidth(2),
                      right: sm.scaledWidth(2),
                      child: SvgPicture.asset(
                        'assets/icon/img1.svg',
                        alignment: Alignment.center,
                        height: sm.scaledHeight(30),
                      )),
                  Positioned(
                      top: sm.scaledHeight(52),
                      left: sm.scaledWidth(12),
                      right: sm.scaledWidth(12),
                      child: Text(welcometxt,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700))),
                  Positioned(
                      top: sm.scaledHeight(58),
                      left: sm.scaledWidth(12),
                      right: sm.scaledWidth(12),
                      child: Text(welcometxt2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700))),
                  Positioned(
                      top: sm.scaledHeight(72),
                      left: sm.scaledWidth(12),
                      right: sm.scaledWidth(12),
                      child: dots(context)),
                ]),
              )),
          Positioned(
              bottom: sm.scaledHeight(7),
              left: sm.scaledWidth(12),
              right: sm.scaledWidth(12),
              child: roundedButton(
                clicker: () {},
                clr: Colors.red,
                title: "SIGN UP",
              )),
          Positioned(
              bottom: sm.scaledHeight(2),
              left: sm.scaledWidth(12),
              right: sm.scaledWidth(12),
              child: Text(
                "LOGIN",
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              )),
        ],
      ),
    );
  }

  Widget dots(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Tour_a()));
              },
              child: ClipOval(
                child: Container(
                  color: Colors.grey,
                  height: 12.0, // height of the button
                  width: 12.0, // width of the button
                  child: null,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Tour_B()));
              },
              child: ClipOval(
                child: Container(
                  color: Colors.grey,
                  height: 12.0, // height of the button
                  width: 12.0, // width of the button
                  child: null,
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () {},
                  child: Container(
                      width: 37,
                      height: 14,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: myRed)))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Tour_d()));
              },
              child: ClipOval(
                child: Container(
                  color: Colors.grey,
                  height: 12.0, // height of the button
                  width: 12.0, // width of the button
                  child: null,
                ),
              ),
            ),
          ),
        ],
      );
}
