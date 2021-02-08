import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/bottomNavigation/bottomNavigation.dart';
import 'package:Favorito/ui/signup/signup_a.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController userCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ProgressDialog pr;
  @override
  void initState() {
    super.initState();
    setState(() {
      userCtrl.text = "rohit.shukla@sapple.co.in";
      passCtrl.text = "sapple@123";
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: sm.h(6)),
            child: Text(
              "Log in",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontFamily: "Gilroy-Bold",
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 32.0,
            ),
            child: Stack(
              children: [
                Card(
                  margin: EdgeInsets.only(top: sm.h(10)),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Builder(
                      builder: (context) => Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: sm.h(8)),
                              child: txtfieldboundry(
                                valid: true,
                                title: "Email/Phone",
                                controller: userCtrl,
                                security: false,
                              ),
                            ),
                            Padding(
                                padding:
                                    EdgeInsets.symmetric(vertical: sm.h(4)),
                                child: txtfieldboundry(
                                  valid: true,
                                  maxLines: 1,
                                  title: "Password",
                                  controller: passCtrl,
                                  security: true,
                                )),
                            Row(
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
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    left: sm.w(30),
                    right: sm.w(30),
                    child: SvgPicture.asset('assets/icon/maskgroup.svg',
                        alignment: Alignment.center, height: sm.h(20))),
              ],
            ),
          ),
          Padding(
              padding:
                  EdgeInsets.only(top: 16, left: sm.w(16), right: sm.w(16)),
              // padding: EdgeInsets.symmetric(
              //     horizontal: sm.w(16), vertical: sm.w(12)),
              child: RoundedButton(
                  clicker: () => funClick(), clr: Colors.red, title: "Login")),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: sm.h(6)),
              child: Text(
                "Dont have account yet?",
                style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: sm.h(1)),
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Signup_a()));
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
    );
  }

  void funClick() {
    if (_formKey.currentState.validate()) {
      Map<String, dynamic> _map = {
        "username": userCtrl.text,
        "password": passCtrl.text
      };
      BotToast.showLoading(allowClick: true, duration: Duration(seconds: 1));
      WebService.funGetLogin(_map, context).then((value) {
        if (value.status == "success") {
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
