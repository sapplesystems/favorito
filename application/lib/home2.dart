import 'package:favorito/card1.dart';
import 'package:favorito/skipper.dart';
import 'package:favorito/toggleText.dart';
import 'package:favorito/toggleTextButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dart:developer' as developer;
import 'package:grouped_checkbox/grouped_checkbox.dart';
import 'package:easy_rich_text/easy_rich_text.dart';

class home2 extends StatefulWidget {
  @override
  _home2State createState() => _home2State();
}

class _home2State extends State<home2> {
  List<String> allItemList = ['Reach me on whatsapp', 'Green'];

  List<String> checkedItemList = ['Green', 'Yellow'];

  TextEditingController _controler = TextEditingController();
  FocusNode _focus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Stack(
            children: [
              skipper(),
              Column(children: [
                Container(
                  margin: EdgeInsets.only(top: context.isMobile ? 200 : 150),
                  alignment: Alignment.center,
                  child: SvgPicture.asset('assets/login.svg',
                      height: context.percentHeight * 30,
                      semanticsLabel: 'vector'),
                ),
                card1(),
                // roundedButton(
                //   title: "LOGIN",
                //   clr: Color(0xffdd2626),
                // ),
                // textFieldBasics(
                //     buttonsOne: ObjectFieldsBasic(
                //   //washing fee
                //   control: _controler,
                //   inputType: TextInputType.number,
                //   label: "label",
                //   enabls: true,
                //   iconVal: Icons.accessible,
                //   valid: true,
                //   readOnly: false,
                //   labelcolor: Colors.grey,
                //   from: _focus,
                //   fieldSubmit: (_) {
                //     fieldFocusChange(context, _focus, _focus);
                //   },
                // )),

                toggleText(
                    hint: "Hint",
                    label: "label",
                    tapper: () =>
                        developer.log('log me', name: 'my.app.category')),

                SizedBox(height: 30.50),
                toggleTextButton(
                    hint: "Hint",
                    label: "label",
                    tapper: () =>
                        developer.log('log me', name: 'my.app.category')),

                GroupedCheckbox(
                    itemList: allItemList,
                    checkedItemList: checkedItemList,
                    disabled: ['Black'],
                    onChanged: (itemList) {
                      setState(() {
                        checkedItemList = itemList;
                        print('SELECTED ITEM LIST $itemList');
                      });
                    },
                    orientation: CheckboxOrientation.VERTICAL,
                    checkColor: Colors.blue,
                    activeColor: Colors.red),
                EasyRichText(
                  "Received 88+ messages. Received 99+ messages",
                  patternList: [
                    //set hasSpecialCharacters to true
                    EasyRichTextPattern(
                      targetString: '99\\+',
                      style: TextStyle(color: Colors.blue),
                    ),
                    //or if you are familiar with regular expressions, then use \\ to skip it
                    EasyRichTextPattern(
                      targetString: '88\\+',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
