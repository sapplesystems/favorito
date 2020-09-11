import 'package:application/component/roundedButton.dart';
import 'package:application/component/txtfieldboundry.dart';
import 'package:application/ui/signup/signup_b.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:velocity_x/velocity_x.dart';

class signup_a extends StatefulWidget {
  @override
  _signup_aState createState() => _signup_aState();
}

class _signup_aState extends State<signup_a> {
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
              left: context.percentWidth * 20,
              right: context.percentWidth * 20,
              child: roundedButton(
                clicker: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => signup_b()));
                },
                clr: Colors.red,
                title: "Next",
              ),
            ),
            Positioned(
              top: context.percentWidth * 30,
              left: context.percentWidth * 10,
              right: context.percentWidth * 10,
              child: Container(
                height: context.percentWidth * 120,
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: txtfieldboundry(
                              title: "Business Type", security: false)),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: txtfieldboundry(
                              title: "Business Name", security: false)),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: txtfieldboundry(
                              title: "Business Category", security: false)),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: txtfieldboundry(
                              title: "Postal Cado", security: false)),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: txtfieldboundry(
                              title: "Business Phone", security: false)),
                    ],
                  ),
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
