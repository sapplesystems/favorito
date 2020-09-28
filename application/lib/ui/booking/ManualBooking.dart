import 'package:Favorito/component/DatePicker.dart';
import 'package:Favorito/component/TimePicker.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:flutter/material.dart';

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

  TimeOfDay _selectedTime;
  TimeOfDay _intitialTime;

  DateTime _selectedDate;
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
    _selectedTime = null;

    _initialDate = DateTime.now();
    _selectedDate = null;
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    initializeDefaultValues();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xfffff4f4),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            "Manual Booking",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Color(0xfffff4f4),
          ),
          child: ListView(children: [
            Container(
                margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32.0),
                height: sm.scaledHeight(75),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                          ),
                                        ),
                                        SizedBox(
                                          width: sm.scaledWidth(40),
                                          child: TimePicker(
                                            selectedTimeText: _selectedTimeText,
                                            selectedTime: _intitialTime,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: txtfieldboundry(
                                      ctrl: _myNameEditController,
                                      title: "Name",
                                      security: false,
                                      valid: true,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: txtfieldboundry(
                                      ctrl: _myContactEditController,
                                      title: "Contact",
                                      security: false,
                                      valid: true,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: txtfieldboundry(
                                      ctrl: _myNoOfPersonEditController,
                                      title: "Number of People",
                                      security: false,
                                      valid: true,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: txtfieldboundry(
                                      ctrl: _myNotesEditController,
                                      title: "Special Notes",
                                      security: false,
                                      maxLines: 5,
                                      valid: true,
                                    ),
                                  ),
                                ]))))),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: sm.scaledWidth(60),
                margin: EdgeInsets.only(bottom: 16.0),
                child: roundedButton(
                  clicker: () {
                    if (_formKey.currentState.validate()) {
                    } else {
                      initializeDefaultValues();
                      _autoValidateForm = true;
                    }
                  },
                  clr: Colors.red,
                  title: "Save",
                ),
              ),
            ),
          ]),
        ));
  }
}
