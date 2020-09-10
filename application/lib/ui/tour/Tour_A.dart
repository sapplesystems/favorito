import 'dart:ui';
import 'package:application/component/roundedButton.dart';
import 'package:application/component/skipper.dart';
import 'package:application/ui/tour/Tour_B.dart';
import 'package:application/ui/tour/Tour_C.dart';
import 'package:application/ui/tour/Tour_D.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:application/utils/myString.Dart';

class Tour_a extends StatefulWidget {
  @override
  _Tour_aState createState() => _Tour_aState();
}

class _Tour_aState extends State<Tour_a> {
  TextEditingController _controler = TextEditingController();
  FocusNode _focus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Stack(
            children: [
              skipper(),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  margin: EdgeInsets.only(top: context.isMobile ? 200 : 150),
                  alignment: Alignment.center,
                  child: SvgPicture.asset('assets/icon/login.svg',
                      height: context.percentHeight * 30,
                      semanticsLabel: 'vector'),
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
                        child: ClipOval(
                          child: Container(
                            color: Colors.red,
                            height: 20.0, // height of the button
                            width: 20.0, // width of the button
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
                                  builder: (context) => Tour_B()));
                        },
                        child: ClipOval(
                          child: Container(
                            color: Colors.red,
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
                            color: Colors.red,
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
                            color: Colors.red,
                            height: 12.0, // height of the button
                            width: 12.0, // width of the button
                            child: null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Container(
                  margin:
                      EdgeInsets.symmetric(vertical: context.percentHeight * 4),
                  child: roundedButton(
                    title: "LOGIN",
                    clr: Color(0xffdd2626),
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
