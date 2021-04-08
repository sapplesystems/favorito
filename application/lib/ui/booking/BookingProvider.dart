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
    "Booking/Slot",
    "Booking/Day",
    "Announcement"
  ];
  int _totalBookingDays = 0;
  int _totalBookingHours = 0;
  List<User> _userInputList = [];
  DateTime _initialDate = DateTime.now();
  String _selectedDateText = 'Select Date';
  int _selectedSlotIndex = 0;

  DateTime getInitialDate() => _initialDate;
  setInitialDate(String _v) {
    _initialDate = DateTime.parse(_v);
    getBookingData();
    notifyListeners();
  }

  getSelectedSlotIndex() => _selectedSlotIndex;
  setSelectedSlotIndex(int _i) {
    _selectedSlotIndex = _i;
    notifyListeners();
  }

  int _selectedSlot = 0;

  bookingListModel blm = bookingListModel();
  bool _isProgress = false;
  bool _done = false;
  String _startTime = "00:00";
  String _endTime = "00:00";

  getStartTime() => _startTime;
  setStartTime(String _val) {
    _startTime = _val;
    notifyListeners();
  }

  getEndTime() => _endTime;
  setEndTime(String _val) {
    _endTime = _val;
    notifyListeners();
  }

  MaterialLocalizations localizations;
  List<TextEditingController> controller = [];
  bookingSettingModel bs;
  BookingProvider() {
    for (int i = 0; i < 6; i++) {
      controller.add(TextEditingController());
      controller[i].text = (i != 5 && i != 2) ? "0" : '';
    }

    RIKeys.josKeys3.currentState.changeSelectedItem(slot[3]);
    getBookingData();
    getPageData();
  }
  getTotalBookingDays() => _totalBookingDays;
  setTotalBookingDays(int _i) {
    _totalBookingDays = _i;
    notifyListeners();
  }

  getTotalBookingHours() => _totalBookingHours;
  setTotalBookingHours(int _i) {
    _totalBookingHours = _i;
    notifyListeners();
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
      "start_time": _startTime,
      "end_time": _endTime,
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
    await WebService.funBookingSaveSetting(_map, RIKeys.josKeys5.currentContext)
        .then((value) {
      _isProgress = false;

      notifyListeners();
      if (value.status == "success") {
        setDone(false);
        this.snackBar(value.message, RIKeys.josKeys5);
      }
    });
  }

  void getPageData() async {
    await WebService.funBookingSetting().then((value) {
      if (value.status == "success") {
        bs = value;
        _totalBookingDays = bs.data[0]?.advanceBookingEndDays ?? 0;
        setStartTime(bs.data[0]?.startTime?.substring(0, 5) ?? '');
        setEndTime(bs.data[0]?.endTime?.substring(0, 5) ?? '');
        controller[0].text = bs.data[0]?.advanceBookingEndDays?.toString();
        controller[1].text = bs.data[0]?.advanceBookingHours?.toString();
        setTotalBookingHours(bs.data[0]?.advanceBookingHours ?? 0);
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
    localizations = MaterialLocalizations.of(RIKeys.josKeys5.currentContext);
    showTimePicker(
      context: RIKeys.josKeys5.currentContext,
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
        setStartTime(_va);
      else
        setEndTime(_va);
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

  void deleteBooking(int id) async {
    print('fffff');
    await WebService.deleteBooking(
            {'booking_id': id}, RIKeys.josKeys5.currentContext)
        .then((value) {
      if (value.status == "success") {
        getBookingData();
      }
    });
  }
}
