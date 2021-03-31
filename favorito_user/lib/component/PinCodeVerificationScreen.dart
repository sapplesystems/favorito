import 'dart:async';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/ui/Login/LoginController.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/RIKeys.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  // ..text = "123456";
  LoginProvider vaTrue;
  // ignore: close_sinks
  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();
  SizeManager sm;
  bool isFirst = true;
  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  // snackBar Widget
  snackBar(String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    vaTrue = Provider.of<LoginProvider>(context, listen: true);
    if (isFirst) {
      vaTrue.sendLoginOtp(RIKeys.josKeys13);
      isFirst = false;
    }
    return Scaffold(
      key: RIKeys.josKeys13,
      backgroundColor: Color(0xffedf0f5),
      body: GestureDetector(
        onTap: () {},
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(children: <Widget>[
            SizedBox(height: 20),
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: sm.w(8), vertical: sm.h(2)),
              child: SvgPicture.asset('assets/icon/login_image.svg',
                  height: sm.h(30), fit: BoxFit.fill),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('OTP Verification',
                  style: TextStyle(
                      fontFamily: 'Gilroy-Medium',
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                      fontSize: 20),
                  textAlign: TextAlign.center),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
              child: RichText(
                text: TextSpan(
                    text:
                        "Enter the OTP, Sent to on your registered phone no. ",
                    children: [
                      TextSpan(
                          text: "",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                    ],
                    style: TextStyle(color: Colors.black54, fontSize: 15)),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Form(
              key: formKey,
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                  child: PinCodeTextField(
                    appContext: context,
                    // pastedTextStyle: TextStyle(
                    //     color: myGreenLight, fontWeight: FontWeight.bold),
                    length: 5,
                    obscureText: true,
                    obscuringCharacter: '*',
                    // obscuringWidget: FlutterLogo(
                    //   size: 24,
                    // ),

                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    validator: (v) {
                      int f = 5 - v.length;
                      return f != 0 ? 'Remaining ' + f.toString() : null;
                      // if (v.length < 3) {
                      //   return "I'm from validator";
                      // } else {
                      //   return null;
                      // }
                    },
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: myGrey,
                        disabledColor: Colors.red,
                        activeColor: Colors.black,
                        inactiveColor: myGrey,
                        selectedColor: Colors.red,
                        inactiveFillColor: Colors.white,
                        selectedFillColor: Colors.white,
                        borderWidth: 1),
                    cursorColor: Colors.black,
                    animationDuration: Duration(milliseconds: 300),
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                    // controller: vaTrue.controller[2],
                    keyboardType: TextInputType.number,
                    boxShadows: [
                      BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10)
                    ],
                    onCompleted: (v) {
                      // print("Completed:$v");
                      vaTrue.controller[2].text = v.toString();
                    },
                    // onTap: () {
                    //   print("Pressed");
                    // },
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        currentText = value;
                      });
                    },
                    beforeTextPaste: (text) {
                      print("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                  )),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 30.0),
            //   child: Text(
            //     hasError ? "*Please fill up all the cells properly" : "",
            //     style: TextStyle(
            //         color: Colors.red,
            //         fontSize: 12,
            //         fontWeight: FontWeight.w400),
            //   ),
            // ),
            SizedBox(
              height: 20,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "Didn't receive the code? ",
                style: TextStyle(color: Colors.black54, fontSize: 15),
              ),
              TextButton(
                  onPressed: () {
                    snackBar("OTP resend!!");
                    vaTrue.sendLoginOtp(RIKeys.josKeys13);
                  },
                  child: Text("RESEND",
                      style:
                          TextStyle(fontFamily: 'Gilroy-Medium', fontSize: 16)))
            ]),
            SizedBox(height: 14),
            ButtonTheme(
              height: 50,
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
                margin: EdgeInsets.symmetric(horizontal: sm.w(20)),
                onPressed: () {
                  formKey.currentState.validate();
                  // conditions for validating
                  if (currentText.length != 5) {
                    errorController.add(ErrorAnimationType
                        .shake); // Triggering error shake animation
                    setState(() {
                      hasError = true;
                    });
                  } else {
                    setState(
                      () {
                        vaTrue.verifyLogin();
                        hasError = false;
                      },
                    );
                  }
                },
                child: Center(
                    child: Text("Verify",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Gilroy-Light',
                            color: myRed))),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: sm.h(2), horizontal: sm.w(4)),
              child: Row(children: [
                Expanded(child: Divider()),
                Text('  OR  ',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: myGrey,
                        fontSize: 16)),
                Expanded(child: Divider())
              ]),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("Login using ",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: myGrey,
                      fontSize: 16)),
              InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/login');
                  },
                  child: Text("Password",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: myRed)))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              // Flexible(
              //     child: TextButton(
              //   child: Text("Clear"),
              //   onPressed: () {
              //     vaTrue.controller[2].clear();
              //   },
              // )),
              // Flexible(
              //     child: TextButton(
              //   child: Text("Set Text"),
              //   onPressed: () {
              //     setState(() {
              //       textEditingController.text = "123456";
              //     });
              //   },
              // )),
            ])
          ]),
        ),
      ),
    );
  }
}
