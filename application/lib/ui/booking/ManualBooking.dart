import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/model/booking/SlotData.dart';

import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/booking/BookingProvider.dart';
import 'package:Favorito/utils/Regexer.dart';
import 'package:Favorito/utils/dateformate.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:provider/provider.dart';
import 'package:time_picker_widget/time_picker_widget.dart';

import '../../component/roundedButton.dart';
import '../../component/txtfieldboundry.dart';
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
  bool needvalidate = false;
  String _selectedDateText = '';
  String _selectedTimeText = '';

  final _myNameEditController = TextEditingController();
  final _myContactEditController = TextEditingController();
  final _myNoOfPersonEditController = TextEditingController();
  final _myNotesEditController = TextEditingController();
  MaterialLocalizations localizations;
  bool serviceCall = false;
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
        _selectedTimeText = va.createdTime ?? "00:00";
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
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("Manual Booking",
              style: Theme.of(context).textTheme.headline6.copyWith()),
        ),
        body: ListView(children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Card(
              child: Builder(
                builder: (context) => Form(
                  key: _formKey,
                  autovalidate: needvalidate,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 28),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: SizedBox(
                                    width: sm.w(36),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Expanded(
                                              child: InkWell(
                                                  onTap: () => showDate(),
                                                  child: SizedBox(
                                                    width: sm.w(40),
                                                    child:
                                                        OutlineGradientButton(
                                                      child: Center(
                                                          child: Text(
                                                              _selectedDateText,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline6
                                                                  .copyWith())),
                                                      gradient: LinearGradient(
                                                          colors: [
                                                            myGrey,
                                                            myGrey
                                                          ]),
                                                      strokeWidth: 1,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 12),
                                                      radius:
                                                          Radius.circular(8),
                                                    ),
                                                  )))
                                        ]),
                                  ),
                                ),
                                SizedBox(
                                    width: sm.w(40),
                                    child: InkWell(
                                        onTap: () {
                                          print('');
                                          showTime();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: SizedBox(
                                            width: sm.h(40),
                                            child: OutlineGradientButton(
                                              child: Center(
                                                  child: Text(_selectedTimeText,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6
                                                          .copyWith())),
                                              gradient: LinearGradient(
                                                  colors: [myGrey, myGrey]),
                                              strokeWidth: 1,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 12),
                                              radius: Radius.circular(8),
                                            ),
                                          ),
                                        ))),
                              ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: txtfieldboundry(
                            controller: _myNameEditController,
                            title: "Enter User Name",
                            security: false,
                            hint: 'User Name',
                            maxlen: 20,
                            valid: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: txtfieldboundry(
                            controller: _myContactEditController,
                            title: "Enter Contact",
                            hint: 'Contact',
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
                              title: "Enter Number of Persons",
                              keyboardSet: TextInputType.number,
                              security: false,
                              hint: "Number of Persons",
                              maxlen: 3,
                              valid: true),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: txtfieldboundry(
                              controller: _myNotesEditController,
                              title: "Enter Special Notes()",
                              security: false,
                              hint: "Special Notes(Max. 80 Character Only)",
                              maxlen: 80,
                              maxLines: 5,
                              valid: false),
                        ),
                      ]),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sm.w(15), vertical: 16.0),
            child: serviceCall
                ? Center(child: CircularProgressIndicator())
                : RoundedButton(
                    clicker: () {
                      if (_formKey.currentState.validate()) {
                        if (_selectedDateText == 'Select Date') {
                          BotToast.showText(
                              text: "Please select a date",
                              duration: Duration(seconds: 5));
                          return;
                        }
                        if (_selectedTimeText == 'Select Time') {
                          BotToast.showText(
                              text: "Please select a time",
                              duration: Duration(seconds: 5));
                          return;
                        }
                        print(
                            "_selectedDateText:$_selectedDateText : $_selectedTimeText");
                        Map<String, dynamic> _map = {
                          "booking_id":
                              widget.data == null ? "" : widget.data.id,
                          "name": _myNameEditController.text,
                          "contact": _myContactEditController.text,
                          "no_of_person": _myNoOfPersonEditController.text,
                          "special_notes": _myNotesEditController.text,
                          "created_date": _selectedDateText,
                          "created_time":
                              _selectedTimeText.replaceAll('PM', '00')
                        };
                        print(_map.toString());
                        print("map:${_map.toString()}");
                        setState(() {
                          serviceCall = true;
                        });
                        widget.data == null
                            ? WebService.funCreateManualBooking(_map, context)
                                .then((value) {
                                setState(() {
                                  serviceCall = false;
                                });
                                BotToast.showText(
                                    text: value.message,
                                    duration: Duration(seconds: 5));
                                initializeDefaultValues();
                              })
                            : WebService.funBookingEdit(_map).then((value) {
                                setState(() {
                                  serviceCall = false;
                                  Navigator.pop(context);
                                });
                                BotToast.showText(
                                    text: value.message,
                                    duration: Duration(seconds: 5));
                                initializeDefaultValues();
                              });
                      } else {
                        setState(() {
                          needvalidate = true;
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
    BookingProvider va = Provider.of<BookingProvider>(context, listen: false);
    var a = '${dateFormat1.format(DateTime.now())} ${va.getEndTime()}:00';
    DateTime aa = DateTime.parse(a);
    bool b = DateTime.now().isAfter(aa);
    showDatePicker(
            context: context,
            initialDate: DateTime.now().add(Duration(days: b ? 1 : 0)),
            firstDate: DateTime.now().add(Duration(days: b ? 1 : 0)),
            lastDate: DateTime.now().add(Duration(
                days: Provider.of<BookingProvider>(context, listen: false)
                        .getTotalBookingDays() -
                    1)))
        .then((_val) {
      setState(() {
        _selectedDateText = dateFormat1.format(_val);
      });
    });
  }

  showTime() {
    BookingProvider va = Provider.of<BookingProvider>(context, listen: false);
    int h = va.getTotalBookingHours();
    var a = '$_selectedDateText ${va.getStartTime()}:00';
    DateTime aa = DateTime.parse(a);
    bool b = DateTime.now().isAfter(aa);
    DateTime bb = DateTime.parse('$_selectedDateText ${va.getEndTime()}:00');
    bool isToday = ((dateFormat1.format(DateTime.parse(_selectedDateText))) ==
        dateFormat1.format(DateTime.now()));

    bool timeOff = DateTime.now().isAfter(bb);
    if (timeOff) {
      BotToast.showText(text: 'Booking Time Off');
      return;
    }
    var startTime;

    if (isToday) {
      if (b) {
        int _va = DateTime.now().hour;
        int _va2 = _va+ h;
        if(_va2>23)_va2=0;
        startTime =  _va2;
      } else {
        startTime = aa.hour + h;
      }
    } else {
      startTime = aa.hour;
    }

    var endTime = bb.hour;
    print('startTime:$b   :  $startTime');
    if (_selectedDateText == 'Select Date')
      BotToast.showText(text: 'Please selecet Date');
    var _a = MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true);
    print('hours:$h'
        // now:$now c:$c '
        ' isToday$isToday  startTime:${va.getStartTime()} endTime:${va.getEndTime()}');

        print("startTime:$startTime");
        
    showCustomTimePicker(
        context: context,
        onFailValidation: (context) => print('Unavailable selection'),
        initialTime: TimeOfDay(hour: startTime, minute: 0),
        builder: (BuildContext context, Widget child) {
          return MediaQuery(data: _a, child: child);
        },
        selectableTimePredicate: (time) =>
            ((time.hour >= startTime) && (time.hour < endTime))).then((time) =>
        setState(() => _selectedTimeText =
            localizations.formatTimeOfDay(time, alwaysUse24HourFormat: true)));
  }
}
