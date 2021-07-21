import 'dart:ui';
import 'package:Favorito/Provider/SignUpProvider.dart';
import 'package:Favorito/ui/Terms_of_service/termsofservice.dart';
import 'package:Favorito/ui/privacypolicy/privacypolicy.dart';
import 'package:Favorito/utils/RIKeys.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/utils/Regexer.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:provider/provider.dart';

class signup_b extends StatelessWidget {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SignUpProvider signUpProviderTrue;
  SignUpProvider signUpProviderFalse;

  @override
  Widget build(BuildContext context) {
    signUpProviderTrue = Provider.of<SignUpProvider>(context, listen: true);
    signUpProviderFalse = Provider.of<SignUpProvider>(context, listen: false);
    signUpProviderFalse.setContext(context);
    String passNotSameTxt;
    SizeManager sm = SizeManager(context);
    return Scaffold(
      key: RIKeys.josKeys24,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: ListView(
        children: [
          Text(
            "Sign Up",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: "Gilroy-Bold",
                fontWeight: FontWeight.w700,
                letterSpacing: 1),
          ),
          Container(
            color: myBackGround,
            height: sm.h(95),
            child: Stack(
              children: [
                Positioned(
                  top: sm.w(30),
                  left: sm.w(6),
                  right: sm.w(6),
                  child: Card(
                    elevation: 8,
                    shadowColor: Colors.grey.withOpacity(0.2),
                    child: Container(
                        // height: sm.w(100),
                        padding: EdgeInsets.only(
                          top: sm.h(8),
                          bottom: sm.h(2),
                          left: sm.w(4),
                          right: sm.w(4),
                        ),
                        child: Builder(
                          builder: (context) => Form(
                            key: _formKey,
                            child: ListView(
                                shrinkWrap: true,
                                physics: new NeverScrollableScrollPhysics(),
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: txtfieldboundry(
                                          valid: true,
                                          inputTextSize: 16,
                                          controller:
                                              signUpProviderTrue.controller[3],
                                          title:
                                              signUpProviderTrue.getTypeId() ==
                                                      1
                                                  ? 'Contact Person Name'
                                                  : 'Display Name',
                                          security: false)),
                                  signUpProviderTrue.catvisib
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: DropdownSearch<String>(
                                            key: SignUpProvider.categoryKey2,
                                            mode: Mode.MENU,
                                            maxHeight:
                                                signUpProviderTrue.busy.length *
                                                    58.0,
                                            // showSelectedItem: true,
                                            items: signUpProviderTrue.busy,
                                            label: 'Contact Person Role',
                                            hint: 'Contact Person Role',
                                            onChanged: (String val) =>
                                                signUpProviderTrue
                                                    .controller[4].text = val,
                                            selectedItem: signUpProviderTrue
                                                .controller[4].text,
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8, top: 2),
                                          child: DropdownSearch<String>(
                                            mode: Mode.MENU,
                                            // maxHeight: busy.length * 58.0,
                                            validator: (v) => (v == '')
                                                ? "required field"
                                                : null,
                                            autoValidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            showSelectedItem: true,
                                            showSearchBox: true,
                                            items: signUpProviderTrue
                                                .getCategoryAll(),
                                            label: signUpProviderTrue
                                                        .getTypeId() ==
                                                    1
                                                ? "Business Category"
                                                : "Category",
                                            hint:
                                                "Please Select Business Category",
                                            onChanged: (val) =>
                                                signUpProviderTrue
                                                    .setCategoryIdByName(val),
                                            selectedItem: signUpProviderTrue
                                                .getCategoryName(),
                                          ),
                                        ),
                                  txtfieldboundry(
                                      keyboardSet: TextInputType.emailAddress,
                                      title: signUpProviderTrue.getTypeId() == 1
                                          ? 'Business Email'
                                          : 'Email',
                                      valid: true,
                                      inputTextSize: 16,
                                      controller:
                                          signUpProviderTrue.controller[5],
                                      myregex: emailRegex,
                                      myOnChanged: (c) =>
                                          signUpProviderTrue.refresh(),
                                      security: false),
                                  Visibility(
                                    visible:
                                        signUpProviderTrue.mailError != null,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Text(
                                        signUpProviderTrue.mailError ?? '',
                                        style: TextStyle(color: myRed),
                                      ),
                                    ),
                                  ),
                                  txtfieldboundry(
                                      valid: true,
                                      inputTextSize: 16,
                                      maxLines: 1,
                                      controller:
                                          signUpProviderTrue.controller[6],
                                      title: "Password",
                                      error: signUpProviderTrue.passError,
                                      myOnChanged: (_v) => signUpProviderTrue
                                          .validatePassword(_v),
                                      security: true),
                                  txtfieldboundry(
                                      inputTextSize: 16,
                                      valid: true,
                                      maxLines: 1,
                                      controller:
                                          signUpProviderTrue.controller[7],
                                      title: "Confirm Password",
                                      error: signUpProviderTrue.passError1,
                                      myOnChanged: (_v) => signUpProviderTrue
                                          .validatePassword1(_v),
                                      security: true),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: sm.h(1)),
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value: signUpProviderTrue
                                              .getTnCChecked(),
                                          onChanged: (newValue) =>
                                              signUpProviderTrue
                                                  .setTnCChecked(newValue),
                                        ),
                                        RichText(
                                            text: TextSpan(
                                          text:
                                              "By continuing, you agree to Favorito's\n",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                              fontFamily: "Roboto",
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.32),
                                          children: [
                                            TextSpan(
                                                recognizer: new TapGestureRecognizer()
                                                  ..onTap = () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              TermsOfServicePage())),
                                                text: "Terms of Service ",
                                                style: TextStyle(
                                                    color: myRed,
                                                    fontSize: 12,
                                                    fontFamily: "Roboto",
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0.32)),
                                            TextSpan(
                                                text:
                                                    "and acknowledge\nFavorito's "),
                                            TextSpan(
                                                recognizer: new TapGestureRecognizer()
                                                  ..onTap = () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              PrivacyPolicy())),
                                                text: "Privacy Policy.",
                                                style: TextStyle(
                                                    color: myRed,
                                                    fontSize: 12,
                                                    fontFamily: "Roboto",
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0.32))
                                          ],
                                        ))
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                        )),
                  ),
                ),
                Positioned(
                    top: sm.w(8),
                    left: sm.w(30),
                    right: sm.w(30),
                    child: SvgPicture.asset('assets/icon/maskgroup.svg',
                        alignment: Alignment.center, height: sm.h(20)))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sm.w(20)),
            child: RoundedButton(
              clicker: () => funSublim(),
              clr: Colors.red,
              title: "Done",
            ),
          ),
        ],
      ),
    );
  }

  void funSublim() {
    if (_formKey.currentState.validate()) {
      if (signUpProviderTrue.mailError != null) return;

      if (!signUpProviderTrue.getTnCChecked()) {
        BotToast.showText(text: "Please confirm T&C!");
        return;
      }
      signUpProviderTrue.funRegister();
    }
  }
}
