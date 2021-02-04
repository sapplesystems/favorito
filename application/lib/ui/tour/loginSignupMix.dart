import 'package:Favorito/ui/login/login.dart';
import 'package:Favorito/ui/signup/signup_a.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Favorito/config/SizeManager.dart';

class LoginSignup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: sm.h(10)),
        child: Center(
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/icon/f.svg',
                alignment: Alignment.center,
                height: sm.h(20),
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
                padding: EdgeInsets.only(top: sm.h(12)),
                child: SvgPicture.asset(
                  'assets/icon/man.svg',
                  alignment: Alignment.center,
                  height: sm.h(20),
                ),
              ),
              InkWell(
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login())),
                child: Container(
                  margin: EdgeInsets.only(top: sm.w(20)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: myRed,
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: sm.w(20), vertical: sm.h(2)),
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
                margin: EdgeInsets.only(top: sm.w(4)),
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
              InkWell(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Signup_a())),
                child: Container(
                  margin: EdgeInsets.only(top: sm.w(4)),
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
