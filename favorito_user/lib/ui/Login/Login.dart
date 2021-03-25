import 'package:bot_toast/bot_toast.dart';
import 'package:favorito_user/Providers/BaseProvider.dart';
import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/Login/LoginController.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/Prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isFirst = false;
  LoginProvider vaTrue;

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    vaTrue = Provider.of<LoginProvider>(context, listen: true);
    if (isFirst) {}
    return WillPopScope(
        onWillPop: () => APIManager.onWillPop(context),
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Color(0xffedf0f5),
            body: Padding(
                padding: EdgeInsets.only(
                    left: sm.w(10), right: sm.w(10), top: sm.h(5)),
                child: ListView(shrinkWrap: true, children: [
                  SvgPicture.asset('assets/icon/login_image.svg',
                      height: sm.h(34), fit: BoxFit.fill),
                  SizedBox(height: sm.h(2)),
                  Text("Welcome Back.",
                      style: TextStyle(
                          fontFamily: 'Gilroy-Medium',
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.4,
                          fontSize: 28)),
                  Builder(
                      builder: (context) => Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(children: [
                            for (int i = 0; i < vaTrue.title.length; i++)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: EditTextComponent(
                                  controller: vaTrue.controller[i],
                                  hint: vaTrue.title[i],
                                  security: i == 1 ? true : false,
                                  valid: true,
                                  suffixTap: () {},
                                  suffixTxt: '',
                                  maxLines: 1,
                                  formate: FilteringTextInputFormatter
                                      .singleLineFormatter,
                                  maxlen: i == 1 ? 12 : 30,
                                  keyboardSet: i == 0
                                      ? TextInputType.emailAddress
                                      : TextInputType.text,
                                  prefixIcon: vaTrue.prefix[i],
                                ),
                              ),
                            InkWell(
                                onTap: () => Navigator.of(context)
                                    .pushNamed('/forgetPassword'),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text('Forgot password ?  ',
                                          style: TextStyle(color: myRed))
                                    ]))
                          ]))),
                  Padding(
                      padding: EdgeInsets.only(top: sm.h(5)),
                      child: NeumorphicButton(
                        style: NeumorphicStyle(
                            // shape: NeumorphicShape.concave,
                            depth: 11,
                            intensity: 40,
                            surfaceIntensity: -.4,
                            // lightSource: LightSource.topLeft,
                            color: Color(0xffedf0f5),
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.all(Radius.circular(24.0)))),
                        margin: EdgeInsets.symmetric(horizontal: sm.w(10)),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            if (vaTrue.controller[0].text.trim().length == 0) {
                              BaseProvider().snackBar(
                                  'Email/Phone required!!', _scaffoldKey);
                              return;
                            }
                            if (vaTrue.controller[1].text.trim().length == 0) {
                              BaseProvider().snackBar(
                                  'Password required!!', _scaffoldKey);
                              return;
                            }
                            Map _map = {
                              "username": vaTrue.controller[0].text,
                              "password": vaTrue.controller[1].text
                            };
                            APIManager.login(_map, _scaffoldKey).then((value) {
                              if (value.status == "success") {
                                Prefs.setToken(value.token);
                                Prefs.setPOSTEL(
                                    int.parse(value.data.postel ?? "201306"));

                                print("token : ${value.token}");
                                Navigator.pop(context);
                                Navigator.of(context).pushNamed('/navbar');
                              } else
                                BotToast.showText(text: value.message);
                            });
                          }
                        },
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Center(
                            child: Text("Login",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Gilroy-Light',
                                    color: myRed))),
                      )),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: sm.h(4)),
                    child: Row(
                      children: [
                        Expanded(child: Divider()),
                        Text('  OR  ',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: myGrey,
                                fontSize: 16)),
                        Expanded(child: Divider())
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Login using ",
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: myGrey,
                              fontSize: 16)),
                      InkWell(
                          onTap: () {
                            if (vaTrue.controller[0].text.trim().length == 0) {
                              BaseProvider().snackBar(
                                  'Email/Phone  required!!', _scaffoldKey);
                              return;
                            }
                            Navigator.of(context)
                                .pushNamed('/pinCodeVerificationScreen');
                          },
                          child: Text(" OTP",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: myRed)))
                    ],
                  ),
                  Center(
                      child: Padding(
                          padding: EdgeInsets.only(top: sm.h(4)),
                          child: Text("Dont have account yet?",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: myGrey,
                                  fontSize: 16)))),
                  Center(
                      child: Padding(
                          padding: EdgeInsets.only(bottom: sm.h(4)),
                          child: InkWell(
                              onTap: () =>
                                  Navigator.of(context).pushNamed('/signUp'),
                              child: Text("Sign Up",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: myRed)))))
                ]))));
  }
}
