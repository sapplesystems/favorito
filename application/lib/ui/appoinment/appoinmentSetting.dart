import 'package:Favorito/component/MyOutlineButton.dart';
import 'package:Favorito/component/PopupContent.dart';
import 'package:Favorito/component/PopupLayout.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/model/appoinment/PersonList.dart';
import 'package:Favorito/model/appoinment/RestrictionOnlyModel.dart';
import 'package:Favorito/model/appoinment/SettingData.dart';
import 'package:Favorito/model/appoinment/appointmentServiceOnlyModel.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/dateformate.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class appoinmentSetting extends StatefulWidget {
  @override
  _appoinmentSettingState createState() => _appoinmentSettingState();
}

class _appoinmentSettingState extends State<appoinmentSetting> {
  List title = [
    "Waitlist Manager",
    "Anouncement",
    "Discription",
    "Minimum Wait Time",
    "Slot Length",
    "Except"
  ];
  List<String> slot = [
    "10",
    "10:30",
    "11",
    "11:30",
    "12",
    "12:30",
    "01",
    "01:30"
  ];
  Map<String, bool> statusData = {
    "Services": true,
    "Person": false,
    "Both": false
  };
  bool servicesDD = false;
  bool personsDD = false;
  SizeManager sm;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> abc = ["Name", "Mobile", "Email"];
  List<Data> servicesList;
  List<String> servicesString = List();
  List<PersonList> _personList;
  List<String> _personListTxt = List();
  SettingData _settingData = SettingData();
  List<RestrictionOnlyModel> _restrictionList;
  List<String> _restrictedServicesTxt = List();

  List<String> list = ["Sunday", "Monday", "TuesDay", "WednesDay"];
  List<String> selectedList = [];
  List<TextEditingController> controller = [];
  bool _autoValidateForm = false;
  ProgressDialog pr;
  MaterialLocalizations localizations;
  void initState() {
    getRestriction();
    super.initState();
    getService(false);
    for (int i = 0; i < 16; i++) controller.add(TextEditingController());
    initilizevalues();
    getSettingdata();
    getPerson();
  }

