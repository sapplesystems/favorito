import 'dart:async';

import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/ui/Login/LoginController.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/RIKeys.dart';
import 'package:favorito_user/utils/Regexer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class UpdateEmail extends StatelessWidget {
  LoginProvider vaTrue;
  LoginProvider vaFalse;
  bool isFirst = true;
  @override
  Widget build(BuildContext context) {
    vaTrue = Provider.of<LoginProvider>(context, listen: true);
    vaFalse = Provider.of<LoginProvider>(context, listen: false);
    if (isFirst) {
      vaTrue.setShowSubmit(false);
      vaTrue.allClear();
      isFirst = false;
    }
    return Scaffold(
      key: RIKeys.josKeys15,
      // backgroundColor: myBackGround,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Update Email',
            style: Theme.of(context).textTheme.headline6.copyWith(
                fontWeight: FontWeight.w600, letterSpacing: .4, fontSize: 20)),
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.only(left: 30.0, bottom: 20, top: 20),
          child: Text('Email : ${vaTrue.getEmail() ?? ''}',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.w400, fontSize: 18)),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: EditTextComponent(
            controller: vaTrue.controller[0],
            hint: 'Email',
            security: false,
            valid: true,
            suffixTap: () {},
            suffixTxt: null,
            maxLines: 1,
            error: vaTrue.controller[0].text.length > 0
                ? vaTrue.getErrorEmail()
                : null,
            myOnChanged: (va) {
              vaTrue.clearErrorEmail();
              Timer _debounce;
              int _debouncetime = 2;
              if (_debounce?.isActive ?? false) _debounce.cancel();
              _debounce = Timer(Duration(seconds: _debouncetime), () {
                if (vaTrue.controller[0].text != "") vaTrue.emailCheck(va);
              });
            },
            myregex: emailRegex,
            formate: FilteringTextInputFormatter.singleLineFormatter,
            maxlen: 50,
            keyboardSet: TextInputType.emailAddress,
            prefixIcon: 'mail',
          ),
        ),
        Visibility(
          visible: vaTrue.getShowSubmit(),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
              child: NeumorphicButton(
                style: NeumorphicStyle(
                    shape: NeumorphicShape.concave,
                    // depth: 11,
                    intensity: 40,
                    surfaceIntensity: -.4,
                    // lightSource: LightSource.topLeft,
                    color: myButtonBackground,
                    boxShape: NeumorphicBoxShape.roundRect(
                        BorderRadius.all(Radius.circular(24.0)))),
                margin: EdgeInsets.symmetric(horizontal: 10),
                onPressed: () => vaTrue.saveUserEmail(RIKeys.josKeys15),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Center(
                    child: Text("Submit",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Gilroy-Light',
                            color: myRed))),
              )),
        ),
      ]),
    );
  }
}
