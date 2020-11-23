import 'package:bot_toast/bot_toast.dart';
import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/Login.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class Signup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      theme: NeumorphicThemeData(
          defaultTextColor: myRed,
          accentColor: Colors.grey,
          variantColor: Colors.black38,
          depth: 8,
          intensity: 0.65),
      usedTheme: UsedTheme.LIGHT,
      child: Material(
        child: NeumorphicBackground(
          child: _Signup(),
        ),
      ),
    );
  }
}

class _Signup extends StatelessWidget {
  bool _autoValidateForm = false;
  List controller = [for (int i = 0; i < 5; i++) TextEditingController()];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> title = ['Full Name', 'Phone', 'Email', 'Password', 'Postal'];
  List<String> prefix = ['name', 'phone', 'mail', 'password', 'postal'];
  bool newValue = false;
  bool newValue1 = false;

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Container(
      height: sm.scaledHeight(100),
      width: sm.scaledWidth(100),
      padding: EdgeInsets.symmetric(
          horizontal: sm.scaledWidth(10), vertical: sm.scaledHeight(5)),
      decoration: BoxDecoration(color: myBackGround),
      child: ListView(
        shrinkWrap: true,
        children: [
          SvgPicture.asset(
            'assets/icon/signup_image.svg',
            height: sm.scaledHeight(20),
            fit: BoxFit.fitHeight,
          ),
          Padding(
            padding: EdgeInsets.only(top: sm.scaledHeight(2)),
            child: Text(
              "Welcome.",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
          ),
          Container(
            child: Builder(
                builder: (context) => Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(children: [
                      for (int i = 0; i < title.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: EditTextComponent(
                            ctrl: controller[i],
                            title: title[i],
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
                                    : 20,
                            keyboardSet: i == 2
                                ? TextInputType.emailAddress
                                : (i == 1 || i == 4)
                                    ? TextInputType.phone
                                    : TextInputType.text,
                            prefixIcon: prefix[i],
                          ),
                        ),
                      tcp(
                        key: key,
                        sm: sm,
                        newValue: newValue,
                        newValue1: newValue1,
                        returnValue: (a, b) {
                          newValue = a;
                          newValue1 = b;
                        },
                      ),
                    ]))),
          ),
          Padding(
            padding: EdgeInsets.only(top: sm.scaledHeight(6)),
            child: NeumorphicButton(
              style: NeumorphicStyle(
                  shape: NeumorphicShape.convex,
                  depth: 4,
                  lightSource: LightSource.topLeft,
                  color: myButtonBackground),
              margin: EdgeInsets.symmetric(horizontal: sm.scaledWidth(10)),
              boxShape: NeumorphicBoxShape.roundRect(
                  BorderRadius.all(Radius.circular(24.0))),
              onClick: () {
                if (_formKey.currentState.validate()) {
                  if (!newValue) {
                    Map _map = {
                      "full_name": controller[0].text,
                      "email": controller[1].text,
                      "phone": controller[2].text,
                      "postal_code": controller[3].text,
                      "password": controller[4].text
                    };
                    APIManager.register(_map).then((value) {});
                  } else {
                    BotToast.showText(text: "Please check T&C.");
                  }
                }
              },
              isEnabled: true,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Center(
                child: Text(
                  "Submit",
                  style: TextStyle(fontWeight: FontWeight.w400, color: myRed),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: sm.scaledHeight(6)),
              child: Text(
                "Already have an account?",
                style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: sm.scaledHeight(1)),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
                child: Text(
                  "Login",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18, color: myRed),
                ),
              ),
            ),
          ),
        ],
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
      padding: EdgeInsets.only(top: widget.sm.scaledHeight(1)),
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