  @override
  Widget build(BuildContext context) {
    localizations = MaterialLocalizations.of(context);
    pr = new ProgressDialog(context, isDismissible: false)
      ..style(
          message: 'Please wait...',
          borderRadius: 8.0,
          backgroundColor: Colors.white,
          progressWidget: CircularProgressIndicator(),
          elevation: 8.0,
          insetAnimCurve: Curves.easeInOut,
          progress: 0.0,
          maxProgress: 100.0,
          progressTextStyle: TextStyle(
              color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
          messageTextStyle: TextStyle(
              color: myRed, fontSize: 19.0, fontWeight: FontWeight.w600));
    sm = SizeManager(context);

    return Scaffold(
        backgroundColor: myBackGround,
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
            "Appoinment Setting",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              icon: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Icon(Icons.refresh),
              ),
              onPressed: ()async {

               await getRestriction();
               await getPerson();
               getService(true);
              },
            )
          ],
        ),
        body: Builder(
          builder: (ctx) => Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4.0),
            child: ListView(
              children: [
                Card(
                    elevation: 8,
                    shape: rrb,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: sm.scaledHeight(4),
                          horizontal: sm.scaledWidth(8)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            plusMinus("Advance Booking(Day)", controller[0]),
                            plusMinus("Advance Booking(Hours)", controller[1]),
                            DropdownSearch<String>(
                              validator: (v) =>
                                  v == '' ? "required field" : null,
                              autoValidate: true,
                              mode: Mode.MENU,
                              selectedItem: controller[2].text,
                              items: slot,
                              label: "Slot Length",
                              hint: "Please Select Slot",
                              showSearchBox: false,
                              onChanged: (value) {
                                setState(() {
                                  controller[2].text = value;
                                });
                              },
                            ),
                            plusMinus("Booking/Slot", controller[3]),
                            plusMinus("Booking/Day", controller[4]),
                            Padding(
                              padding:
                                  EdgeInsets.only(bottom: sm.scaledHeight(2)),
                              child: txtfieldboundry(
                                valid: true,
                                title: title[1],
                                hint: "Enter ${title[0]}",
                                controller: controller[5],
                                maxLines: 4,
                                security: false,
                              ),
                            ),
                            Column(
                              children: [
                                addNewLabel("Services", labelClicked),
                                Divider(color: myGrey, height: 2),
                                if (servicesList != null)
                                  for (int i = 0; i < servicesList?.length; i++)
                                    //
                                    my_ServiceSwitch(
                                      datalist: servicesList,
                                      i: i,
                                      function: changeit,
                                      identity: "s",
                                    ),
                              ],
                            ),

                            Column(
                              children: [
                                addNewLabel("Person", labelClicked),
                                Divider(color: myGrey, height: 2),
                                if (_personList != null)
                                  for (int i = 0; i < _personList?.length; i++)
                                    //
                                    my_ServiceSwitch(
                                      datalist: _personList,
                                      i: i,
                                      function: changeit,
                                      identity: "p",
                                    ),
                              ],
                            ),

                            Divider(color: myGrey, height: 2),
                            if (_restrictionList != null)
                              additionalFunctionRistrict(
                                  "Restrictions", _restrictionList),

                          ]),
                    )),
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: sm.scaledWidth(16),
                        vertical: sm.scaledHeight(2)),
                    child: roundedButton(
                        clicker: () {
                          if (controller[3].text.isNotEmpty) funSublim();
                        },
                        clr: Colors.red,
                        title: "Done"))
              ],
            ),
          ),
        ));
  }

  void funSublim() {
    Map _map = {
      "start_time": null,
      "end_time": null,
      "advance_booking_start_days": null,
      "advance_booking_end_days": controller[0].text,
      "advance_booking_hours": controller[1].text,
      "slot_length": controller[2].text,
      "booking_per_slot": controller[3].text,
      "booking_per_day": controller[4].text,
      "announcement": controller[6].text,
    };
    pr?.show();
    WebService.funAppoinmentSaveSetting(_map).then((value) {
      pr?.hide();
      if (value.status == "success")
        BotToast.showText(text: value.message);


    });
  }

  Widget fromTo(String txt) {
    return Container(
      margin: EdgeInsets.all(8),
      width: sm.scaledWidth(24),
      height: sm.scaledHeight(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: myRed,
          width: 1,
        ),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          txt,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget plusMinus(String _title, TextEditingController ctrl) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text("\n$_title", style: TextStyle(color: Colors.grey)),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          IconButton(
            icon: Icon(Icons.remove_circle_outline, color: myRed, size: 28),
            onPressed: () {
              int a = int.parse(ctrl.text);
              a = a > 0 ? a - 1 : a;
              setState(() => ctrl.text = a.toString());
            },
          ),
          fromTo(ctrl.text),
          IconButton(
            icon: Icon(Icons.add_circle_outline, size: 28, color: myRed),
            onPressed: () {
              setState(() => ctrl.text = (int.parse(ctrl.text) + 1).toString());
            },
          )
        ]),
      )
    ]);
  }

  addNewLabel(String s, labelClicked) {
    return InkWell(
      onTap: () => labelClicked(s),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(child: Text(s, style: geryTextSmall)),
        Text("Add New", style: redTextSmall),
      ]),
    );
  }


  int j;
  additionalFunctionRistrict(String title, List<RestrictionOnlyModel> data) {

    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        addNewLabel(title, labelClicked),
        //for services
        Row(
          children: [Text("Services", style: TextStyle(fontSize: 16))],
        ),
        for (var _va in data)
          if (_va.serviceName != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_va.serviceName ?? ""),
                          Text(dateFormat4.format(DateTime.parse(
                                  ((_va.dateTime ?? "").split(" - "))[0])) +
                              " - " +
                              dateFormat4.format(DateTime.parse(
                                  ((_va.dateTime ?? "").split(" - "))[1])))
                        ]),
                  ),
                  Row(
                    children: [
                      InkWell(
                          onTap: () {
                            showPopup(context, _popupBody3(_va),
                                top: 8, bottom: 8);
                          },
                          child: Text("Edit ", style: TextStyle(color: myRed))),
                      SizedBox(width: 10),
                      InkWell(
                          onTap: () {
                            pr?.show();
                            WebService.funAppoinmentDeleteRestriction(
                                {"restriction_id": _va.id}).then((value) {
                              pr?.hide();
                                  if (value.status == "success") {
                                setState(() {
                                  _restrictionList.remove(_va);
                                });
                              }
                            });
                          },
                          child:
                              Text(" Delete", style: TextStyle(color: myRed)))
                    ],
                  )
                ],
              ),
            ),

        Padding(
          padding:  EdgeInsets.symmetric(horizontal: sm.scaledWidth(12),vertical: sm.scaledWidth(4)),
          child: Divider(color: myGrey, height: 2),
        ),        //for person
        Row(
          children: [Text("Appointmentd", style: TextStyle(fontSize: 16))],
        ),
        for (var _va in data)
          if (_va.personName != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_va.personName ?? ""),
                          Text(dateFormat4.format(DateTime.parse(
                              ((_va.dateTime ?? "").split(" - "))[0])) +
                              " - " +
                              dateFormat4.format(DateTime.parse(
                                  ((_va.dateTime ?? "").split(" - "))[1])))
                        ]),
                  ),
                  Row(
                    children: [
                      InkWell(
                          onTap: () {
                            showPopup(context, _popupBody3(_va),
                                top: 8, bottom: 8);
                          },
                          child: Text("Edit ", style: TextStyle(color: myRed))),
                      SizedBox(width: 10),
                      InkWell(
                          onTap: () {
                            pr?.show();
                            WebService.funAppoinmentDeleteRestriction(
                                {"restriction_id": _va.id}).then((value) {
                              pr?.hide();
                              if (value.status == "success") {
                                setState(() {
                                  _restrictionList.remove(_va);
                                });
                              }
                            });
                          },
                          child:
                          Text(" Delete", style: TextStyle(color: myRed)))
                    ],
                  )
                ],
              ),
            )

      ]),
    );
  }

  labelClicked(String _txt) async {
    switch (_txt) {
      case "Services":
        {
          showPopup(context, _popupBody1());
          break;
        }

      case "Person":
        {
          showPopup(context, _popupBody2(), top: 10, bottom: 10);
          break;
        }
      case "Restrictions":
        {
          showPopup(context, _popupBody3(null), top: 8, bottom: 8);
          break;
        }
    }
  }

  Widget _popupBody1() {
    return Container(
      child: Column(children: [
        Center(
            child: ListTile(
                title: Text("+Services",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: myRed)),
                trailing: IconButton(
                  icon: Icon(Icons.close, color: myRed),
                  onPressed: () {
                    controller[6].text = "";
                    Navigator.pop(context);
                  },
                ),
                leading: Icon(Icons.close, color: Colors.transparent))),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: txtfieldboundry(
              controller: controller[6],
              title: "Name",
              security: false,
              valid: true),
        ),
        MyOutlineButton(
          title: "Submit",
          function: () {
            if (controller[6].text != null && controller[6].text != "") {
              pr?.show();
              WebService.funAppoinmentSaveService(
                  {"service_name": controller[6].text}).then((value) {
                pr?.hide();
                if (value.status == "success") {
                  BotToast.showText(text: value.message);
                  getService(true);
                  Navigator.pop(context);
                }
              });
            }
          },
        )
      ]),
    );
  }

  Widget _popupBody2() {
    return Column(children: [
      Center(
          child: ListTile(
              title: Text("+Person",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16, color: myRed)),
              trailing: IconButton(
                icon: Icon(Icons.close, color: myRed),
                onPressed: () {
                  controller[6].text = "";
                  Navigator.pop(context);
                },
              ),
              leading: Icon(Icons.close, color: Colors.transparent))),
      myDropDown(controller[7], "Services", servicesString),
      for (int i = 0; i < 3; i++)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: txtfieldboundry(
              controller: controller[8 + i],
              title: abc[i],
              maxlen: i == 1
                  ? 10
                  : i == 2
                      ? 56
                      : 25,
              keyboardSet: i == 1
                  ? TextInputType.number
                  : i == 2
                      ? TextInputType.emailAddress
                      : TextInputType.name,
              security: false,
              valid: true),
        ),
      MyOutlineButton(
        title: "Submit",
        function: () {
          int _serviceId;
          for (var _va in servicesList) {
            if (_va.serviceName == controller[7].text) {
              _serviceId = _va.id;
            }
          }

          Map _map = {
            "person_name": controller[8].text,
            "service_id": _serviceId,
            "person_mobile": controller[9].text,
            "person_email": controller[10].text
          };
          if (controller[7].text != null && controller[7].text != "") {
            pr?.show();
            WebService.funAppoinmentSavePerson(_map).then((value) {
              pr?.hide();
              if (value.status == "success") {
                getPerson();
                BotToast.showText(text: value.message);
                Navigator.pop(context);
                for (int i = 7; i < 11; i++) controller[i].text = "";
              }
            });
          }
        },
      )
    ]);
  }

  String selectedOption;
  Widget _popupBody3(RestrictionOnlyModel _data) {
    cleanAll();
    if (_data != null) {
      if (_data.serviceId != 0) {
        controller[15].text = "Services";
        servicesDD = true;
      } else
        servicesDD = false;
      if (_data.personId != 0) {
        personsDD = true;
        controller[15].text = "Person";
      } else
        personsDD = false;

      if (_data.serviceId != 0 && _data.personId != 0)
        controller[15].text = "Both";
      controller[11].text = _data.serviceName ?? "";
      controller[12].text = _data.personName ?? "";
      controller[13].text = ((_data.dateTime ?? "").split(" - "))[0];
      controller[14].text = ((_data.dateTime ?? "").split(" - "))[1];
    }

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
        child: Column(children: [
          Center(
              child: ListTile(
                  title: Text("+Restriction",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: myRed)),
                  trailing: IconButton(
                    icon: Icon(Icons.close, color: myRed),
                    onPressed: () {
                      controller[6].text = "";
                      Navigator.pop(context);
                    },
                  ),
                  leading: IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => cleanAll(),
                  ))),
          Padding(
            padding: EdgeInsets.all(8),
            child: DropdownSearch<String>(
              validator: (_v) {
                var va;
                if (_v == "") {
                  va = 'required field';
                } else {
                  va = null;
                }
                return va;
              },
              autoValidate: _autoValidateForm,
              mode: Mode.MENU,
              showSelectedItem: false,
              items: ["Services", "Person", "Both"],
              label: "Select Any",
              selectedItem: controller[15].text,
              hint: "Please Select Select Any",
              showSearchBox: false,
              onChanged: (_value) {
                print("_value:${_value}");
                switch (_value) {
                  case "Services":
                    {
                      servicesDD = true;
                      personsDD = false;
                    }
                    break;

                  case "Person":
                    {
                      servicesDD = false;
                      personsDD = true;
                    }
                    break;

                  case "Both":
                    {
                      servicesDD = true;
                      personsDD = true;
                    }
                    break;
                  default:
                    {
                      servicesDD = false;
                      personsDD = false;
                    }
                    setState(() {});
                }
                setState(() {
                  controller[15].text = _value;
                });
                if (controller[15].text == "Services") {
                  setState(() {});
                  return;
                }
                if (controller[15].text == "Person") {
                  setState(() {
                    servicesDD = false;
                    personsDD = true;
                  });
                  return;
                }
                if (controller[15].text == "Both") {
                  setState(() {
                    servicesDD = true;
                    personsDD = true;
                  });
                  return;
                }
              },
            ),
          ),
          Visibility(
              visible: servicesDD,
              child: myDropDown(controller[11], "Services", servicesString)),
          Visibility(
              visible: personsDD,
              child: myDropDown(controller[12], "Person", _personListTxt)),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: InkWell(
              onTap: () {
                showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2022))
                    .then((_val) {
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (BuildContext context, Widget child) {
                      return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: true),
                        child: child,
                      );
                    },
                  ).then((value) {
                    String date = dateFormat1.format(_val);
                    String time = localizations.formatTimeOfDay(value,
                        alwaysUse24HourFormat: true);
                    print(date + " " + time);
                    setState(() => controller[13].text = date + " " + time);
                  });
                });
              },
              child: txtfieldboundry(
                  isEnabled: false,
                  controller: controller[13],
                  title: "Start DateTime",
                  security: false,
                  valid: true),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: InkWell(
              onTap: () {
                showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2022))
                    .then((_val) {
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (BuildContext context, Widget child) {
                      return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: true),
                        child: child,
                      );
                    },
                  ).then((value) {
                    String date = dateFormat1.format(_val);
                    String time = localizations.formatTimeOfDay(value,
                        alwaysUse24HourFormat: true);
                    print(date + " " + time);
                    setState(() => controller[14].text = date + " " + time);
                  });
                });
              },
              child: txtfieldboundry(
                  isEnabled: false,
                  controller: controller[14],
                  title: "End DateTime",
                  security: false,
                  valid: true),
            ),
          ),
          MyOutlineButton(
            title: "Submit",
            function: () {
              int _serviceId;
              int _personId;
              for (var _va in servicesList) {
                if (_va.serviceName == controller[11].text) {
                  _serviceId = _va.id;
                }
              }
              for (var _va in _personList) {
                if (_va.personName == controller[12].text) {
                  _personId = _va.id;
                }
              }

              int _v1 = (controller[15].text == "Services" ||
                      controller[15].text == "Both")
                  ? _serviceId
                  : null;

              int _v2 = (controller[15].text == "Person" ||
                      controller[15].text == "Both")
                  ? _personId
                  : null;

              Map _map = {
                "restriction_id": _data != null ? _data.id : "",
                "service_id": _v1,
                "person_id": _v2,
                "start_datetime": controller[13].text,
                "end_datetime": controller[14].text
              };
              if (controller[15].text != null && controller[15].text != "") {
                print("_map:${_map.toString()}");
                postRestriction(_map, _data == null);
              }
            },
          )
        ]),
      );
    });
  }

  // service_id:2
  // person_id:2
  // start_datetime:2020-10-03 10:00
  // end_datetime:2020-10-13 20:00
  showPopup(BuildContext context, Widget widget,
      {BuildContext popupContext,
      double left,
      double right,
      double top,
      double bottom}) {
    SizeManager sm = SizeManager(context);
    Navigator.push(
      context,
      PopupLayout(
        top: sm.scaledHeight(top ?? 20),
        left: sm.scaledWidth(left ?? 10),
        right: sm.scaledWidth(right ?? 10),
        bottom: sm.scaledHeight(bottom ?? 20),
        child: PopupContent(
          content: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: widget,
          ),
        ),
      ),
    );
  }

  void initilizevalues() {
    controller[0].text = "0";
    controller[1].text = "0";
    controller[2].text = "";
    controller[3].text = "0";
    setState(() {
      controller[4].text = "0";});
  }

  Widget myDropDown(
      TextEditingController _controller, String _title, var _dataset) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Padding(
        padding: EdgeInsets.all(8),
        child: DropdownSearch<String>(
          validator: (_v) {
            var va;
            if (_v == "") {
              va = 'required field';
            } else {
              va = null;
            }
            return va;
          },
          autoValidate: _autoValidateForm,
          mode: Mode.MENU,
          showSelectedItem: true,
          selectedItem: _controller.text,
          items: _dataset != null ? _dataset : null,
          label: _title,
          hint: "Please Select $_title",
          showSearchBox: true,
          onChanged: (_value) {
            setState(() {
              _controller.text = _value;
            });
          },
        ),
      );
    });
  }

  void getService(bool _val) async {
      if(_val)pr?.show();
    await WebService.funAppoinmentService().then((_value) {
      if(_val)pr?.hide();
      if (_value.status == "success") {
        servicesList = _value.data;
        servicesString.clear();
        for (var _va in servicesList) servicesString.add(_va.serviceName ?? "");
      }
    });
    setState(() {});
  }

  void getPerson() async {
    pr?.show();
    await WebService.funAppoinmentPerson().then((_value) {
        pr?.hide();
      if (_value.status == "success") {
        _personList = _value.data;
        _personListTxt.clear();
        for (var _va in _personList) _personListTxt.add(_va.personName ?? "");
        setState(() => controller[12].text = "");
      }
    });
  }

  getRestriction() async {
    pr?.show();
    await WebService.funAppoinmentRestriction().then((_value) {
      pr?.hide();
      if (_value.status == "success") {
        try {
          setState(() => _restrictionList = _value.data);
        } catch (e) {
          print("Error:$e");
        }
        _restrictedServicesTxt.clear();
        for (var _va in _restrictionList) {
          _restrictedServicesTxt.add(_va.serviceName);
          setState(() {});
        }
      }
    });
  }

  postRestriction(_map, isNew) async {
    pr?.show();
      await WebService.funAppoinmentSaveRestriction(_map, isNew).then((_value) {
        pr?.hide();
        if (_value.status == "success") {
          BotToast.showText(text: _value.message);
          getRestriction();
          Navigator.pop(context);
        }
      });

  }

  void cleanAll() {
    setState(() {
      controller[11].text = "";
      controller[12].text = "";
      controller[13].text = "";
      controller[14].text = "";
    });
  }

  changeit(int i, bool val, String identifire) {
    if (identifire == "p") {
      setState(() {
        _personList[i].isActive = val ? 0 : 1;
      });
      pr?.show();
      var _va = {
        "person_id": _personList[i].id,
        "is_active": _personList[i].isActive
      };
      WebService.funAppoinmentServicePersonOnOff(_va, false).then((value) {
        pr?.hide();
        if (value.status == "success") {
          BotToast.showText(text: value.message);
        }
      });
    }

    if (identifire == "s") {

      setState(() {
        servicesList[i].isActive = val ? 0 : 1;
      });
      var _va = {
        "service_id": servicesList[i].id,
        "is_active": servicesList[i].isActive
      };
      print("data:$_va");
      pr?.show();
      WebService.funAppoinmentServicePersonOnOff(_va, true).then((value) {
        pr?.hide();
        if (value.status == "success") {
          BotToast.showText(text: value.message);
        }
      });
    }
  }

  getSettingdata()async{
    pr?.show();
   await WebService.funAppoinmentSetting().then((value) {
      pr?.hide();
      if(value.status == 'success'){
        _settingData = value.data[0];
        controller[0].text = _settingData.advanceBookingEndDays.toString();
        controller[1].text = _settingData.advanceBookingHours.toString();
        controller[2].text = _settingData.slotLength.toString();
        controller[3].text = _settingData.bookingPerSlot.toString();
        controller[4].text = _settingData.bookingPerDay.toString();

    setState(() => controller[5].text = _settingData.announcement??"");
    print("_settingData.announcement :${_settingData.announcement}");
      }
    });
  }
}
class my_ServiceSwitch extends StatelessWidget {
  const my_ServiceSwitch({
    Key key,
    @required this.datalist,
    @required this.i,
    @required this.function,
    @required this.identity,
  }) : super(key: key);

  final List datalist;
  final int i;
  final Function function;
  final String identity;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //1 is active 0 is not active
        Text(
            identity == "s" ? datalist[i].serviceName : datalist[i].personName),
        Switch(
          onChanged: (val) => function(i, val, identity),
          value: datalist[i].isActive == 0,
          activeColor: myRed,
          activeTrackColor: myRedLight,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.grey,
        )
      ],
    );
  }

}
