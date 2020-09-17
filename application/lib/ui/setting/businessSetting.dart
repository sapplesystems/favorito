import 'dart:ui';
import 'package:application/component/roundedButton2.dart';
import 'package:application/utils/myString.Dart';
import 'package:google_maps/google_maps.dart';
import 'package:application/component/txtfieldboundry.dart';
import 'package:application/myCss.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/velocity_x.dart';

class BusinessSetting extends StatefulWidget {
  @override
  _BusinessSettingState createState() => _BusinessSettingState();
}

class _BusinessSettingState extends State<BusinessSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfffff4f4),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Business Settings",
            style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2),
          ),
          actions: [
            IconButton(
              icon: SvgPicture.asset('assets/icon/save.svg'),
              onPressed: () {},
            )
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          elevation: 0,
        ),
        body: Container(
          height: context.percentHeight * 90,
          width: context.percentWidth * 98,
          child: Stack(children: [
            Positioned(
                top: context.percentHeight * 10,
                left: context.percentWidth * 8,
                right: context.percentWidth * 8,
                child: Container(
                    decoration: bd1,
                    margin: EdgeInsets.only(bottom: context.percentHeight * 8),
                    height: context.percentHeight * 70,
                    padding: EdgeInsets.symmetric(
                        horizontal: context.percentWidth * 6,
                        vertical: context.percentHeight * 4),
                    child: ListView(children: [
                      Column(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(top: context.percentHeight * 4),
                            child: Image.asset(
                              'assets/icon/foodcircle.png',
                              fit: BoxFit.cover,
                              height: context.percentHeight * 20,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: txtfieldboundry(
                                title: "Business Name",
                                security: false,
                                hint: "Enter business name",
                              )),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: txtfieldboundry(
                                title: "Business Phone",
                                security: false,
                                hint: "Enter business phone",
                              )),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: txtfieldboundry(
                                title: "LandLine",
                                security: false,
                                hint: "Enter Landline number",
                              )),
                          Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(children: [Text("Business Hours")]),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        children: [
                                          Column(children: [
                                            Text(" Mon - Fri ",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            Text("11:30 - 23:00",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w200)),
                                          ])
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Column(children: [
                                            Text(" Mon - Fri ",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            Text("11:30 - 23:00",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w200)),
                                          ])
                                        ],
                                      ),
                                      Text("Add",
                                          style: TextStyle(color: Colors.red))
                                    ],
                                  )
                                ],
                              )),
                        ],
                      ),
                    ]))),
            Positioned(
                top: context.percentHeight * 4,
                left: context.percentWidth * 18,
                right: context.percentWidth * 18,
                child: Container(
                    decoration: bd1,
                    padding: EdgeInsets.symmetric(
                        horizontal: context.percentWidth * 6,
                        vertical: context.percentHeight * 4),
                    child: Column(
                      children: [
                        Text(
                          "Your Business ID",
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(height: 4),
                        Text(
                          business_id,
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    ))),
            Align(
                alignment: Alignment.bottomCenter,
                child: roundedButton2(
                  title: "Sublit",
                  clr: Colors.red,
                  clicker: () => funClick(),
                ))
          ]),
        ));
  }

  void funClick() {}
}
