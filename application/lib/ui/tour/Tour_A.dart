import 'dart:ui';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/skipper.dart';
import 'package:Favorito/ui/login/login.dart';
import 'package:Favorito/ui/tour/Tour_B.dart';
import 'package:Favorito/ui/tour/Tour_C.dart';
import 'package:Favorito/ui/tour/Tour_D.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/utils/myString.Dart';

class Tour_a extends StatefulWidget {
  @override
  _Tour_aState createState() => _Tour_aState();
}

class _Tour_aState extends State<Tour_a> {
  TextEditingController _controler = TextEditingController();
  FocusNode _focus = FocusNode();
  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Stack(
            children: [
              skipper(),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  margin: EdgeInsets.only(top: 200),
                  alignment: Alignment.center,
                  child: SvgPicture.asset('assets/icon/login.svg',
                      height: sm.h(30), semanticsLabel: 'vector'),
                ),
                // card1(),
                Text(welcometxt,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700)),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(welcometxt2,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () {},
                          child: Container(
                              width: 37,
                              height: 14,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: myRed))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Tour_B()));
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
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Tour_c()));
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
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Tour_d()));
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
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: sm.h(4)),
                    child: RoundedButton(
                      title: "LOGIN",
                      clr: myRed,
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
