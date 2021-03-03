import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class WaitlistProvider extends ChangeNotifier {
  BuildContext context;
  ProgressDialog pr;
  GlobalKey<FormState> key = GlobalKey();
  final slotKey = GlobalKey<DropdownSearchState<String>>();
  bool _done = false;
  List title = [
    "Waitlist Manager",
    "Anouncement",
    "Discription",
    "Minimum Wait Time(minutes)",
    "Slot Length",
    "Except"
  ];

  List<String> slot = [
    '15 min',
    '20 min',
    '25 min',
    '30 min',
    '35 min',
    '40 min',
    '45 min',
    '50 min'
  ];
  List<String> list = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];
  needSave(bool _val) {
    _done = _val;
    notifyListeners();
  }

  getNeedSave() => _done;

  List<String> selectedList = [];
  List<TextEditingController> controller = [];
  String startTime = "00:00";
  String endTime = "00:00";
  MaterialLocalizations localizations;

  void getPageData(context) async {
    await WebService.funWaitlistSetting(context).then((value) {
      if (value.status == "success") {
        var va = value.data[0];
        startTime = va?.startTime?.substring(0, 5) ?? '00:00';
        endTime = va?.endTime.substring(0, 5) ?? '00:00';
        controller[0].text = va.availableResource.toString();
        controller[1].text = va.miniumWaitTime?.toString() ?? '';
        controller[2].text = va.slotLength.toString() ?? '60';
        controller[3].text = va.bookingPerSlot?.toString();
        controller[4].text = va.bookingPerDay?.toString();
        controller[5].text = va.waitlistManagerName?.toString();
        controller[6].text = va.announcement?.toString();
        selectedList = va.exceptDays?.split(",");

        slotKey?.currentState?.changeSelectedItem('25 min');
        selectedList.forEach((element) => list.remove(element));
        notifyListeners();
      }
    });
  }

  void submitDataCall() {
    pr.show().timeout(Duration(seconds: 6));
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
    WebService.funWaitlistSaveSetting(_map, context).then((value) {
      pr.hide();
      if (value.status == "success") {
        BotToast.showText(text: value.message);

        needSave(false);
        notifyListeners();
      }
    });
  }

  WaitlistProvider() {
    for (int i = 0; i < 7; i++) controller.add(TextEditingController());
    controller[0].text = "0";
    controller[3].text = "0";
    controller[4].text = "0";
  }
  setContext(context) {
    this.context = context;
    pr = ProgressDialog(context, type: ProgressDialogType.Normal)
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
    localizations = MaterialLocalizations.of(context);
  }

  dateTimePicker(bool _val) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child);
      },
    ).then((value) {
      var _va =
          localizations.formatTimeOfDay(value, alwaysUse24HourFormat: true);
      if (_val) {
        startTime = _va;
      } else {
        endTime = _va;
      }
      needSave(true);
      notifyListeners();
    });
  }
}
