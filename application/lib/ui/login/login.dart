import 'package:application/component/roundedButton2.dart';
import 'package:application/component/txtfieldboundry.dart';
import 'package:application/network/webservices.dart';
import 'package:application/ui/bottomNavigation/bottomNavigation.dart';
import 'package:application/utils/Prefs.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:velocity_x/velocity_x.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController userCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  @override
  void initState() {
    super.initState();
    decide();
  }

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
          height: context.percentHeight * 100,
          child: Builder(
              builder: (context) => Form(
                    key: _formKey,
                    autovalidate: _autovalidate,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: context.percentHeight * 60,
                            child: Stack(children: [
                              Positioned(
                                left: context.percentWidth * 30,
                                right: context.percentWidth * 30,
                                child: Text(
                                  "Log in",
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
                                top: context.percentWidth * 30,
                                left: context.percentWidth * 10,
                                right: context.percentWidth * 10,
                                child: Container(
                                  height: context.percentHeight * 40,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  padding: EdgeInsets.only(
                                    top: context.percentHeight * 8,
                                    left: context.percentWidth * 2,
                                    right: context.percentWidth * 2,
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 16),
                                        child: txtfieldboundry(
                                          valid: true,
                                          title: "Email/Phone",
                                          ctrl: userCtrl,
                                          security: false,
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16),
                                          child: txtfieldboundry(
                                            valid: true,
                                            maxLines: 1,
                                            title: "Password",
                                            ctrl: passCtrl,
                                            security: true,
                                          )),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 18.0),
                                            child: Text(
                                              "Forgot Password?",
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                color: Color(0xffdd2626),
                                                fontSize: 16,
                                                fontFamily: "Roboto",
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: context.percentWidth * 5,
                                  left: context.percentWidth * 30,
                                  right: context.percentWidth * 30,
                                  child: SvgPicture.asset(
                                      'assets/icon/maskgroup.svg',
                                      alignment: Alignment.center,
                                      height: context.percentHeight * 20)),
                            ]),
                          ),
                          Positioned(
                              bottom: context.percentHeight * 70,
                              left: context.percentWidth * 50,
                              right: context.percentWidth * 50,
                              child: roundedButton2(
                                title: "Login",
                                clr: Colors.red,
                                clicker: () => funClick(),
                              )),
                          Padding(
                            padding: EdgeInsets.only(
                                top: context.percentHeight * 10,
                                left: 20,
                                right: 20),
                            child: Text(
                              "By continuing, you agree to Favorito's Terms of Service and acknowledge Favorito's \nPrivacy Policy.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.32,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ))),
    );
  }

  void funClick() {
    if (_formKey.currentState.validate()) {
      _autovalidate = false;
      Map<String, dynamic> _map = {
        "username": userCtrl.text,
        "password": passCtrl.text
      };
      BotToast.showLoading(allowClick: true, duration: Duration(seconds: 1));
      WebService.funGetLogin(_map).then((value) {
        if (value.message == "success") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => bottomNavigation()));
        } else {
          BotToast.showText(text: value.message.toString());
        }
      });
    }
  }

  void decide() async {
    var token = await Prefs.token;
    if (token != null && token != "") {
      print("Token:$token");
      Future.delayed(Duration.zero, () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => bottomNavigation()));
      });
    }
  }
}
