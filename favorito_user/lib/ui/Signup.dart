import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class Signup extends StatelessWidget {
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
          child: _Signup(),
        ),
      ),
    );
  }
}

class _Signup extends StatefulWidget {
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<_Signup> {
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
            'assets/icon/signup_image.svg',
            height: sm.scaledHeight(20),
            fit: BoxFit.fitHeight,
          ),
          Padding(
            padding: EdgeInsets.only(top: sm.scaledHeight(2)),
            child: Text(
              "Welcome.",
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
                        padding: EdgeInsets.only(top: sm.scaledHeight(2)),
                        child: EditTextComponent(
                          ctrl: _myUserNameEditTextController,
                          title: "Full Name",
                          security: false,
                          valid: true,
                          prefixIcon: 'name',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: sm.scaledHeight(2)),
                        child: EditTextComponent(
                          ctrl: _myUserNameEditTextController,
                          title: "Phone",
                          security: false,
                          valid: true,
                          prefixIcon: 'phone',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: sm.scaledHeight(2)),
                        child: EditTextComponent(
                          ctrl: _myUserNameEditTextController,
                          title: "Email",
                          security: false,
                          valid: true,
                          prefixIcon: 'mail',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: sm.scaledHeight(2)),
                        child: EditTextComponent(
                          ctrl: _myUserNameEditTextController,
                          title: "Password",
                          security: false,
                          valid: true,
                          prefixIcon: 'password',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: sm.scaledHeight(1)),
                        child: CheckboxListTile(
                          title: Text(
                            "By continuing, you agree to Favorito's Terms of Service and acknowledge Favorito's Privacy Policy",
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
                            ),
                          ),
                          value: true,
                          onChanged: (newValue) {
                            setState(() {});
                          },
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: sm.scaledHeight(1)),
                        child: CheckboxListTile(
                          title: Text(
                            "Reach me on watsapp",
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
                            ),
                          ),
                          value: true,
                          onChanged: (newValue) {
                            setState(() {});
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      )
                    ]))),
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
              onClick: () {},
              isEnabled: true,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Center(
                child: Text(
                  "Submit",
                  style: TextStyle(fontWeight: FontWeight.w400, color: myRed),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: sm.scaledHeight(6)),
              child: Text(
                "Already have an account?",
                style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: sm.scaledHeight(1)),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Login",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18, color: myRed),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
