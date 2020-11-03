import 'package:Favorito/utils/Regexer.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import '../../component/DatePicker.dart';
import '../../component/TimePicker.dart';
import '../../component/roundedButton.dart';
import '../../component/txtfieldboundry.dart';
import 'package:Favorito/component/DatePicker.dart';
import 'package:Favorito/component/TimePicker.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:bot_toast/bot_toast.dart';
import '../../config/SizeManager.dart';

class ManualAppoinment extends StatefulWidget {
  @override
  _ManualAppoinment createState() => _ManualAppoinment();
}

class _ManualAppoinment extends State<ManualAppoinment> {
  SizeManager sm;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _selectedDateText = '';
  String _selectedTimeText = '';
  List<TextEditingController> controller = List();

  TimeOfDay _intitialTime;

  DateTime _initialDate;

  initializeDefaultValues() {
    _intitialTime = TimeOfDay.now();
    setState(() => _initialDate = DateTime.now());
  }

  @override
  void initState() {
    for (int i = 0; i < 7; i++) controller.add(TextEditingController());
    getPageData();
    setState(() {
      initializeDefaultValues();
    });
    controller[0].text = 'Select Date';
    controller[1].text = 'Select Time';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Scaffold(
        backgroundColor: myBackGround,
        appBar: AppBar(
          backgroundColor: myBackGround,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title:
              Text("Manual Appointment", style: TextStyle(color: Colors.black)),
        ),
        body: ListView(children: [
          Padding(
              padding: EdgeInsets.all(8),
              child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  child: Builder(
                      builder: (context) => Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(
                                          width: sm.scaledWidth(40),
                                          child: DatePicker(
                                            selectedDateText:
                                                controller[0].text,
                                            selectedDate: _initialDate,
                                            onChanged: ((value) {
                                              controller[0].text = value;
                                            }),
                                          ),
                                        ),
                                        SizedBox(
                                          width: sm.scaledWidth(40),
                                          child: TimePicker(
                                            selectedTimeText:
                                                controller[1].text,
                                            selectedTime: _intitialTime,
                                            onChanged: ((value) {
                                              print("value $value");
                                              controller[1].text = value;
                                            }),
                                          ),
                                        ),
                                      ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: txtfieldboundry(
                                    controller: controller[2],
                                    title: "Name",
                                    security: false,
                                    valid: true,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: txtfieldboundry(
                                    controller: controller[3],
                                    title: "Contact",
                                    security: false,
                                    maxlen: 10,
                                    myregex: mobileRegex,
                                    keyboardSet: TextInputType.number,
                                    valid: true,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 24),
                                  child: DropdownSearch<String>(
                                      validator: (v) =>
                                          v == '' ? "required field" : null,
                                      autoValidate: true,
                                      mode: Mode.MENU,
                                      selectedItem: controller[4].text,
                                      items: [],
                                      label: "Service",
                                      hint: "Please Select Service",
                                      showSearchBox: false,
                                      onChanged: (value) => setState(
                                          () => controller[4].text = value)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: txtfieldboundry(
                                    controller: controller[5],
                                    title: "Person",
                                    keyboardSet: TextInputType.number,
                                    security: false,
                                    valid: true,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: txtfieldboundry(
                                    controller: controller[6],
                                    title: "Special Notes",
                                    security: false,
                                    maxLines: 5,
                                    valid: true,
                                  ),
                                ),
                              ]))))),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: sm.scaledWidth(15), vertical: 16.0),
            child: roundedButton(
              clicker: () {
                if (_formKey.currentState.validate()) {
                  if (controller[0].text == 'Select Date') {
                    BotToast.showText(text: "Please select a date");
                    return;
                  }
                  if (controller[1].text == 'Select Time') {
                    BotToast.showText(text: "Please select a time");
                    return;
                  }
                  Map<String, dynamic> _map = {
                    "created_date": controller[0].text,
                    "created_time": controller[1].text,
                    "name": controller[2].text,
                    "contact": controller[3].text,
                    "service_id": controller[4].text,
                    "person_id": controller[5].text,
                    "special_notes": controller[6].text
                  };
                  WebService.funAppoinmentCreate(_map).then((value) {
                    BotToast.showText(text: value.message);
                    initializeDefaultValues();
                  });
                }
              },
              clr: Colors.red,
              title: "Save",
            ),
          ),
        ]));
  }

  void getPageData() {
    WebService.funAppoinmentDetail().then((value) {
      if (value.status == "success") {
        // controller[0].text = value.data[]
      }
    });
  }
}
