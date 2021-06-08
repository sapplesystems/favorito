import 'package:Favorito/component/txtfieldPostAction.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/ui/forgetPass/ForgetPassProvider.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/utils/RIKeys.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:Favorito/utils/Regexer.dart';

class ForgetPass extends StatelessWidget {
  ForgetPassProvider fpTrue;
  ForgetPassProvider fpFalse;

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    fpTrue = Provider.of<ForgetPassProvider>(context, listen: true);
    fpFalse = Provider.of<ForgetPassProvider>(context, listen: false);
    fpTrue.setContext(context);
    return Scaffold(
      body: ListView(
        children: [
          Row(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  fpFalse.clearall();
                  Navigator.pop(context);
                },
              ),
            )
          ]),
          Text(
            "Forget Password",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontFamily: "Gilroy-Reguler",
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0),
            child: Card(
              margin: EdgeInsets.only(top: sm.h(4)),
              elevation: 5,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Builder(
                  builder: (context) => Form(
                    key: RIKeys.josKeys23,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: sm.h(2)),
                          child: txtfieldboundry(
                            valid: true,
                            title: "Email/Phone",
                            controller: fpTrue.ctrlUser,
                            myregex: emailAndMobileRegex,
                            error: fpTrue.ctrlUserError,
                            security: false,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(fpTrue.didNotReceive,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 10,
                                    decoration: TextDecoration.underline)),
                            InkWell(
                              onTap: () => fpTrue.funSendOtpSms(),
                              child: Text(
                                fpTrue.sendOtptxt,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: myRed,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: fpTrue.sentOtp ?? false,
                          child: Column(children: [
                            Padding(
                                padding: EdgeInsets.only(
                                    top: sm.h(3), bottom: sm.h(1)),
                                child: Text("Enter Otp",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 20))),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: sm.h(1.4), right: sm.h(1.4)),
                              child: PinCodeTextField(
                                length: 5,
                                // controller: fpTrue.textEditingController,
                                obscureText: true,
                                appContext: context,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9]')),
                                ],
                                animationType: AnimationType.fade,
                                pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.box,
                                    borderRadius: BorderRadius.circular(5),
                                    fieldHeight: 50,
                                    fieldWidth: 40,
                                    activeFillColor: Colors.white,
                                    disabledColor: Colors.red,
                                    activeColor: Colors.black,
                                    inactiveColor: Colors.black,
                                    selectedColor: Colors.red,
                                    inactiveFillColor: Colors.white,
                                    selectedFillColor: Colors.white,
                                    borderWidth: 1),
                                animationDuration: Duration(milliseconds: 300),
                                backgroundColor: Colors.white,
                                enablePinAutofill: true,
                                enableActiveFill: true,
                                onChanged: (v) {
                                  fpFalse.actualOtp = v;
                                  fpTrue.notifyListeners();
                                },
                                // errorAnimationController: fpTrue.errorController,
                                onCompleted: (v) {
                                  fpFalse.actualOtp = v;
                                },
                                // beforeTextPaste: (text) {
                                //   print("Allowing to paste $text");
                                //   //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                //   //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                //   return true;
                                // },
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: sm.h(1)),
                                child: txtfieldPostAction(
                                  valid: true,
                                  maxLines: 1,
                                  hint: "Password",
                                  myregex: passwordRegex,
                                  controller: fpTrue.passCtrl,
                                  security:
                                      (fpTrue.iconData == Icons.visibility_off),
                                  myOnChanged: (n) {
                                    fpTrue.notifyListeners();
                                  },
                                  sufixColor: myRed,
                                  sufixClick: () {
                                    fpTrue.iconData =
                                        fpTrue.iconData == Icons.visibility
                                            ? Icons.visibility_off
                                            : Icons.visibility;
                                    fpTrue.notifyListeners();
                                  },
                                  sufixIcon: fpTrue.iconData,
                                )),
                            Padding(
                              padding: EdgeInsets.only(top: sm.h(2.4)),
                              child: txtfieldPostAction(
                                valid: true,
                                maxLines: 1,
                                myregex: passwordRegex,
                                hint: "Confirm Password",
                                controller: fpTrue.cPassCtrl,
                                errorText: fpTrue.ctrlPassError,
                                security:
                                    (fpTrue.iconData2 == Icons.visibility_off),
                                myOnChanged: (n) {
                                  fpTrue.notifyListeners();
                                },
                                sufixColor: myRed,
                                sufixClick: () {
                                  fpTrue.iconData2 =
                                      fpTrue.iconData2 == Icons.visibility
                                          ? Icons.visibility_off
                                          : Icons.visibility;

                                  fpTrue.notifyListeners();
                                },
                                sufixIcon: fpTrue.iconData2,
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Consumer<ForgetPassProvider>(
            builder: (context, data, child) {
              print("fpTrue.actualOtp.length${fpTrue.actualOtp.length}");
              return Visibility(
                visible: (fpTrue.actualOtp.length == 5 &&
                    fpTrue.passCtrl.text == fpTrue.cPassCtrl.text),
                child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: sm.w(28),
                      vertical: sm.w(10),
                    ),
                    child: RoundedButton(
                        clicker: () {
                          if (RIKeys.josKeys23.currentState.validate())
                            fpFalse.verifyOtp();
                        },
                        clr: Colors.red,
                        title: "Submit")),
              );
            },
          ),
        ],
      ),
    );
  }
}
