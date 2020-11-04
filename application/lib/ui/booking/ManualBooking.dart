import 'package:Favorito/model/booking/SlotData.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/Regexer.dart';
import 'package:Favorito/utils/dateformate.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import '../../component/roundedButton.dart';
import '../../component/txtfieldboundry.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:bot_toast/bot_toast.dart';
import '../../config/SizeManager.dart';

class ManualBooking extends StatefulWidget {
  SlotData data;
  ManualBooking({this.data});
  @override
  _ManualBooking createState() => _ManualBooking();
}

class _ManualBooking extends State<ManualBooking> {
  SizeManager sm;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _selectedDateText = '';
  String _selectedTimeText = '';

  final _myNameEditController = TextEditingController();
  final _myContactEditController = TextEditingController();
  final _myNoOfPersonEditController = TextEditingController();
  final _myNotesEditController = TextEditingController();
  MaterialLocalizations localizations;

  TimeOfDay _intitialTime;

  DateTime _initialDate;

  initializeDefaultValues() {
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
    if (widget.data != null) {
      var va = widget.data;
      _myNameEditController.text = va.name;
      _myContactEditController.text = va.contact;
      _myNoOfPersonEditController.text = va.noOfPerson.toString();
      _myNotesEditController.text = va.specialNotes;
      _selectedDateText = va.createdDate;
      setState(() {
        _selectedTimeText = va.startTime;
      });
    } else
      setState(() {
        initializeDefaultValues();
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    localizations = MaterialLocalizations.of(context);
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
                                          child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                Expanded(
                                                    child: InkWell(
                                                        onTap: () => showDate(),
                                                        child: SizedBox(
                                                          width: sm
                                                              .scaledWidth(40),
                                                          child:
                                                              OutlineGradientButton(
                                                            child: Center(
                                                                child: Text(
                                                                    _selectedDateText)),
                                                            gradient:
                                                                LinearGradient(
                                                                    colors: [
                                                                  Colors.red,
                                                                  Colors.red
                                                                ]),
                                                            strokeWidth: 1,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        12),
                                                            radius:
                                                                Radius.circular(
                                                                    8),
                                                          ),
                                                        )))
                                              ]),
                                        ),
                                        SizedBox(
                                            width: sm.scaledWidth(40),
                                            child: InkWell(
                                                onTap: () {
                                                  showTime();
                                                },
                                                child: SizedBox(
                                                  width: sm.scaledHeight(40),
                                                  child: OutlineGradientButton(
                                                    child: Center(
                                                        child: Text(
                                                            _selectedTimeText)),
                                                    gradient: LinearGradient(
                                                        colors: [
                                                          Colors.red,
                                                          Colors.red
                                                        ]),
                                                    strokeWidth: 1,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 12),
                                                    radius: Radius.circular(8),
                                                  ),
                                                ))),
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

                  Map<String, dynamic> _map = {
                    "booking_id": widget.data == null ? "" : widget.data.id,
                    "name": _myNameEditController.text,
                    "contact": _myContactEditController.text,
                    "no_of_person": _myNoOfPersonEditController.text,
                    "special_notes": _myNotesEditController.text,
                    "created_date": _selectedDateText,
                    "created_time": _selectedTimeText
                  };
                  print("map:${_map.toString()}");
                  widget.data == null
                      ? WebService.funCreateManualBooking(_map).then((value) {
                          BotToast.showText(text: value.message);
                          initializeDefaultValues();
                        })
                      : WebService.funBookingEdit(_map).then((value) {
                          BotToast.showText(text: value.message);
                          initializeDefaultValues();
                        });
                }
              },
              clr: Colors.red,
              title: widget.data == null ? "Save" : "Update",
            ),
          ),
        ]));
  }

  showDate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2022))
        .then((_val) {
      setState(() {
        _selectedDateText = dateFormat1.format(_val);
      });
    });
  }

  showTime() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    ).then((value) {
      setState(() {
        _selectedTimeText =
            localizations.formatTimeOfDay(value, alwaysUse24HourFormat: true);
      });
      print("picked $_selectedTimeText");
    });
  }
}
