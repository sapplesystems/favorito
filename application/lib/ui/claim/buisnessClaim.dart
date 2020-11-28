import 'dart:async';
import 'dart:io';
import 'package:Favorito/component/MyOutlineButton.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldPostAction.dart';
import 'package:Favorito/model/claimInfo.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/Regexer.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

class BusinessClaim extends StatefulWidget {
  @override
  _BusinessClaimState createState() => _BusinessClaimState();
}

class _BusinessClaimState extends State<BusinessClaim> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController ctrlMobile = TextEditingController();
  String otp = "";
  TextEditingController ctrlMail = TextEditingController();
  StreamController<ErrorAnimationType> errorController = StreamController();
  claimInfo clm = claimInfo();
  bool sentOtp = false;
  ProgressDialog pr;
  List<File> files = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getClaimData();
    });
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, isDismissible: false)
      ..style(
          message: 'Please wait...',
          borderRadius: 8.0,
          backgroundColor: Colors.white,
          progressWidget: CircularProgressIndicator(),
          elevation: 8.0,
          insetAnimCurve: Curves.easeInOut,
          progress: 0.0,
          maxProgress: 100.0,
          progressTextStyle: TextStyle(
              color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
          messageTextStyle: TextStyle(
              color: myRed, fontSize: 19.0, fontWeight: FontWeight.w600));

    SizeManager sm = SizeManager(context);
    return Scaffold(
      backgroundColor: myBackGround,
      appBar: AppBar(
        backgroundColor: myBackGround,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: clm.result == null
          ? Center(
              child: Text("Please wait ...."),
            )
          : Container(
              color: myBackGround,
              height: sm.scaledHeight(82),
              padding: EdgeInsets.symmetric(horizontal: sm.scaledWidth(4)),
              margin: EdgeInsets.only(
                top: sm.scaledHeight(2),
              ),
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: sm.scaledHeight(4)),
                    child: Text(
                      "Business Claim",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Card(
                    elevation: 10,
                    shape: rrb,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Builder(
                          builder: (context) => Form(
                              key: _formKey,
                              autovalidateMode: AutovalidateMode.always,
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    txtfieldPostAction(
                                        ctrl: ctrlMobile,
                                        hint: "Enter business phone",
                                        title: "Phone",
                                        keyboardSet: TextInputType.number,
                                        maxLines: 1,
                                        maxlen: 10,
                                        valid: true,
                                        sufixTxt:
                                            clm?.result[0]?.isPhoneVerified == 0
                                                ? "verify"
                                                : null,
                                        sufixIcon:
                                            clm?.result[0]?.isPhoneVerified == 0
                                                ? null
                                                : Icons.check_circle,
                                        security: false,
                                        sufixClick: () {
                                          if (clm?.result[0]?.isPhoneVerified ==
                                              0) {
                                            pr.show();
                                            WebService.funSendOtpSms(
                                                    {"mobile": ctrlMobile.text},
                                                    context)
                                                .then((value) {
                                              pr.hide();
                                              if (value.status == 'success') {
                                                setState(() {
                                                  sentOtp = true;
                                                });
                                              }
                                              BotToast.showText(
                                                  text: value.message);
                                            });
                                          }
                                        }),
                                    Visibility(
                                      visible: (sentOtp),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              "Enter Otp",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 20),
                                            ),
                                          ),
                                          PinCodeTextField(
                                            length: 5,
                                            obscureText: true,
                                            appContext: context,
                                            animationType: AnimationType.fade,
                                            pinTheme: PinTheme(
                                                shape: PinCodeFieldShape.box,
                                                borderRadius:
                                                    BorderRadius.circular(5),
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
                                            animationDuration:
                                                Duration(milliseconds: 300),
                                            backgroundColor: Colors.white,
                                            enableActiveFill: true,
                                            errorAnimationController:
                                                errorController,
                                            onCompleted: (v) {
                                              pr.show();
                                              WebService.funClaimVerifyOtp(
                                                      {"otp": v.toString()},
                                                      context)
                                                  .then((value) {
                                                pr.hide();
                                                BotToast.showText(
                                                    text: value.message);
                                                if (value.status == 'success') {
                                                  getClaimData();
                                                }
                                              });
                                            },
                                            beforeTextPaste: (text) {
                                              print("Allowing to paste $text");
                                              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                              //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                              return true;
                                            },
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Did not receive OTP, ",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  pr.show();
                                                  WebService.funSendOtpSms({
                                                    "mobile": ctrlMobile.text
                                                  }, context)
                                                      .then((value) {
                                                    pr.hide();
                                                    if (value.status ==
                                                        'success') {
                                                      setState(() {
                                                        sentOtp = true;
                                                      });
                                                    }
                                                    BotToast.showText(
                                                        text: value.message);
                                                  });
                                                },
                                                child: Text(
                                                  "Send Again",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: myRed,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: txtfieldPostAction(
                                          ctrl: ctrlMail,
                                          hint: "Enter business Email",
                                          title: "Email",
                                          maxLines: 1,
                                          myregex: emailRegex,
                                          keyboardSet:
                                              TextInputType.emailAddress,
                                          valid: true,
                                          sufixTxt:
                                              clm?.result[0]?.isEmailVerified ==
                                                      0
                                                  ? "verify"
                                                  : null,
                                          sufixIcon:
                                              clm?.result[0]?.isEmailVerified ==
                                                      0
                                                  ? null
                                                  : Icons.check_circle,
                                          security: false,
                                          sufixClick: () {
                                            pr.show();
                                            WebService.funSendEmailVerifyLink(
                                                    context)
                                                .then((value) {
                                              pr.hide();
                                              BotToast.showText(
                                                  text: value.message);
                                              if (value.status == 'success') {
                                                getClaimData();
                                              }
                                            });
                                          }),
                                    ),
                                    MyOutlineButton(
                                      title: "Upload Document",
                                      function: () async {
                                        FilePickerResult result =
                                            await FilePicker.platform
                                                .pickFiles(allowMultiple: true);

                                        if (result != null) {
                                          files = result.paths
                                              .map((path) => File(path))
                                              .toList();
                                        }
                                        // if (result != null) {
                                        //   List<File> files = result.paths
                                        //       .map((path) => File(path))
                                        //       .toList();
                                        // }
                                        // FilePickerResult result =
                                        //     await FilePicker.platform.pickFiles();

                                        if (result != null) {
                                          PlatformFile file =
                                              result.files.first;

                                          print(file.name);
                                          print(file.bytes);
                                          print(file.size);
                                          print(file.extension);
                                          print(file.path);
                                        }
                                      },
                                    ),
                                  ]))),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: sm.scaledWidth(16),
                          vertical: sm.scaledHeight(4)),
                      child: roundedButton(
                          clicker: () async {
                            await WebService.funClaimAdd(ctrlMobile.text,
                                    ctrlMail.text, files, context)
                                .then((value) {
                              BotToast.showText(text: value.message);
                            });
                          },
                          clr: Colors.red,
                          title: "Done"))
                ],
              ),
            ),
    );
  }

  getClaimData() async {
    await WebService.funClaimInfo(context).then((value) {
      if (value.status == 'success') {
        setState(() {
          ctrlMail.text = value?.result[0]?.businessEmail;
          ctrlMobile.text = value?.result[0]?.businessPhone;
          clm = value;
        });
      }
    });
  }
}
