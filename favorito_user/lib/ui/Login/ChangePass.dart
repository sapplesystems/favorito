import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/ui/Login/LoginController.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/RIKeys.dart';
import 'package:favorito_user/utils/Regexer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class ChangePass extends StatelessWidget {
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
      key: RIKeys.josKeys17,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: myBackGround,
        title: Text('Change Password'),
      ),
      backgroundColor: myBackGround,
      body: ListView(children: [
        for (int i = 0; i < 2; i++)
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: EditTextComponent(
              controller: vaTrue.controller[i],
              hint: 'Password',
              security: true,
              valid: true,
              suffixTap: () {},
              suffixTxt: null,
              maxLines: 1,
              error: vaTrue.controller[i].text.length > 0
                  ? vaTrue.getErrorPass(i)
                  : null,
              myOnChanged: (va) {
                if (vaTrue.controller[i].text != "")
                  vaTrue.passwordCheck(va, i);
              },
              myregex: passwordRegex,
              formate: FilteringTextInputFormatter.singleLineFormatter,
              maxlen: 50,
              keyboardSet: TextInputType.emailAddress,
              prefixIcon: 'password',
            ),
          ),
        Visibility(
          visible: vaTrue.getErrorPass(0) == null &&
              vaTrue.getErrorPass(1) == null &&
              vaTrue.controller[0].text.length > 0,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
              child: NeumorphicButton(
                style: NeumorphicStyle(
                    shape: NeumorphicShape.concave,
                    depth: 11,
                    intensity: 40,
                    surfaceIntensity: -.4,
                    // lightSource: LightSource.topLeft,
                    color: Color(0xffedf0f5),
                    boxShape: NeumorphicBoxShape.roundRect(
                        BorderRadius.all(Radius.circular(24.0)))),
                margin: EdgeInsets.symmetric(horizontal: 10),
                onPressed: () => vaTrue.updatePassword(RIKeys.josKeys17),
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
