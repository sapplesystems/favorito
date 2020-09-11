import 'package:application/ui/signup/signup_a.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:velocity_x/velocity_x.dart';

class loginSignup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: context.percentHeight * 10),
        child: Center(
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/icon/f.svg',
                alignment: Alignment.center,
                height: context.percentHeight * 20,
              ),
              Text(
                "FAVORITO",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontFamily: "Gilroy-Bold",
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.25,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: context.percentHeight * 12),
                child: SvgPicture.asset(
                  'assets/icon/man.svg',
                  alignment: Alignment.center,
                  height: context.percentHeight * 20,
                ),
              ),
              InkWell(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => signup_a())),
                child: Container(
                  margin: EdgeInsets.only(top: context.percentWidth * 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color(0xffdd2626),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: context.percentWidth * 20,
                      vertical: context.percentHeight * 2),
                  child: Text(
                    "Log In",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontFamily: "Gilroy-Bold",
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: context.percentWidth * 4),
                child: Text(
                  "Don’t have account yet?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontFamily: "Gilroy-Bold",
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: context.percentWidth * 4),
                child: Text(
                  "Sign Up",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontFamily: "Gilroy-Bold",
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
