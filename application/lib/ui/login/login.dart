import 'package:application/component/roundedButton.dart';
import 'package:application/component/txtfieldboundry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:velocity_x/velocity_x.dart';

class Login extends StatelessWidget {
  TextEditingController userCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
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
                                  height: context.percentHeight * 50,
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
                              bottom: context.percentHeight * 7,
                              left: context.percentWidth * 50,
                              right: context.percentWidth * 20,
                              child: roundedButton(
                                clicker: () {},
                                clr: Colors.red,
                                title: "Login",
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
}
