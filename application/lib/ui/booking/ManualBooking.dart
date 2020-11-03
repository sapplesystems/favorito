import 'package:Favorito/utils/Regexer.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';
import '../../component/DatePicker.dart';
import '../../component/TimePicker.dart';
import '../../component/roundedButton.dart';
import '../../component/txtfieldboundry.dart';

import 'package:Favorito/component/DatePicker.dart';
import 'package:Favorito/component/TimePicker.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/model/booking/CreateBookingModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:bot_toast/bot_toast.dart';
import '../../config/SizeManager.dart';

class ManualBooking extends StatefulWidget {
  @override
  _ManualBooking createState() => _ManualBooking();
}

class _ManualBooking extends State<ManualBooking> {
  SizeManager sm;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidateForm = false;

  String _selectedDateText = '';
  String _selectedTimeText = '';

  final _myNameEditController = TextEditingController();
  final _myContactEditController = TextEditingController();
  final _myNoOfPersonEditController = TextEditingController();
  final _myNotesEditController = TextEditingController();

  TimeOfDay _intitialTime;

  DateTime _initialDate;

  initializeDefaultValues() {
    _autoValidateForm = false;
    _myNameEditController.text = '';
    _myContactEditController.text = '';
    _myNoOfPersonEditController.text = '';
    _myNotesEditController.text = '';
    _selectedDateText = 'Select Date';
    _selectedTimeText = 'Select Time';
    _intitialTime = TimeOfDay.now();
    setState(() => _initialDate = DateTime.now());
  }

  @override
  void initState() {
    setState(() {
      initializeDefaultValues();
    });
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
          title: Text("Manual Booking", style: TextStyle(color: Colors.black)),
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
                          autovalidate: _autoValidateForm,
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
                                            selectedDateText: _selectedDateText,
                                            selectedDate: _initialDate,
                                            onChanged: ((value) {
                                              _selectedDateText = value;
                                            }),
                                          ),
                                        ),
                                        SizedBox(
                                          width: sm.scaledWidth(40),
                                          child: TimePicker(
                                            selectedTimeText: _selectedTimeText,
                                            selectedTime: _intitialTime,
                                            onChanged: ((value) {
                                              print("value $value");
                                              _selectedTimeText = value;
                                            }),
                                          ),
                                        ),
                                      ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: txtfieldboundry(
                                    controller: _myNameEditController,
                                    title: "Name",
                                    security: false,
                                    valid: true,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: txtfieldboundry(
                                    controller: _myContactEditController,
                                    title: "Contact",
                                    security: false,
                                    maxlen: 10,
                                    myregex: mobileRegex,
                                    keyboardSet: TextInputType.number,
                                    valid: true,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: txtfieldboundry(
                                    controller: _myNoOfPersonEditController,
                                    title: "Number of People",
                                    keyboardSet: TextInputType.number,
                                    security: false,
                                    valid: true,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: txtfieldboundry(
                                    controller: _myNotesEditController,
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
                  if (_selectedDateText == 'Select Date') {
                    BotToast.showText(text: "Please select a date");
                    return;
                  }
                  if (_selectedTimeText == 'Select Time') {
                    BotToast.showText(text: "Please select a time");
                    return;
                  }
                  // CreateBookingModel request = CreateBookingModel();
                  // request.name = _myNameEditController.text;
                  // request.mobileNo = _myContactEditController.text;
                  // request.noOfPerson = _myNoOfPersonEditController.text;
                  // request.notes = _myNotesEditController.text;
                  // request.createdDate = _selectedDateText;
                  // request.createdTime = _selectedTimeText;

                  Map<String, dynamic> _map = {
                    "name": _myNameEditController.text,
                    "contact": _myContactEditController.text,
                    "no_of_person": _myNoOfPersonEditController.text,
                    "special_notes": _myNotesEditController.text,
                    "created_date": _selectedDateText,
                    "created_time": _selectedTimeText
                  };
                  WebService.funCreateManualBooking(_map).then((value) {
                    BotToast.showText(text: value.message);
                    initializeDefaultValues();
                    _autoValidateForm = true;
                  });
                } else {
                  // initializeDefaultValues();
                  _autoValidateForm = true;
                }
              },
              clr: Colors.red,
              title: "Save",
            ),
          ),
        ]));
  }
}
