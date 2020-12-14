import 'package:bot_toast/bot_toast.dart';
import 'package:favorito_user/component/DatePicker.dart';
import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/SlotListModel.dart';
import 'package:favorito_user/model/appModel/BookingOrAppointmentListModel.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';

class BookTable extends StatelessWidget {
  int identifier;
  BookingOrAppointmentListModel data;
  BookTable(this.identifier, this.data);
  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      theme: NeumorphicThemeData(
          defaultTextColor: myRed,
          accentColor: Colors.grey,
          variantColor: Colors.black38,
          depth: 8,
          intensity: 0.65),
      themeMode: ThemeMode.system,
      child: Material(
        child: NeumorphicBackground(
          child: _BookTable(identifier, data),
        ),
      ),
    );
  }
}

class _BookTable extends StatefulWidget {
  int identifier;
  BookingOrAppointmentListModel data;
  _BookTable(this.identifier, this.data);
  _BookTableState createState() => _BookTableState();
}

class _BookTableState extends State<_BookTable> {
  bool _autoValidateForm = false;
  var _myUserNameEditTextController = TextEditingController();
  var _noOfPeopleEditTextController = TextEditingController();
  var _myMobileEditTextController = TextEditingController();
  var _myNotesEditTextController = TextEditingController();

  String _selectedOccasion;

  String _selectedDateText;

  DateTime _initialDate;

  List<SlotListModel> slotList = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  initializeDefaultValues() {
    _autoValidateForm = false;

    _initialDate = DateTime.now();

    SlotListModel slot1 = SlotListModel("12:00", false);
    SlotListModel slot2 = SlotListModel("13:00", false);
    SlotListModel slot3 = SlotListModel("13:30", false);
    SlotListModel slot4 = SlotListModel("14:30", false);
    SlotListModel slot5 = SlotListModel("15:00", false);

    slotList.add(slot1);
    slotList.add(slot2);
    slotList.add(slot3);
    slotList.add(slot4);
    slotList.add(slot5);

    if (widget.identifier == 0) {
      _noOfPeopleEditTextController.text = "";
      _selectedDateText = DateFormat('dd/MM/yyyy').format(_initialDate);
      _selectedOccasion = "";
      _myUserNameEditTextController.text = "";
      _myMobileEditTextController.text = "";
      _myNotesEditTextController.text = "";
    } else {
      _noOfPeopleEditTextController.text = widget.data.noOfPerson;
      _selectedDateText = widget.data.date;
      _selectedOccasion = widget.data.occasion;
      _myUserNameEditTextController.text = widget.data.bookingName;
      _myMobileEditTextController.text = widget.data.mobile;
      _myNotesEditTextController.text = widget.data.notes;
      for (var temp in slotList) {
        if (temp.slot == widget.data.slot) {
          temp.selected = true;
          break;
        }
      }
    }
  }

