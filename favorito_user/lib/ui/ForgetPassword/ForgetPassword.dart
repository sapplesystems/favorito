import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/ui/ForgetPassword/ForgetPasswordProvider.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/Regexer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class ForgetPassword extends StatelessWidget {
  SizeManager sm;
  ForgetPasswordProvider prTrue;
  ForgetPasswordProvider prFalse;
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    prTrue = Provider.of<ForgetPasswordProvider>(context, listen: true);
    prFalse = Provider.of<ForgetPasswordProvider>(context, listen: false);
    prFalse.setContext(context);
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
          prTrue.allClear();
        },
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: sm.w(10)),
            child: ListView(children: [
              // Row(
              //   children: [Icon(Icons.add)],
              // ),
              Padding(
                padding: EdgeInsets.only(top: sm.h(1)),
                child: SvgPicture.asset(
                  'assets/icon/signup_image.svg',
                  height: sm.h(20),
                  fit: BoxFit.fitHeight,
                ),
              ),
              Row(children: [
                Text("Forget password.",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26))
              ]),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: EditTextComponent(
                  ctrl: prTrue.acces[0].controller,
                  hint: prFalse.title[0],
                  security: false,
                  valid: true,
                  suffixTxt: '',
                  myOnChanged: (_) {
                    prTrue.onChange(0);
                  },
                  error: prTrue.acces[0].error,
                  myregex: emailAndMobileRegex,
                  maxLines: 1,
                  maxlen: 50,
                  keyboardSet: TextInputType.emailAddress,
                  prefixIcon: prFalse.prefix[0],
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  prTrue.didNotReceive,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    decoration: TextDecoration.underline,
                  ),
                ),
                InkWell(
                  onTap: () {
                    prTrue.funSendOtpSms();
                  },
                  child: Text(
                    prFalse.sendOtptxt,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: myRed, fontSize: 12),
                  ),
                ),
              ]),
              Visibility(
                visible: prTrue?.otpForworded,
                child: ListView(
                    shrinkWrap: true,
                    addRepaintBoundaries: false,
                    dragStartBehavior: DragStartBehavior.start,
                    primary: false,
                    addAutomaticKeepAlives: true,
                    children: [
                      Padding(
                          padding:
                              EdgeInsets.only(top: sm.h(3), bottom: sm.h(1)),
                          child: Text("Enter Otp",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 20))),
                      Padding(
                          padding: EdgeInsets.only(
                              left: sm.h(1.4), right: sm.h(1.4)),
                          child: PinCodeTextField(
                              length: 5,
                              // controller: prTrue.acces[1].controller,
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
                                  activeFillColor: myGrey,
                                  disabledColor: Colors.red,
                                  activeColor: Colors.black,
                                  inactiveColor: myGrey,
                                  selectedColor: Colors.red,
                                  inactiveFillColor: Colors.white,
                                  selectedFillColor: Colors.white,
                                  borderWidth: 1),
                              animationDuration: Duration(milliseconds: 300),
                              backgroundColor: Colors.transparent,
                              enablePinAutofill: true,
                              enableActiveFill: true,
                              onChanged: (v) {
                                prFalse.actualOtp = v;
                                prTrue.acces[1].controller.text = v;
                              },
                              onCompleted: (v) {
                                prFalse.actualOtp = v;
                                prTrue.acces[1].controller.text = v;
                              })),
                      Text(prTrue.acces[1].error ?? '',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 14, color: myRed)),
                      for (int i = 2; i < prFalse.title.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: EditTextComponent(
                            ctrl: prTrue.acces[i].controller,
                            title: prFalse.title[i],
                            hint: prFalse.title[i],
                            security: true,
                            suffixTxt: '',
                            myOnChanged: (_) {
                              prTrue.onChange(i);
                            },
                            error: prTrue.acces[i].error,
                            valid: true,
                            maxLines: 1,
                            formate:
                                FilteringTextInputFormatter.singleLineFormatter,
                            maxlen: 12,
                            keyboardSet: TextInputType.text,
                            prefixIcon: prTrue.prefix[i],
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.only(top: sm.h(6)),
                        child: NeumorphicButton(
                          style: NeumorphicStyle(
                              depth: 11,
                              intensity: 40,
                              surfaceIntensity: -.4,
                              color: Color(0xffedf0f5),
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.all(Radius.circular(24.0)))),
                          margin: EdgeInsets.symmetric(horizontal: sm.w(10)),
                          onPressed: () {
                            prFalse.funVerifyOtp();
                          },
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Center(
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, color: myRed),
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
