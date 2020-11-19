import 'package:Favorito/model/appoinment/PersonList.dart';
import 'package:Favorito/model/appoinment/ServiceData.dart';
import 'package:Favorito/utils/Regexer.dart';
import 'package:Favorito/utils/dateformate.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import '../../component/roundedButton.dart';
import '../../component/txtfieldboundry.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:bot_toast/bot_toast.dart';
import '../../config/SizeManager.dart';

class ManualAppoinment extends StatefulWidget {
  var data;
  String start;
  String end;
  ManualAppoinment({this.data, this.start, this.end});
  @override
  _ManualAppoinment createState() => _ManualAppoinment();
}

class _ManualAppoinment extends State<ManualAppoinment> {
  SizeManager sm;
  List<ServiceList> serviceList = List();
  List<String> serviceListText = List();

  List<PersonList> personList;
  List<String> personListText = List();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  MaterialLocalizations localizations;

  List<TextEditingController> controller = List();

  TimeOfDay _intitialTime;

  DateTime _initialDate;

  initializeDefaultValues() {
    _intitialTime = TimeOfDay.now();
    for (var v in controller) v.text = "";
    setState(() => _initialDate = DateTime.now());
    controller[0].text = 'Select Date';
    controller[1].text = 'Select Time';
  }

  @override
  void initState() {
    for (int i = 0; i < 7; i++) controller.add(TextEditingController());
    getDataVerbode();
    // getPageData();
    if (widget.data != null) {
      controller[0].text = widget.data.createdDate;
      controller[1].text = widget.start + "-" + widget.end;
      controller[2].text = widget.data.name;
      controller[3].text = widget.data.contact;
      controller[4].text = widget.data.service_name;
      controller[5].text = widget.data.person_name;
      controller[6].text = widget.data.specialNotes;
      print(
          "controller[3,4]:${widget.data.service_name}${widget.data.person_name}");
    } else
      initializeDefaultValues();

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
                                  child: Padding(
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
                                                          onTap: () {
                                                            showDatePicker(
                                                                    context:
                                                                        context,
                                                                    initialDate:
                                                                        DateTime
                                                                            .now(),
                                                                    firstDate:
                                                                        DateTime(
                                                                            2020),
                                                                    lastDate:
                                                                        DateTime(
                                                                            2022))
                                                                .then((_val) {
                                                              setState(() {
                                                                controller[0]
                                                                        .text =
                                                                    dateFormat1
                                                                        .format(
                                                                            _val);
                                                              });
                                                            });
                                                          },
                                                          child: SizedBox(
                                                            width:
                                                                sm.scaledWidth(
                                                                    40),
                                                            child:
                                                                OutlineGradientButton(
                                                              child: Center(
                                                                  child: Text(
                                                                      controller[
                                                                              0]
                                                                          .text)),
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
                                                              radius: Radius
                                                                  .circular(8),
                                                            ),
                                                          )))
                                                ]),
                                          ),
                                          SizedBox(
                                              width: sm.scaledWidth(40),
                                              child: InkWell(
                                                  onTap: () {
                                                    showTimePicker(
                                                      context: context,
                                                      initialTime:
                                                          TimeOfDay.now(),
                                                      builder:
                                                          (BuildContext context,
                                                              Widget child) {
                                                        return MediaQuery(
                                                          data: MediaQuery.of(
                                                                  context)
                                                              .copyWith(
                                                                  alwaysUse24HourFormat:
                                                                      true),
                                                          child: child,
                                                        );
                                                      },
                                                    ).then((value) {
                                                      setState(() {
                                                        controller[1].text =
                                                            localizations
                                                                .formatTimeOfDay(
                                                                    value,
                                                                    alwaysUse24HourFormat:
                                                                        true);
                                                      });
                                                    });
                                                  },
                                                  child: SizedBox(
                                                    width: sm.scaledHeight(40),
                                                    child:
                                                        OutlineGradientButton(
                                                      child: Center(
                                                          child: Text(
                                                              controller[1]
                                                                  .text)),
                                                      gradient: LinearGradient(
                                                          colors: [
                                                            Colors.red,
                                                            Colors.red
                                                          ]),
                                                      strokeWidth: 1,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 12),
                                                      radius:
                                                          Radius.circular(8),
                                                    ),
                                                  ))),
                                        ]),
                                  ),
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
                                      items: serviceListText,
                                      label: "Service",
                                      hint: "Please Select Service",
                                      showSearchBox: false,
                                      onChanged: (value) => setState(
                                          () => controller[4].text = value)),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  child: DropdownSearch<String>(
                                      validator: (v) =>
                                          v == '' ? "required field" : null,
                                      autoValidate: true,
                                      mode: Mode.MENU,
                                      selectedItem: controller[5].text,
                                      items: personListText,
                                      label: "Person",
                                      hint: "Please Select Person",
                                      showSearchBox: false,
                                      onChanged: (value) => setState(
                                          () => controller[5].text = value)),
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
          Visibility(
            visible: widget.data == null,
            child: Padding(
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
                    var selectedService;
                    var selectedPerson;
                    for (var v in serviceList) {
                      if (v.serviceName == controller[4].text)
                        selectedService = v.id;
                    }
                    for (var v in personList) {
                      if (v.personName == controller[5].text)
                        selectedPerson = v.id;
                    }

                    Map<String, dynamic> _map = {
                      "created_date": controller[0].text,
                      "created_time": controller[1].text,
                      "name": controller[2].text,
                      "contact": controller[3].text,
                      "service_id": selectedService,
                      "person_id": selectedPerson,
                      "special_notes": controller[6].text
                    };

                    print("_map ${_map.toString()}");
                    WebService.funAppoinmentCreate(_map).then((value) {
                      if (value.status == "success") {
                        BotToast.showText(text: value.message);
                        initializeDefaultValues();
                      }
                    });
                  }
                },
                clr: Colors.red,
                title: widget.data != null ? "Update" : "Save",
              ),
            ),
          ),
        ]));
  }

  void getDataVerbode() async {
    await WebService.funAppoinmentVerbose().then((value) {
      if (value.status == "success") {
        var va = value.data;
        serviceList = va.serviceList;
        for (var va in serviceList) serviceListText.add(va.serviceName);
        personList = va.personList;
        for (var va in personList) personListText.add(va.personName);
        setState(() {});
      }
    });
  }
}
