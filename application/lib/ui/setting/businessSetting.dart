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
                top: 10,
                left: 10,
                child: Container(
                    decoration: bd1,
                    child: ListTile(
                      title: Text(
                        "Your Business ID:",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    )))
          ]),
        ));
  }
}
