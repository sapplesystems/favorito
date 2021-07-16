import 'dart:convert' as convert;

import 'package:Favorito/Provider/SignUpProvider.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldPostAction.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/model/loginModel.dart';
import 'package:Favorito/network/RequestModel.dart';
import 'package:Favorito/network/serviceFunction.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/Terms_of_service/termsofservice.dart';
import 'package:Favorito/ui/bottomNavigation/bottomNavigation.dart';
import 'package:Favorito/ui/bottomNavigation/bottomNavigationProvider.dart';
import 'package:Favorito/ui/privacypolicy/privacypolicy.dart';
import 'package:Favorito/ui/setting/BusinessProfile/BusinessProfileProvider.dart';
import 'package:Favorito/utils/Prefs.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController userCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  SharedPreferences preferences;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool showPass = false;
  SizeManager sm;
  @override
  void initState() {
    super.initState();
    Prefs().clear();
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Scaffold(
        body: ListView(children: [
      Padding(
          padding: EdgeInsets.only(top: sm.h(6)),
          child: Text("Log in",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontFamily: "Gilroy-Bold",
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1))),
      Container(
        margin: EdgeInsets.only(left: sm.w(6), right: sm.w(6), bottom: 32.0),
        child: Stack(children: [
          Card(
            margin: EdgeInsets.only(top: sm.h(10)),
            elevation: 8,
            shadowColor: Colors.grey.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Builder(
                builder: (context) => Form(
                  key: _formKey,
                  child: Column(children: [
                    Padding(
                      padding: EdgeInsets.only(top: sm.h(8)),
                      child: txtfieldPostAction(
                        valid: true,
                        title: "Email/Phone",
                        maxLines: 1,
                        controller: userCtrl,
                        security: false,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: sm.h(4)),
                        child: txtfieldPostAction(
                          valid: true,
                          maxLines: 1,
                          title: "Password",
                          sufixClick: () =>
                              setState(() => showPass = !showPass),
                          sufixIcon: showPass
                              ? Icons.visibility
                              : Icons.visibility_off,
                          controller: passCtrl,
                          sufixColor: myRed,
                          security: !showPass,
                        )),
                    Padding(
                      padding: EdgeInsets.only(bottom: sm.h(4), right: sm.w(2)),
                      child: InkWell(
                        onTap: () =>
                            Navigator.of(context).pushNamed('/forgetPass'),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Forgot Password?",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: myRed,
                                  fontSize: 16,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
          Positioned(
              left: sm.w(30),
              right: sm.w(30),
              child: SvgPicture.asset('assets/icon/maskgroup.svg',
                  alignment: Alignment.center, height: sm.h(20))),
        ]),
      ),
      Padding(
          padding:
              EdgeInsets.only(top: sm.h(4), left: sm.w(20), right: sm.w(20)),
          child: RoundedButton(
            clicker: () => funClick(),
            clr: Colors.red,
            title: "Login",
          )),
      Center(
        child: Padding(
          padding: EdgeInsets.only(top: sm.h(4)),
          child: Text(
            "Dont have account yet?",
            style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16),
          ),
        ),
      ),
      Center(
        child: Padding(
          padding: EdgeInsets.only(top: sm.h(1), bottom: sm.h(4)),
          child: InkWell(
            onTap: () {
              SignUpProvider?.categoryKey?.currentState
                  ?.changeSelectedItem(null);
              SignUpProvider?.categoryKey1?.currentState
                  ?.changeSelectedItem(null);
              SignUpProvider?.categoryKey2?.currentState
                  ?.changeSelectedItem(null);
              Navigator.of(context).pushNamed('/signUpA');
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
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "By continuing, you agree to Favorito's ",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.32),
                children: [
                  TextSpan(
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TermsOfServicePage())),
                      text: "Terms of Service ",
                      style: TextStyle(
                          color: myRed,
                          fontSize: 14,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.32)),
                  TextSpan(
                      text: "and acknowledge Favorito's \n",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.32)),
                  TextSpan(
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PrivacyPolicy())),
                      text: "Privacy Policy.",
                      style: TextStyle(
                          color: myRed,
                          fontSize: 14,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.32))
                ],
              ))

          //  Text(
          //     "By continuing, you agree to Favorito's Terms of Service and acknowledge Favorito's \nPrivacy Policy.",
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //         fontSize: 14,
          //         fontFamily: "Roboto",
          //         fontWeight: FontWeight.w400,
          //         letterSpacing: 0.32))
          )
    ]));
  }

  void funClick() async {
    if (_formKey.currentState.validate()) {
      Map<String, dynamic> _map = {
        "username": userCtrl.text,
        "password": passCtrl.text
      };
      RequestModel requestModel = RequestModel();
      requestModel.context = context;
      requestModel.data = _map;
      requestModel.url = serviceFunction.funLogin;
      preferences = await SharedPreferences.getInstance();
      await WebService.serviceCall(requestModel).then((value) {
        loginModel _v =
            loginModel.fromJson(convert.json.decode(value.toString()));
        if (_v.status == "success") {
          preferences.setString('businessId', _v.data.businessId);
          preferences.setString('email', _v.data.email);
          preferences.setString('phone', _v.data.phone);
          Prefs.setToken(_v.token.toString().trim());
          Consumer<bottomNavigationProvider>(
            builder: (ctx, data, child) {
              data.setSelectedIndex(0);
              return null;
            },
          );

          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => bottomNavigation()));
        } else {
          BotToast.showText(text: value.message.toString());
        }
      });
    }
  }
}
