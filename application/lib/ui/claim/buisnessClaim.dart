import 'package:Favorito/component/MyOutlineButton.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldPostAction.dart';
import 'package:Favorito/ui/claim/ClaimProvider.dart';
import 'package:Favorito/utils/RIKeys.dart';
import 'package:Favorito/utils/Regexer.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class BusinessClaim extends StatelessWidget {
  bool isFirst;
  BusinessClaim({this.isFirst});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  SizeManager sm;
  ClaimProvider vaTrue;
  @override
  Widget build(BuildContext context) {
    print("ClaimIs:$isFirst");
    if (isFirst) {
      sm = SizeManager(context);
      vaTrue = Provider.of<ClaimProvider>(context, listen: true);
      vaTrue.getClaimData(context);
      vaTrue.initCall(context);
      isFirst = false;
      vaTrue.setNeedSubmit(false);
    }
      
    return Scaffold(
      key: RIKeys.josKeys21,
      appBar: AppBar(
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop()),
          iconTheme: IconThemeData(color: Colors.black)),
      body:
       vaTrue.claimInfo.result == null
          ? Center(child: Text("Please wait ...."))
          : 


Consumer<ClaimProvider>(builder: (context,data,child){
   if (isFirst) {
      sm = SizeManager(context);
      data.getClaimData(context);
      data.initCall(context);
      data.setNeedSubmit(false);
    }
   
  return           Container(
              color: myBackGround,
              height: sm.h(82),
              padding: EdgeInsets.symmetric(horizontal: sm.w(4)),
              margin: EdgeInsets.only(top: sm.h(2)),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: sm.h(4)),
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
                                        controller: data.ctrlMobile,
                                        hint: "Enter business phone",
                                        title: "Phone",
                                        maxLines: 1,
                                        readOnly: true,
                                        maxlen: 10,
                                        valid: true,
                                        sufixTxt:
                                            data.otpVerify,
                                        security: false,
                                        sufixClick: () {
                                          print(data.otpVerify);
                                          if (data.otpVerify == 'verify')
                                            data.sendOtp(context);
                                        }),
                                    Visibility(
                                     visible: data.isOtpSend,
                                      child: Column(children: [
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            "Enter OTP",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 20)
                                          ),
                                        ),
                                        PinCodeTextField(
                                          onChanged: (d) {},
                                          length: 6,
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
                                          onCompleted: (v) =>
                                              data.verifyOtp(v, context),
                                          beforeTextPaste: (text) {
                                            print("Allowing to paste $text");return true;
                                          },
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Did not receive OTP ?, ",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  // decoration:
                                                  // TextDecoration.underline,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () =>
                                                    data.sendOtp(context),
                                                child: Text(
                                                  "Resend OTP",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: myRed,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ]),
                                      ]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: txtfieldPostAction(
                                          controller: data.ctrlMail,
                                          hint: "Enter business Email",
                                          title: "Email",
                                          maxLines: 1,
                                          readOnly: true,
                                          myregex: emailRegex,
                                          keyboardSet:
                                              TextInputType.emailAddress,
                                          valid: true,
                                          sufixTxt: data.claimInfo?.result[0]
                                                      ?.isEmailVerified ==
                                                  0
                                              ? data.emailVerify
                                              : null,
                                          sufixIcon: data.claimInfo?.result[0]
                                                      ?.isEmailVerified ==
                                                  0
                                              ? null
                                              : Icons.check_circle,
                                          security: false,
                                          sufixClick: () => data
                                              .funSendEmailVerifyLink(context)),
                                    ),
                                    MyOutlineButton(
                                        title: "Upload Document",
                                        function: () {
                                          data.pickMyFile(context);
                                        }),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: sm.w(4)),
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount:
                                              data.result?.files?.length ?? 0,
                                          itemBuilder: (_context, _index) =>
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        data.result
                                                            .files[_index].name,
                                                        textAlign:
                                                            TextAlign.left),
                                                    Text(
                                                        '${data.result.files[_index].size.toString()}kb',
                                                        textAlign:
                                                            TextAlign.right)
                                                  ],
                                                ),
                                              )),
                                    ),
                                  ]))),
                    ),
                  ),
                  Visibility(
                    visible: data.getNeedSubmit(),
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: sm.w(16), vertical: sm.h(4)),
                        child: RoundedButton(
                            clicker: () => data.funClaimAdd(context),
                            clr: Colors.red,
                            title: "Submit")),
                  )
                ],
              ),
            );
},)


    );
  }
}
