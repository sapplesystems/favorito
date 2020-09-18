import 'package:application/component/roundedButton.dart';
import 'package:application/component/txtfieldboundry.dart';
import 'package:application/model/CatListModel.dart';
import 'package:application/model/busyListModel.dart';
import 'package:application/myCss.dart';
import 'package:application/network/webservices.dart';
import 'package:application/ui/signup/signup_b.dart';
import 'package:application/utils/Regexer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:bot_toast/bot_toast.dart';

class signup_a extends StatefulWidget {
  @override
  _signup_aState createState() => _signup_aState();
}

class _signup_aState extends State<signup_a> {
  List<String> busy = [];
  List<String> cat = [];
  List<catData> catdata = [];
  List<busData> busdata = [];
  bool _autovalidate = false;
  bool catvisib = false;
  String type_id;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _busKey = GlobalKey<State>();
  final GlobalKey<State> _vatKey = GlobalKey<State>();
  List<TextEditingController> ctrl = List();
  bool checked = false;
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 6; i++) ctrl.add(TextEditingController());

    getBusiness();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xfffff4f4),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.refresh, color: Colors.black),
                onPressed: () {
                  BotToast.showLoading(
                      allowClick: true, duration: Duration(seconds: 1));
                  getBusiness();
                })
          ]),
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
              bottom: context.percentWidth * 4,
              left: context.percentWidth * 20,
              right: context.percentWidth * 20,
              child: roundedButton(
                  clicker: () {
                    if (ctrl[0].text == null || ctrl[0].text == "") {
                      BotToast.showText(text: "Please check Business Type");
                      return;
                    }
                    if (catvisib &&
                        (ctrl[2].text == null || ctrl[2].text == "")) {
                      BotToast.showText(text: "Please check Business category");
                      return;
                    }

                    if (_formKey.currentState.validate()) {
                      _autovalidate = false;
                      ctrl[5].text = checked.toString();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  signup_b(preData: ctrl, catData: catdata)));
                    } else
                      _autovalidate = true;
                  },
                  clr: Colors.red,
                  title: "Next"),
            ),
            Positioned(
              top: context.percentWidth * 30,
              left: context.percentWidth * 10,
              right: context.percentWidth * 10,
              child: Container(
                  height: context.percentWidth * 100,
                  decoration: bd1,
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
                              child: DropdownSearch<String>(
                                  mode: Mode.MENU,
                                  maxHeight: busy.length * 58.0,
                                  showSelectedItem: true,
                                  items: busy,
                                  label: "Business Type",
                                  hint: "Please Select Business Type",
                                  // popupItemDisabled: (String s) => s.startsWith('I'),
                                  onChanged: (String val) {
                                    ctrl[0].text = val;
                                    if (val.contains("Bus")) {
                                      type_id = "1";
                                      catvisib = true;
                                      getCategory();
                                    } else {
                                      type_id = "0";
                                      catvisib = false;
                                    }
                                    setState(() {});
                                  },
                                  selectedItem: ctrl[0].text),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: txtfieldboundry(
                                    valid: true,
                                    ctrl: ctrl[1],
                                    title: "Business Name",
                                    security: false)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Visibility(
                                  visible: catvisib,
                                  child: DropdownSearch<String>(
                                      mode: Mode.MENU,
                                      maxHeight: busy.length * 58.0,
                                      showSelectedItem: true,
                                      items: cat,
                                      label: "Business Category",
                                      hint: "Please Select Business Category",
                                      // popupItemDisabled: (String s) => s.startsWith('I'),
                                      onChanged: (val) {
                                        ctrl[2].text = val;
                                        setState(() {});
                                      },
                                      selectedItem: ctrl[2].text)),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: txtfieldboundry(
                                    ctrl: ctrl[3],
                                    valid: true,
                                    title: "Postal Code",
                                    security: false)),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: txtfieldboundry(
                                    ctrl: ctrl[4],
                                    valid: true,
                                    title:
                                        catvisib ? "Business Phone" : "Phone",
                                    maxlen: 10,
                                    keyboardSet: TextInputType.number,
                                    myregex: mobileRegex,
                                    security: false)),
                            CheckboxListTile(
                              title: Text(
                                "Reach me on whatsapp",
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
                                  ctrl[5].text = checked.toString();
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

  void getCategory() {
    WebService.funGetCatList({"type_id": type_id}).then((value) {
      cat.clear();
      catdata.clear();
      catdata.addAll(value.data);
      for (int i = 0; i < value.data.length; i++) {
        setState(() {
          cat.add(value.data[i].categoryName);
        });
      }
      print(catdata.toString());
    });
  }

  void getBusiness() {
    WebService.funGetBusyList().then((value) {
      busy.clear();
      busdata.clear();
      busdata.addAll(value.data);
      for (int i = 0; i < value.data.length; i++) {
        setState(() {
          busy.add(value.data[i].typeName);
        });
      }
      print(busdata.toString());
    });
  }
}
