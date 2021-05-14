import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/ui/user/PersonalInfo/PersonalInfoProvider.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/RIKeys.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class PersonalInfo extends StatelessWidget {
  PersonalInfoProvider spTrue;
  PersonalInfoProvider spFalse;
  SizeManager sm;
  bool isFirst = true;

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    spTrue = Provider.of<PersonalInfoProvider>(context, listen: true);
    spFalse = Provider.of<PersonalInfoProvider>(context, listen: false);
    spTrue.setContext(context);
    if (isFirst) {
      spTrue.getPersonalData();
      isFirst = false;
    }
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
        },
        child: SafeArea(
            key: RIKeys.josKeys10,
            child: Scaffold(
                // backgroundColor: myBackGround,
                body: Padding(
                    padding: EdgeInsets.symmetric(horizontal: sm.w(10)),
                    child: ListView(shrinkWrap: true, children: [
                      Padding(
                          padding: EdgeInsets.only(top: sm.h(1)),
                          child: SvgPicture.asset(
                              'assets/icon/signup_image.svg',
                              height: sm.h(20),
                              fit: BoxFit.fitHeight)),
                      Padding(
                        padding: EdgeInsets.only(top: sm.h(2)),
                        child: Text(
                          "Hi! ${spTrue.acces[0].controller.text}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 28),
                        ),
                      ),
                      Builder(
                          builder: (context) => Form(
                              key: spFalse.formKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: Column(children: [
                                for (int i = 0; i < spFalse.title.length; i++)
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: sm.h(4),
                                        left: sm.w(4),
                                        right: sm.w(4)),
                                    // padding: const EdgeInsets.symmetric(
                                    //     vertical: 4.0),
                                    child: EditTextComponent(
                                      controller: spTrue.acces[i].controller,
                                      title: spTrue.title[i],
                                      hint: spTrue.title[i],
                                      myOnChanged: (val) {
                                        if (i == 1 && val.length == 6) {
                                          print("its:$i,$val");
                                          spTrue.checkPin(i, RIKeys.josKeys10);
                                        }
                                        if (i == 1) spTrue.notifyListeners();
                                      },
                                      // suffixTap: () => spTrue.checkIdClicked(i),
                                      suffixTxt: '',
                                      error: spTrue.acces[i].error,
                                      security: false,
                                      valid: true,
                                      maxLines: (spFalse.title.length - 1) == i
                                          ? 8
                                          : 1,
                                      formate: FilteringTextInputFormatter
                                          .singleLineFormatter,
                                      maxlen: i == 1 ? 6 : 50,

                                      keyboardSet: i == 1
                                          ? TextInputType.phone
                                          : TextInputType.text,
                                      prefixIcon:
                                          (spFalse.title.length - 1) != i
                                              ? spTrue.prefix[i]
                                              : null,
                                    ),
                                  ),
                                tcp(
                                  key: key,
                                  sm: sm,
                                  newValue: spTrue.newValue,
                                  returnValue: (a) {
                                    spTrue.newValue = a;
                                  },
                                ),
                              ]))),
                      Visibility(
                        visible:
                            (spTrue.acces[1].controller.text.length == 6) &&
                                (spTrue.acces[1].error == null) &&
                                (spTrue.acces[0].controller.text.length > 1),
                        child: Padding(
                            padding: EdgeInsets.only(top: sm.h(4)),
                            child: NeumorphicButton(
                                style: NeumorphicStyle(
                                    shape: NeumorphicShape.convex,
                                    // depth: 4,
                                    lightSource: LightSource.topLeft,
                                    color: myButtonBackground,
                                    boxShape: NeumorphicBoxShape.roundRect(
                                        BorderRadius.all(
                                            Radius.circular(24.0)))),
                                margin:
                                    EdgeInsets.symmetric(horizontal: sm.w(10)),
                                onPressed: () => spTrue.setPersonalData(),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                child: Center(
                                    child: Text("Submit",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: myRed))))),
                      )
                    ])))));
  }
}

class tcp extends StatefulWidget {
  tcp({
    Key key,
    @required this.sm,
    @required this.newValue,
    @required this.returnValue,
  }) : super(key: key);

  final SizeManager sm;
  bool newValue;
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
            title: "Reach me on whatsapp",
            function: (vv) {
              setState(() {
                widget.newValue = vv;
                widget.returnValue(widget.newValue);
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
            activeColor: myRed,
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
