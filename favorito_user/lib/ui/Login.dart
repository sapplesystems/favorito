import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/ui/Signup.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'Home.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      theme: NeumorphicThemeData(
          defaultTextColor: myRed,
          accentColor: Colors.grey,
          variantColor: Colors.black38,
          depth: 8,
          intensity: 0.65),
      usedTheme: UsedTheme.LIGHT,
      child: Material(
        child: NeumorphicBackground(
          child: _Login(),
        ),
      ),
    );
  }
}

class _Login extends StatefulWidget {
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<_Login> {
  bool _autoValidateForm = false;
  var _myUserNameEditTextController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Container(
      height: sm.scaledHeight(100),
      width: sm.scaledWidth(100),
      padding: EdgeInsets.symmetric(
          horizontal: sm.scaledWidth(10), vertical: sm.scaledHeight(5)),
      decoration: BoxDecoration(color: myBackGround),
      child: ListView(
        shrinkWrap: true,
        children: [
          SvgPicture.asset(
            'assets/icon/login_image.svg',
            height: sm.scaledHeight(30),
            fit: BoxFit.fill,
          ),
          Padding(
            padding: EdgeInsets.only(top: sm.scaledHeight(2)),
            child: Text(
              "Welcome Back.",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
          ),
          Container(
            child: Builder(
                builder: (context) => Form(
                    key: _formKey,
                    autovalidate: _autoValidateForm,
                    child: Column(children: [
                      Padding(
                        padding: EdgeInsets.only(top: sm.scaledHeight(4)),
                        child: EditTextComponent(
                          ctrl: _myUserNameEditTextController,
                          title: "Email",
                          security: false,
                          valid: true,
                          prefixIcon: 'mail',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: sm.scaledHeight(4)),
                        child: EditTextComponent(
                          ctrl: _myUserNameEditTextController,
                          title: "Password",
                          security: false,
                          valid: true,
                          prefixIcon: 'password',
                        ),
                      ),
                    ]))),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: sm.scaledHeight(6)),
              child: Text(
                "Dont have account yet?",
                style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: sm.scaledHeight(1)),
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Signup()));
                },
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18, color: myRed),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: sm.scaledHeight(6)),
            child: NeumorphicButton(
              style: NeumorphicStyle(
                  shape: NeumorphicShape.convex,
                  depth: 4,
                  lightSource: LightSource.topLeft,
                  color: myButtonBackground),
              margin: EdgeInsets.symmetric(horizontal: sm.scaledWidth(10)),
              boxShape: NeumorphicBoxShape.roundRect(
                  BorderRadius.all(Radius.circular(24.0))),
              onClick: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
              isEnabled: true,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Center(
                child: Text(
                  "Login",
                  style: TextStyle(fontWeight: FontWeight.w400, color: myRed),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