  @override
  void initState() {
    initializeDefaultValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(color: myBackGround),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    color: Colors.black,
                    iconSize: 45,
                    icon: Icon(Icons.keyboard_arrow_left),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                Text(
                  "Book Table",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Expanded(
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: sm.w(8)),
                  decoration: BoxDecoration(color: myBackGround),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Center(
                        child: Text(
                          "Avadh Group",
                          style: TextStyle(
                              fontSize: 18,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: sm.h(2)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 60,
                              color: Colors.grey,
                            ),
                            Expanded(
                              child: Neumorphic(
                                style: NeumorphicStyle(
                                    shape: NeumorphicShape.convex,
                                    depth: -8,
                                    lightSource: LightSource.topLeft,
                                    color: myEditTextBackground,
                                    boxShape: NeumorphicBoxShape.roundRect(
                                        BorderRadius.all(
                                            Radius.circular(30.0)))),
                                child: TextFormField(
                                  controller: _noOfPeopleEditTextController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    hintText: "",
                                    fillColor: Colors.transparent,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                int temp = int.parse(
                                    _noOfPeopleEditTextController.text);
                                if (temp > 1) {
                                  temp--;
                                  _noOfPeopleEditTextController.text =
                                      temp.toString();
                                }
                              },
                              child: SizedBox(
                                width: sm.w(18),
                                child: Neumorphic(
                                  style: NeumorphicStyle(
                                      shape: NeumorphicShape.convex,
                                      depth: 8,
                                      lightSource: LightSource.top,
                                      color: Colors.white,
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.all(
                                              Radius.circular(30.0)))),
                                  margin:
                                      EdgeInsets.symmetric(horizontal: sm.w(2)),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: sm.w(4)),
                                      child: Text(
                                        "-",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 40,
                                            fontWeight: FontWeight.w100),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                int temp = int.parse(
                                    _noOfPeopleEditTextController.text);
                                temp++;
                                _noOfPeopleEditTextController.text =
                                    temp.toString();
                              },
                              child: SizedBox(
                                width: sm.w(18),
                                child: Neumorphic(
                                  style: NeumorphicStyle(
                                      shape: NeumorphicShape.convex,
                                      depth: 8,
                                      lightSource: LightSource.top,
                                      color: Colors.white,
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.all(
                                              Radius.circular(8.0)))),
                                  margin:
                                      EdgeInsets.symmetric(horizontal: sm.w(2)),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: sm.w(4)),
                                      child: Text(
                                        "+",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 40,
                                            fontWeight: FontWeight.w100),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: sm.h(3)),
                        child: Center(
                          child: DatePicker(
                            selectedDateText: _selectedDateText,
                            selectedDate: _initialDate,
                            onChanged: ((value) {
                              _selectedDateText = value;
                            }),
                          ),
                        ),
                      ),
                      mySlotSelector(sm),
                      myOccasionDropDown(sm),
                      Padding(
                        padding: EdgeInsets.only(top: sm.h(4)),
                        child: EditTextComponent(
                          ctrl: _myUserNameEditTextController,
                          title: "Name",
                          hint: "Enter Name",
                          maxLines: 1,
                          security: false,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: sm.h(4)),
                        child: EditTextComponent(
                          ctrl: _myMobileEditTextController,
                          title: "Mobile",
                          hint: "Enter Mobile",
                          maxLines: 1,
                          security: false,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: sm.h(4)),
                        child: EditTextComponent(
                          ctrl: _myNotesEditTextController,
                          title: "Special Notes",
                          hint: "Enter Special Notes",
                          maxLines: 4,
                          security: false,
                        ),
                      ),
                    ],
                  )),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(top: sm.h(4), bottom: sm.h(2)),
                child: NeumorphicButton(
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.convex,
                      depth: 4,
                      lightSource: LightSource.topLeft,
                      color: myButtonBackground,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.all(Radius.circular(24.0)))),
                  margin: EdgeInsets.symmetric(horizontal: sm.w(10)),
                  onPressed: () {
                    BotToast.showText(text: "Appointment sheduled");
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Center(
                    child: Text(
                      "Done",
                      style:
                          TextStyle(fontWeight: FontWeight.w400, color: myRed),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mySlotSelector(SizeManager sm) {
    return Padding(
      padding: EdgeInsets.only(top: sm.h(2)),
      child: Container(
        width: sm.w(100),
        height: sm.h(10),
        decoration: BoxDecoration(color: Colors.transparent),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (var temp in slotList)
              InkWell(
                onTap: () {
                  setState(() {
                    for (var temp in slotList) {
                      temp.selected = false;
                    }
                    temp.selected = true;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      right: sm.w(1), top: sm.h(2), bottom: sm.h(2)),
                  child: Neumorphic(
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        depth: 8,
                        lightSource: LightSource.top,
                        color: Colors.white,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.all(Radius.circular(8.0)))),
                    margin: EdgeInsets.symmetric(horizontal: sm.w(2)),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: sm.w(4)),
                        child: Text(temp.slot,
                            style: TextStyle(
                                color: temp.selected
                                    ? Colors.green
                                    : Colors.grey)),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget myOccasionDropDown(SizeManager sm) {
    return Padding(
      padding: EdgeInsets.only(top: sm.h(2)),
      child: Center(
        child: SizedBox(
          child: Neumorphic(
            style: NeumorphicStyle(
                shape: NeumorphicShape.convex,
                depth: 8,
                lightSource: LightSource.top,
                color: Colors.white,
                boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.all(Radius.circular(8.0)))),
            margin: EdgeInsets.symmetric(horizontal: sm.w(10)),
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedOccasion,
              hint: Padding(
                padding: EdgeInsets.symmetric(horizontal: sm.w(2)),
                child: Text("Select Occasion"),
              ),
              underline: Container(), // this is the magic
              items: <String>[
                'Occasion 1',
                'Occasion 2',
                'Occasion 3',
                'Occasion 4'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: sm.w(2)),
                    child: Text(value),
                  ),
                );
              }).toList(),
              onChanged: (String value) {
                setState(() {
                  _selectedOccasion = value;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
