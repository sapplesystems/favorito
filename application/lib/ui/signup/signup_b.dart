import 'dart:ui';
import 'package:application/network/webservices.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:application/component/roundedButton.dart';
import 'package:application/component/txtfieldboundry.dart';
import 'package:application/ui/bottomNavigation/bottomNavigation.dart';
import 'package:application/utils/Regexer.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:velocity_x/velocity_x.dart';

class signup_b extends StatefulWidget {
  List<TextEditingController> preData;
  List catData;
  signup_b({this.preData, this.catData});

  @override
  _signup_bState createState() => _signup_bState();
}

class _signup_bState extends State<signup_b> {
  bool checked = false;
  List<String> busy = [];
  List<TextEditingController> ctrl = List();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _busKey = GlobalKey<State>();
  bool _autovalidate = false;
  var ddlabel;
  var namelabel;
  var maillabel;

  void initState() {
    super.initState();
    for (int i = 0; i < 5; i++) ctrl.add(TextEditingController());
    if (widget.preData[0].text.contains("Bus")) {
      ddlabel = "Contact Person Role";
      namelabel = "Contact Person Name";
      maillabel = "Business Email";
      busy = ["Owner", "Manager", "Employee"];
    } else {
      ddlabel = "Category";
      maillabel = "Email";
      namelabel = "Display Name";
    }

    // getBusiness();
    // getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfffff4f4),
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
      body: Container(
        color: Color(0xfffff4f4),
        height: context.percentHeight * 90,
        child: Stack(
          children: [
            Positioned(
              left: context.percentWidth * 30,
              right: context.percentWidth * 30,
              child: Text(
                "Sign Up",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: "Gilroy-Bold",
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
            Positioned(
              bottom: context.percentWidth * 6,
              left: context.percentWidth * 22,
              right: context.percentWidth * 22,
              child: roundedButton(
                clicker: () {
                  funSublim();
                },
                clr: Colors.red,
                title: "Done",
              ),
            ),
            Positioned(
              top: context.percentWidth * 30,
              left: context.percentWidth * 10,
              right: context.percentWidth * 10,
              child: Container(
                  height: context.percentWidth * 100,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  padding: EdgeInsets.only(
                    top: context.percentHeight * 8,
                    left: context.percentWidth * 2,
                    right: context.percentWidth * 2,
                  ),
                  child: Builder(
                    builder: (context) => Form(
                      key: _formKey,
                      autovalidate: _autovalidate,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: txtfieldboundry(
                                    valid: true,
                                    ctrl: ctrl[0],
                                    title: namelabel,
                                    security: false)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownSearch<String>(
                                  mode: Mode.MENU,
                                  maxHeight: busy.length * 58.0,
                                  showSelectedItem: true,
                                  items: busy,
                                  label: ddlabel,
                                  hint: "Please Select Business Type",
                                  // popupItemDisabled: (String s) => s.startsWith('I'),
                                  onChanged: (String val) {
                                    ctrl[1].text = val;

                                    setState(() {});
                                  },
                                  selectedItem: ctrl[1].text),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: txtfieldboundry(
                                    title: maillabel,
                                    valid: true,
                                    ctrl: ctrl[2],
                                    myregex: emailRegex,
                                    security: false)),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: txtfieldboundry(
                                    valid: true,
                                    maxLines: 1,
                                    ctrl: ctrl[3],
                                    title: "Password",
                                    security: true)),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: txtfieldboundry(
                                    valid: true,
                                    maxLines: 1,
                                    ctrl: ctrl[4],
                                    title: "Confirm Password",
                                    security: true)),
                            CheckboxListTile(
                              title: Text(
                                "By continuing, you agree to Favorito's\nTerms of Service and acknowledge\nFavorito's Privacy Policy.",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.32,
                                ),
                              ),
                              value: checked,
                              onChanged: (newValue) {
                                setState(() {
                                  checked = !checked;
                                });
                              },
                              controlAffinity: ListTileControlAffinity
                                  .leading, //  <-- leading Checkbox
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
            ),
            Positioned(
                top: context.percentWidth * 5,
                left: context.percentWidth * 30,
                right: context.percentWidth * 30,
                child: SvgPicture.asset('assets/icon/maskgroup.svg',
                    alignment: Alignment.center,
                    height: context.percentHeight * 20)),
          ],
        ),
      ),
    );
  }

  void funSublim() {
    if (ctrl[1].text == null || ctrl[0].text == "") {
      BotToast.showText(text: "Please check category");
      return;
    }
    if (!checked) {
      BotToast.showText(text: "Please check T&T");
      return;
    }
    if (_formKey.currentState.validate()) {
      _autovalidate = false;
      var cat = "";
      ;
      for (int i = 0; i < widget.catData.length; i++) {
        if (widget.catData[i].categoryName == widget.preData[2].text)
          cat = widget.catData[i].id.toString();
      }
      if (ctrl[3].text != ctrl[4].text) {
        BotToast.showText(text: "Please confirm your password!");
        return;
      }
      Map<String, dynamic> _map = {
        "business_type_id": widget.preData[0].text.contains("Bus") ? "1" : "2",
        "business_name": widget.preData[1].text,
        "business_category_id": cat,
        "postal_code": widget.preData[3].text,
        "business_phone": widget.preData[4].text,
        "email": ctrl[2].text,
        "password": ctrl[3].text,
        "reach_whatsapp": widget.preData[5].text,
        "display_name": ctrl[0].text,
        "role":
            widget.preData[0].text.contains("Bus") ? ctrl[1].text : "freelancer"
      };
      print("Request:${_map}");
      BotToast.showLoading(allowClick: true, duration: Duration(seconds: 1));
      WebService.funRegister(_map).then((value) {
        if (value.status == 'success') {
          BotToast.showText(text: "Registration SuccessFull!!");
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => bottomNavigation()));
        } else {
          BotToast.showText(text: value.message.toString());
        }
      });
    } else
      _autovalidate = true;
  }
}
