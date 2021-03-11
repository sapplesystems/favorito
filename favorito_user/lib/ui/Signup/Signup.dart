import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/ui/Login.dart';
import 'package:favorito_user/ui/Signup/SignupProvider.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/Validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class Signup extends StatelessWidget {
  SignupProvider vaTrue;
  SignupProvider spFalse;
  SizeManager sm;
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    vaTrue = Provider.of<SignupProvider>(context, listen: true);
    spFalse = Provider.of<SignupProvider>(context, listen: false);
    vaTrue.setContext(context);
    return WillPopScope(
      onWillPop: () {
        vaTrue.allClear();
        Navigator.pop(context);
      },
      child: Scaffold(
        key: vaTrue.scaffoldKey,
        body: Container(
          height: sm.h(100),
          width: sm.w(100),
          padding: EdgeInsets.symmetric(horizontal: sm.w(10)),
          decoration: BoxDecoration(color: myBackGround),
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: EdgeInsets.only(top: sm.h(1)),
                child: SvgPicture.asset(
                  'assets/icon/signup_image.svg',
                  height: sm.h(20),
                  fit: BoxFit.fitHeight,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: sm.h(2)),
                child: Text(
                  "Welcome.",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                ),
              ),
              Container(
                child: Builder(
                    builder: (context) => Form(
                        key: spFalse.formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (int i = 0; i < spFalse.title.length; i++)
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: EditTextComponent(
                                    ctrl: vaTrue.acces[i].controller,
                                    title: vaTrue.title[i],
                                    hint: vaTrue.title[i],
                                    errorColor: vaTrue.errorColor[i],
                                    myOnChanged: (s) {
                                      if (i == 6) {
                                        vaTrue.acces[i].error =
                                            Validator().validateId(s);
                                        if (!s.toString().contains('@')) {
                                          vaTrue.acces[i].controller.text = '';
                                        } else {
                                          vaTrue.setCheckId('verify');
                                        }
                                      }
                                      spFalse.onChange(i);
                                    },
                                    suffixTap: () => vaTrue.checkIdClicked(i),
                                    suffixTxt:
                                        i == 6 ? vaTrue.getCheckId() : '',
                                    error: vaTrue.acces[i].error,
                                    security: i == 3 ? true : false,
                                    valid: true,
                                    maxLines: 1,
                                    formate: (i == 1 || i == 4)
                                        ? FilteringTextInputFormatter.digitsOnly
                                        : FilteringTextInputFormatter
                                            .singleLineFormatter,
                                    maxlen: i == 1
                                        ? 10
                                        : i == 4
                                            ? 6
                                            : 50,
                                    keyboardSet: i == 2
                                        ? TextInputType.emailAddress
                                        : (i == 1 || i == 4)
                                            ? TextInputType.phone
                                            : TextInputType.text,
                                    prefixIcon: vaTrue.prefix[i],
                                  ),
                                ),
                              Padding(
                                padding: EdgeInsets.only(left: 50),
                                child: Text(vaTrue.checkIdMessage,
                                    style: TextStyle(color: myGreyDark)),
                              ),
                              tcp(
                                key: key,
                                sm: sm,
                                newValue: vaTrue.newValue,
                                newValue1: vaTrue.newValue1,
                                returnValue: (a, b) {
                                  vaTrue.newValue = a;
                                  vaTrue.newValue1 = b;
                                },
                              ),
                            ]))),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: sm.h(4)),
                  child: Text(
                    "Already have an account?",
                    style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: sm.h(1)),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Text("Login",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: myRed)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: sm.h(4)),
                child: NeumorphicButton(
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.convex,
                      depth: 4,
                      lightSource: LightSource.topLeft,
                      color: myButtonBackground,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.all(Radius.circular(24.0)))),
                  margin: EdgeInsets.symmetric(horizontal: sm.w(10)),
                  onPressed: () => vaTrue.funSubmit(),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Center(
                    child: Text(
                      "Submit",
                      style:
                          TextStyle(fontWeight: FontWeight.w400, color: myRed),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class tcp extends StatefulWidget {
  tcp({
    Key key,
    @required this.sm,
    @required this.newValue,
    @required this.newValue1,
    @required this.returnValue,
  }) : super(key: key);

  final SizeManager sm;
  bool newValue;
  bool newValue1;
  Function returnValue;
  @override
  _tcpState createState() => _tcpState();
}

class _tcpState extends State<tcp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: widget.sm.h(1)),
      child: Column(
        children: [
          t_c(
            isChecked: widget.newValue,
            title:
                "By continuing, you agree to Favorito's Terms of Service and acknowledge Favorito's Privacy Policy",
            function: (v) {
              print("${widget.key}");
              setState(() {
                widget.newValue = v;
                widget.returnValue(widget.newValue, widget.newValue1);
              });
            },
          ),
          t_c(
            isChecked: widget.newValue1,
            title: "Reach me on watsapp",
            function: (vv) {
              setState(() {
                widget.newValue1 = vv;
                widget.returnValue(widget.newValue, widget.newValue1);
              });
            },
          ),
        ],
      ),
    );
  }
}

class t_c extends StatelessWidget {
  final isChecked;
  final title;
  Function function;
  t_c({Key key, this.isChecked, this.title, this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: function,
          ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.4,
                  color: myGrey),
            ),
          )
        ],
      ),
    );
  }
}
