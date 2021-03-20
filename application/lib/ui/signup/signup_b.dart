import 'dart:ui';
import 'package:Favorito/Provider/SignUpProvider.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/utils/Regexer.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:provider/provider.dart';

class signup_b extends StatelessWidget {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var signUpProviderTrue;
  var signUpProviderFalse;

  @override
  Widget build(BuildContext context) {
    signUpProviderTrue = Provider.of<SignUpProvider>(context, listen: true);
    signUpProviderFalse = Provider.of<SignUpProvider>(context, listen: false);
    signUpProviderFalse.setContext(context);
    SizeManager sm = SizeManager(context);
    return Scaffold(
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
            height: sm.w(180),
            child: Stack(
              children: [
                Positioned(
                  top: sm.w(30),
                  left: sm.w(6),
                  right: sm.w(6),
                  child: Card(
                    child: Container(
                        // height: sm.w(100),
                        padding: EdgeInsets.only(
                          top: sm.h(8),
                          bottom: sm.h(8),
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
                                        controller:
                                            signUpProviderTrue.controller[3],
                                        title:
                                            signUpProviderTrue.getTypeId() == 1
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
                                          label:
                                              signUpProviderTrue.getTypeId() ==
                                                      1
                                                  ? "Business Category"
                                                  : "Category",
                                          hint:
                                              "Please Select Business Category",
                                          onChanged: (val) => signUpProviderTrue
                                              .setCategoryIdByName(val),
                                          selectedItem: signUpProviderTrue
                                              .getCategoryName(),
                                        ),
                                      ),
                                txtfieldboundry(
                                    title: signUpProviderTrue.getTypeId() == 1
                                        ? 'Business Email'
                                        : 'Email',
                                    valid: true,
                                    controller:
                                        signUpProviderTrue.controller[5],
                                    myregex: emailRegex,
                                    security: false),
                                txtfieldboundry(
                                    valid: true,
                                    maxLines: 1,
                                    controller:
                                        signUpProviderTrue.controller[6],
                                    title: "Password",
                                    security: true),
                                txtfieldboundry(
                                    valid: true,
                                    maxLines: 1,
                                    controller:
                                        signUpProviderTrue.controller[7],
                                    title: "Confirm Password",
                                    security: true),
                                CheckboxListTile(
                                  title: Text(
                                    "By continuing, you agree to Favorito's\nTerms of Service and acknowledge\nFavorito's Privacy Policy.",
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.32,
                                    ),
                                  ),
                                  value: signUpProviderTrue.getTnCChecked(),
                                  onChanged: (newValue) => signUpProviderTrue
                                      .setTnCChecked(newValue),
                                  controlAffinity: ListTileControlAffinity
                                      .leading, //  <-- leading Checkbox
                                ),
                              ],
                            ),
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
            padding:
                EdgeInsets.symmetric(horizontal: sm.w(20), vertical: sm.w(10)),
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
      if (signUpProviderTrue.controller[6].text !=
          signUpProviderTrue.controller[7].text) {
        signUpProviderTrue.controller[6].text = "";
        signUpProviderTrue.controller[7].text = "";
        BotToast.showText(text: "Please confirm your password!");
        return;
      }
      if (!signUpProviderTrue.getTnCChecked()) {
        BotToast.showText(text: "Please confirm T&C!");
        return;
      }
      signUpProviderTrue.funRegister();
    }
  }
}
