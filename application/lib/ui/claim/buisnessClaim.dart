import 'dart:async';
import 'dart:io';
import 'package:Favorito/component/MyOutlineButton.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtFieldPostIcon.dart';
import 'package:Favorito/component/txtfieldPostAction.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/utils/Regexer.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/widgets.dart';
import 'package:file_picker/file_picker.dart';

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
  TextEditingController editingController = TextEditingController();
  bool autovalidateMode;
  @override
  Widget build(BuildContext context) {
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
        title: Text(
          "",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
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
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              txtfieldPostAction(
                                  ctrl: ctrlMobile,
                                  hint: "Enter business phone",
                                  title: "Phone",
                                  keyboardSet: TextInputType.number,
                                  maxLines: 1,
                                  maxlen: 10,
                                  valid: true,
                                  sufixTxt: "Verify",
                                  security: false,
                                  sifixClick: () {
                                    BotToast.showText(text: "Clicked");
                                  }),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  "Enter Otp",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 20),
                                ),
                              ),
                              PinCodeTextField(
                                length: 5,
                                obscureText: true,
                                appContext: context,
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
                                enableActiveFill: true,
                                errorAnimationController: errorController,
                                controller: editingController,
                                onCompleted: (v) {
                                  print("Completed");
                                },
                                onChanged: (value) {
                                  print(value);
                                  setState(() {
                                    // currentText = value;
                                  });
                                },
                                beforeTextPaste: (text) {
                                  print("Allowing to paste $text");
                                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                  return true;
                                },
                              ),
                              Text(
                                "Did not receive OTP, Send Again",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: txtfieldPostIcon(
                                    ctrl: ctrlMail,
                                    hint: "Enter business Email",
                                    title: "Email",
                                    maxLines: 1,
                                    myregex: emailRegex,
                                    keyboardSet: TextInputType.emailAddress,
                                    valid: true,
                                    sufixIcon: Icons.check_circle,
                                    security: false,
                                    sufixClick: () {
                                      BotToast.showText(text: "Clicked");
                                    }),
                              ),
                              MyOutlineButton(
                                title: "Upload Document",
                                function: () async {
                                  FilePickerResult result = await FilePicker
                                      .platform
                                      .pickFiles(allowMultiple: true);

                                  if (result != null) {
                                    List<File> files = result.paths
                                        .map((path) => File(path))
                                        .toList();

                                    print("files:${files.toString()}");
                                  }
                                  // if (result != null) {
                                  //   List<File> files = result.paths
                                  //       .map((path) => File(path))
                                  //       .toList();
                                  // }
                                  if (_formKey.currentState.validate()) {}
                                  // FilePickerResult result =
                                  //     await FilePicker.platform.pickFiles();

                                  if (result != null) {
                                    PlatformFile file = result.files.first;

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
                    clicker: () {
                      // funSublim();
                    },
                    clr: Colors.red,
                    title: "Done"))
          ],
        ),
      ),
    );
  }
}
