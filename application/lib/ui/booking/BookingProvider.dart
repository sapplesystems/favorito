import 'package:Favorito/Provider/BaseProvider.dart';
import 'package:Favorito/model/booking/BookingModel.dart';
import 'package:Favorito/model/booking/bookingListModel.dart';
import 'package:Favorito/model/booking/bookingSettingModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/RIKeys.dart';
import 'package:flutter/material.dart';

class BookingProvider extends BaseProvider {
  List<String> titleList = [""];
  List<String> slot = ['15 min', '30 min', '45 min', '60 min'];
  List<String> title = [
    "Advance Booking(Days)",
    "Advance Booking(Hours)",
    "Slot Length (in minuts)",
    "Booking Per Slot",
    "Booking Per Day",
    "Announcement"
  ];
  List<User> _userInputList = [];
  DateTime _initialDate = DateTime.now();
  String _selectedDateText = 'Select Date';
  DateTime getSelectedDateText() => _initialDate;
  setSelectedDateText(String _v) {
    // DateTime today =
    //     DateTime(initialDate.year, initialDate.month, initialDate.day);
    // if (_v == today) {}
    _initialDate = DateTime.parse(_v);
    print("initialDate:$_initialDate");
  }

  int _selectedSlot = 0;

  bookingListModel blm = bookingListModel();
  bool _isProgress = false;
  bool _done = false;
  String startTime = "00:00";
  String endTime = "00:00";

  MaterialLocalizations localizations;
  List<TextEditingController> controller = [];
  bookingSettingModel bs;
  GlobalKey<FormState> key = GlobalKey();
  BookingProvider() {
    for (int i = 0; i < 6; i++) {
      controller.add(TextEditingController());
      controller[i].text = (i != 5 && i != 2) ? "0" : '';
    }
    getBookingData();
  }

  bool getIsProgress() => _isProgress;
  void setIsProgress(bool _val) {
    _isProgress = _val;
    notifyListeners();
  }

  int getSelectedSlot() => _selectedSlot;
  void setSelectedSlot(int _val) {
    _selectedSlot = _val;
    notifyListeners();
  }

  bool getDone() => _done;
  void setDone(bool _val) {
    _done = _val;
    notifyListeners();
  }

  void funSublim() async {
    Map _map = {
      "start_time": startTime,
      "end_time": endTime,
      "advance_booking_start_days": '0',
      "advance_booking_end_days": controller[0].text,
      "advance_booking_hours": controller[1].text,
      "slot_length": controller[2].text,
      "booking_per_slot": controller[3].text,
      "booking_per_day": controller[4].text,
      "announcement": controller[5].text
    };
    _isProgress = true;
    notifyListeners();
    await WebService.funBookingSaveSetting(_map, key.currentContext)
        .then((value) {
      _isProgress = false;

      notifyListeners();
      if (value.status == "success") {
        setDone(false);
        this.snackBar(value.message, key);
      }
    });
  }

  void getPageData() async {
    await WebService.funBookingSetting().then((value) {
      if (value.status == "success") {
        bs = value;
        startTime = bs.data[0]?.startTime.substring(0, 5) ?? '';
        endTime = bs.data[0]?.endTime.substring(0, 5) ?? '';
        controller[0].text = bs.data[0]?.advanceBookingEndDays?.toString();
        controller[1].text = bs.data[0]?.advanceBookingHours?.toString();
        controller[2].text = bs.data[0]?.slotLength?.toString() ?? '60';
        controller[3].text = bs.data[0]?.bookingPerSlot?.toString();
        controller[4].text = bs.data[0]?.bookingPerDay?.toString();
        controller[5].text = bs.data[0]?.announcement ?? '';
        RIKeys?.josKeys3?.currentState?.changeSelectedItem(
            slot[slot.indexOf('${controller[2].text} min')]);
        notifyListeners();
      }
    });
  }

  addition(int _i) {
    controller[_i].text = (int.parse(controller[_i].text) + 1).toString();
    setDone(true);
  }

  subTraction(int _i) {
    int a = int.parse(controller[_i].text);
    a = a > 0 ? a - 1 : a;
    controller[_i].text = a.toString();
    setDone(true);
  }

  dateTimePicker(bool _val) {
    localizations = MaterialLocalizations.of(key.currentContext);
    showTimePicker(
      context: key.currentContext,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext ctx, Widget child) {
        return MediaQuery(
            data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: true),
            child: child);
      },
    ).then((value) {
      var _va =
          localizations.formatTimeOfDay(value, alwaysUse24HourFormat: true);
      if (_val)
        startTime = _va;
      else
        endTime = _va;
      setDone(true);
    });
  }

  void getBookingData() async {
    await WebService.funBookingList(
            {'booking_date': _initialDate.toString().substring(0, 10)})
        .then((value) {
      if (value.status == "success") {
        blm = value;
        notifyListeners();
      }
    });
  }

  void actionOnBooking(bool isDelete, int id) async {
    await WebService.actionBooking(
            {'booking_id': id}, key.currentContext, isDelete)
        .then((value) {
      if (value.status == "success") {
        getBookingData();
      }
    });
  }
}
