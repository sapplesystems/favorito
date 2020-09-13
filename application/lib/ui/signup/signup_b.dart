import 'dart:ui';

import 'package:application/component/roundedButton.dart';
import 'package:application/component/txtfieldboundry.dart';
import 'package:application/ui/bottomNavigation/bottomNavigation.dart';
import 'package:application/ui/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:velocity_x/velocity_x.dart';

class signup_b extends StatefulWidget {
  @override
  _signup_bState createState() => _signup_bState();
}

class _signup_bState extends State<signup_b> {
  bool checked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfffff4f4),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: Container(
        color: Color(0xfffff4f4),
        height: context.percentHeight * 90,
        child: Stack(
          children: [
            Positioned(
              left: context.percentWidth * 30,
              right: context.percentWidth * 30,
              child: Text(
                "Sign Up",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: "Gilroy-Bold",
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
            Positioned(
              bottom: context.percentWidth * 6,
              left: context.percentWidth * 22,
              right: context.percentWidth * 22,
              child: roundedButton(
                clicker: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => bottomNavigation()));
                },
                clr: Colors.red,
                title: "Done",
              ),
            ),
            Positioned(
              top: context.percentWidth * 30,
              left: context.percentWidth * 10,
              right: context.percentWidth * 10,
              child: Container(
                height: context.percentWidth * 100,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                padding: EdgeInsets.only(
                  top: context.percentHeight * 8,
                  left: context.percentWidth * 2,
                  right: context.percentWidth * 2,
                ),
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            txtfieldboundry(title: "Email", security: false)),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            txtfieldboundry(title: "Phone", security: false)),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: txtfieldboundry(
                            title: "Password", security: false)),
                    CheckboxListTile(
                      title: Text(
                        "By continuing, you agree to Favorito's\nTerms of Service and acknowledge\nFavorito's Privacy Policy.",
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.32,
                        ),
                      ),
                      value: checked,
                      onChanged: (newValue) {
                        setState(() {
                          checked = !checked;
                        });
                      },
                      controlAffinity: ListTileControlAffinity
                          .leading, //  <-- leading Checkbox
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                top: context.percentWidth * 5,
                left: context.percentWidth * 30,
                right: context.percentWidth * 30,
                child: SvgPicture.asset('assets/icon/maskgroup.svg',
                    alignment: Alignment.center,
                    height: context.percentHeight * 20)),
          ],
        ),
      ),
    );
  }
}
