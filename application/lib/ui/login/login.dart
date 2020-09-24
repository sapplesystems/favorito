import 'package:Favorito/component/roundedButton2.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/bottomNavigation/bottomNavigation.dart';
import 'package:Favorito/utils/Prefs.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/component/roundedButton.dart';
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

  @override
  void initState() {
    super.initState();
    decide();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffff4f4),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: context.percentHeight * 6),
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
                  margin: EdgeInsets.only(top: context.percentHeight * 10),
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: context.percentHeight * 8),
                              child: txtfieldboundry(
                                valid: true,
                                title: "Email/Phone",
                                ctrl: userCtrl,
                                security: false,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: context.percentHeight * 4),
                                child: txtfieldboundry(
                                  valid: true,
                                  maxLines: 1,
                                  title: "Password",
                                  ctrl: passCtrl,
                                  security: true,
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Forgot Password?",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    color: Color(0xffdd2626),
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
                    left: context.percentWidth * 30,
                    right: context.percentWidth * 30,
                    child: SvgPicture.asset('assets/icon/maskgroup.svg',
                        alignment: Alignment.center,
                        height: context.percentHeight * 20)),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: context.percentWidth * 16,
                  vertical: context.percentWidth * 12),
              child: roundedButton(
                  clicker: () => funClick(), clr: Colors.red, title: "Login")),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
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
      WebService.funGetLogin(_map).then((value) {
        if (value.status == "success") {
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

// Stack(children: [
//           Positioned(
//             left: context.percentWidth * 30,
//             right: context.percentWidth * 30,
//             child: Text(
//               "Log in",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 24,
//                 fontFamily: "Gilroy-Bold",
//                 fontWeight: FontWeight.w700,
//                 letterSpacing: 1,
//               ),
//             ),
//           ),
//           Positioned(
//             top: context.percentWidth * 30,
//             left: context.percentWidth * 10,
//             right: context.percentWidth * 10,
//             child: Container(
//               height: context.percentHeight * 40,
//               decoration: bd1,
//               child: Column(
//                 children: [],
//               ),
//             ),
//           ),
//           Positioned(
//               top: context.percentWidth * 5,
//               left: context.percentWidth * 30,
//               right: context.percentWidth * 30,
//               child: SvgPicture.asset('assets/icon/maskgroup.svg',
//                   alignment: Alignment.center,
//                   height: context.percentHeight * 20)),
//         ]),
