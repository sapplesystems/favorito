import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldPostAction.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/ui/ResetPass/ResetPassProvider.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPass extends StatelessWidget {
  ResetPassProvider cpTrue;
  SizeManager sm;
  @override
  Widget build(BuildContext context) {
    cpTrue = Provider.of<ResetPassProvider>(context, listen: true);
    sm = SizeManager(context);
    cpTrue.setContext(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Reset Password",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontFamily: "Gilroy-Reguler",
            fontWeight: FontWeight.w600,
            letterSpacing: 1),
      )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Builder(
          builder: (context) => Form(
            key: cpTrue.formKey,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  for (int i = 0; i < 3; i++)
                    Padding(
                        padding: EdgeInsets.only(top: sm.h(1)),
                        child: txtfieldPostAction(
                          valid: true,
                          maxLines: 1,
                          hint: "Password",
                          title: cpTrue.title[i],
                          errorText: cpTrue.passError[i],
                          controller: cpTrue.controller[i],
                          security: cpTrue.security[i] != Icons.visibility,
                          myOnChanged: (n) => cpTrue.passwordSame(),
                          sufixColor: myRed,
                          sufixClick: () => cpTrue.sufixClick(i),
                          sufixIcon: cpTrue.security[i],
                        )),
                  Visibility(
                    visible: cpTrue.buttonVisible,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: sm.w(60),
                        margin: EdgeInsets.only(top: 10),
                        child: RoundedButton(
                            clicker: () => cpTrue.funSubmit(context),
                            clr: Colors.red,
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: "Gilroy-Bold",
                                fontWeight: FontWeight.w400,
                                letterSpacing: 1.5),
                            title: 'Done'),
                      ),
                    ),
                  )
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
