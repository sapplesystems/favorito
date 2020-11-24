import 'package:Favorito/component/fromTo.dart';
import 'package:Favorito/component/myTags.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/utils/myString.Dart';

class WaitListSetting extends StatefulWidget {
  @override
  _WaitListSettingState createState() => _WaitListSettingState();
}

class _WaitListSettingState extends State<WaitListSetting> {
  GlobalKey<FormState> _key = GlobalKey();
  String startTime = "00:00";
  String endTime = "00:00";
  MaterialLocalizations localizations;
  List title = [
    "Waitlist Manager",
    "Anouncement",
    "Discription",
    "Minimum Wait Time(minuts)",
    "Slot Length",
    "Except"
  ];
  List<String> slot = [
    "15 min",
    "20 min",
    "25 min",
    "30 min",
    "35 min",
    "40 min",
    "45 min",
    "50 min"
  ];
  SizeManager sm;
  List<String> list = [
    "Sunday",
    "Monday",
    "TuesDay",
    "WednesDay",
    "ThursDay",
    "FriDay",
    "SaturDay"
  ];
  List<String> selectedList = [];
  List<TextEditingController> controller = [];

  void initState() {
    getPageData();
    super.initState();
    for (int i = 0; i < 7; i++) controller.add(TextEditingController());
    controller[0].text = "0";
    controller[3].text = "0";
    controller[4].text = "0";
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    localizations = MaterialLocalizations.of(context);

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
          title: Text(waitlistSetting, style: TextStyle(color: Colors.black)),
        ),
        body: Builder(
            builder: (context) => Form(
                  key: _key,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text("Start waitlist daily at",
                                          style: TextStyle(color: Colors.grey)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now(),
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
                                                    startTime = localizations
                                                        .formatTimeOfDay(value,
                                                            alwaysUse24HourFormat:
                                                                true);
                                                  });
                                                });
                                              },
                                              child: fromTo(
                                                  txt: startTime, clr: myRed)),
                                          InkWell(
                                              onTap: () {
                                                showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now(),
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
                                                    endTime = localizations
                                                        .formatTimeOfDay(value,
                                                            alwaysUse24HourFormat:
                                                                true);
                                                  });
                                                });
                                              },
                                              child: fromTo(
                                                  txt: endTime, clr: myRed))
                                        ],
                                      ),
                                      plusMinus(
                                          "Available resources", controller[0]),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: sm.scaledHeight(2)),
                                        child: txtfieldboundry(
                                          valid: true,
                                          title: title[3],
                                          isEnabled: true,
                                          keyboardSet: TextInputType.number,
                                          hint: "Enter ${title[0]}",
                                          controller: controller[1],
                                          maxLines: 1,
                                          security: false,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: DropdownSearch<String>(
                                            validator: (v) => v == ''
                                                ? "required field"
                                                : null,
                                            autoValidate: true,
                                            mode: Mode.MENU,
                                            selectedItem: controller[2].text,
                                            items: slot,
                                            label: "${title[4]}",
                                            hint: "Please Select ${title[4]}",
                                            showSearchBox: false,
                                            onChanged: (value) {
                                              setState(() {
                                                controller[2].text = value;
                                              });
                                            }),
                                      ),
                                      plusMinus("Booking/Slot", controller[3]),
                                      plusMinus("Booking/Day", controller[4]),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              bottom: sm.scaledHeight(2)),
                                          child: txtfieldboundry(
                                              valid: true,
                                              title: title[0],
                                              hint: "Enter ${title[0]}",
                                              controller: controller[5],
                                              maxLines: 1,
                                              security: false)),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              bottom: sm.scaledHeight(2)),
                                          child: txtfieldboundry(
                                              valid: true,
                                              title: title[1],
                                              hint: "Enter ${title[0]}",
                                              controller: controller[6],
                                              maxLines: 4,
                                              security: false)),
                                      MyTags(
                                          sourceList: list,
                                          selectedList: selectedList,
                                          hint: "Please select ${title[5]}",
                                          border: true,
                                          directionVeticle: false,
                                          title: title[5])
                                    ]))),
                        Padding(
                            padding: EdgeInsets.only(
                                left: sm.scaledWidth(5),
                                right: sm.scaledWidth(11),
                                top: sm.scaledWidth(16),
                                bottom: sm.scaledWidth(16)),
                            child: roundedButton(
                                clicker: () {
                                  if (_key.currentState.validate())
                                    submitDataCall();
                                },
                                clr: Colors.red,
                                title: "Done"))
                      ],
                    ),
                  ),
                )));
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
          fromTo(txt: ctrl.text, clr: myRed),
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

  void getPageData() async {
    await WebService.funWaitlistSetting().then((value) {
      if (value.status == "success") {
        var va = value.data[0];
        startTime = va.startTime;
        endTime = va.endTime;
        controller[0].text = va.availableResource.toString();
        controller[1].text = va.miniumWaitTime.toString();
        controller[2].text = va.slotLength.toString();
        controller[3].text = va.bookingPerSlot.toString();
        controller[4].text = va.bookingPerDay.toString();
        controller[5].text = va.waitlistManagerName.toString();
        controller[6].text = va.announcement.toString();
        selectedList = va.exceptDays.split(",");
        setState(() {});
      }
    });
  }

  void submitDataCall() {
    var days = "";
    for (int _i = 0; _i < selectedList.length; _i++)
      days = days + (_i == 0 ? "" : ",") + selectedList[_i];

    Map _map = {
      "start_time": startTime,
      "end_time": endTime,
      "available_resource": controller[0].text,
      "minium_wait_time": controller[1].text,
      "slot_length": controller[2].text,
      "booking_per_slot": controller[3].text,
      "booking_per_day": controller[4].text,
      "waitlist_manager_name": controller[5].text,
      "announcement": controller[6].text,
      "except_days": days
    };
    WebService.funWaitlistSaveSetting(_map).then((value) {
      if (value.status == "success") {
        BotToast.showText(text: value.message);
      }
    });
  }
}
