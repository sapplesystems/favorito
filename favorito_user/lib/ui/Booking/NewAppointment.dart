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

class NewAppointment extends StatelessWidget {
  int identifier;
  BookingOrAppointmentListModel data;
  NewAppointment(this.identifier, this.data);
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
          child: _NewAppointment(identifier, data),
        ),
      ),
    );
  }
}

class _NewAppointment extends StatefulWidget {
  int identifier;
  BookingOrAppointmentListModel data;

  _NewAppointment(this.identifier, this.data);

  _NewAppointmentState createState() => _NewAppointmentState();
}

class _NewAppointmentState extends State<_NewAppointment> {
  bool _autoValidateForm = false;
  var _myNotesEditTextController = TextEditingController();

  String _selectedService;
  String _selectedServicePerson;

  String _selectedDateText = '';

  DateTime _initialDate;

  List<SlotListModel> slotList = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  initializeDefaultValues() {
    _autoValidateForm = false;

    _initialDate = DateTime.now();
    _selectedDateText = DateFormat('dd/MM/yyyy').format(_initialDate);

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
      _myNotesEditTextController.text = "";
      _selectedDateText = "";
      _selectedService = "";
      _selectedServicePerson = "";
    } else {
      _myNotesEditTextController.text = widget.data.notes;
      _selectedDateText = widget.data.date;
      _selectedService = widget.data.serviceName;
      _selectedServicePerson = widget.data.servicePersonName;
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                    iconSize: 45,
                    color: Colors.black,
                    icon: Icon(Icons.keyboard_arrow_left),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                Text(
                  widget.identifier == 0 ? "New Appointment" : "Appointment",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: sm.scaledWidth(8)),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Center(
                      child: Text(
                        widget.identifier == 0
                            ? "Avadh Group"
                            : widget.data.businessName,
                        style: TextStyle(
                            fontSize: 18, decoration: TextDecoration.underline),
                      ),
                    ),
                    myServiceDropDown(sm),
                    myServicePersonDropDown(sm),
                    Padding(
                      padding: EdgeInsets.only(top: sm.scaledHeight(3)),
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
                    Padding(
                      padding: EdgeInsets.only(top: sm.scaledHeight(2)),
                      child: Container(
                        width: sm.scaledWidth(100),
                        height: sm.scaledHeight(10),
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
                                      right: sm.scaledWidth(1),
                                      top: sm.scaledHeight(2),
                                      bottom: sm.scaledHeight(2)),
                                  child: Neumorphic(
                                    style: NeumorphicStyle(
                                        shape: NeumorphicShape.convex,
                                        depth: 8,
                                        lightSource: LightSource.top,
                                        color: Colors.white,
                                        boxShape: NeumorphicBoxShape.roundRect(
                                            BorderRadius.all(
                                                Radius.circular(8.0)))),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: sm.scaledWidth(2)),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: sm.scaledWidth(4)),
                                        child: Text(temp.slot,
                                            style: TextStyle(
                                                color: temp.selected
                                                    ? Colors.green
                                                    : Colors.grey,
                                                fontWeight: temp.selected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: sm.scaledHeight(4)),
                      child: EditTextComponent(
                        ctrl: _myNotesEditTextController,
                        title: "Special Notes",
                        hint: "Enter Special Notes",
                        maxLines: 4,
                        security: false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                    top: sm.scaledHeight(4), bottom: sm.scaledHeight(2)),
                child: NeumorphicButton(
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.convex,
                      depth: 4,
                      lightSource: LightSource.topLeft,
                      color: myButtonBackground,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.all(Radius.circular(24.0)))),
                  margin: EdgeInsets.symmetric(horizontal: sm.scaledWidth(10)),
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

  Widget myServiceDropDown(SizeManager sm) {
    return Padding(
      padding: EdgeInsets.only(top: sm.scaledHeight(2)),
      child: Neumorphic(
        style: NeumorphicStyle(
            shape: NeumorphicShape.convex,
            depth: 8,
            lightSource: LightSource.top,
            color: Colors.white,
            boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.all(Radius.circular(8.0)))),
        margin: EdgeInsets.symmetric(horizontal: sm.scaledWidth(10)),
        child: DropdownButton<String>(
          value: _selectedService,
          isExpanded: true,
          hint: Padding(
            padding: EdgeInsets.symmetric(horizontal: sm.scaledWidth(2)),
            child: Text("Select Service"),
          ),
          underline: Container(), // this is the magic
          items: <String>[
            'Service 1',
            'Service 2',
            'Service 3',
            'Service 4',
            'Haircut'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: sm.scaledWidth(2)),
                child: Text(value),
              ),
            );
          }).toList(),
          onChanged: (String value) {
            setState(() {
              _selectedService = value;
            });
          },
        ),
      ),
    );
  }

  Widget myServicePersonDropDown(SizeManager sm) {
    return Padding(
      padding: EdgeInsets.only(top: sm.scaledHeight(2)),
      child: Neumorphic(
        style: NeumorphicStyle(
            shape: NeumorphicShape.convex,
            depth: 8,
            lightSource: LightSource.top,
            color: Colors.white,
            boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.all(Radius.circular(8.0)))),
        margin: EdgeInsets.symmetric(horizontal: sm.scaledWidth(10)),
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedServicePerson,
          hint: Padding(
            padding: EdgeInsets.symmetric(horizontal: sm.scaledWidth(2)),
            child: Text("Select Service Person"),
          ),
          underline: Container(), // this is the magic
          items: <String>['Ramesh', 'Rohit', 'Mansij', 'Rohan', 'Gautam']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: sm.scaledWidth(2)),
                child: Text(value),
              ),
            );
          }).toList(),
          onChanged: (String value) {
            setState(() {
              _selectedServicePerson = value;
            });
          },
        ),
      ),
    );
  }
}
