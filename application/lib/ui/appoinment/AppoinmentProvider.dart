

import 'package:Favorito/Provider/BaseProvider.dart';
import 'package:Favorito/model/appoinment/PersonList.dart';
import 'package:Favorito/model/appoinment/RestrictionOnlyModel.dart';
import 'package:Favorito/model/appoinment/SettingData.dart';
import 'package:Favorito/model/booking/bookingListModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/RIKeys.dart';
import 'package:Favorito/utils/dateformate.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/model/appoinment/appointmentServiceOnlyModel.dart';

class AppoinmentProvider extends BaseProvider {
  String _businessId;
  List<String> abc = ["Name", "Mobile", "Email"];
  List<TextEditingController> controller = [
    for (int _i = 0; _i < 15; _i++) TextEditingController()
  ];
  bool _loading = false;
  List<String> personListTxt = [];
  List<PersonList> _personList = [];
  List<String> servicesString = [];
  List<Data> _servicesList = [];
  bool _servicesDD = false;
  bool _personsDD = false;
  SettingData _settingData = SettingData();
  int _selectedSlotIndex = 0;
  bookingListModel _blm = bookingListModel();
  List<String> _restrictedServicesTxt = [];
  int _selectedRestrictionId;
  List<RestrictionOnlyModel> _restrictionList = [];

  List<String> slot = [
    '15 min',
    '30 min',
    '45 min',
    '60 min',
    '75 min',
    '90 min'
  ];
  String _startTime = '00:00';
  String _endTime = '00:00';
  DateTime _initialDate = DateTime.now();
  int _selectedAppointmentId = 0;
  AppoinmentProvider() {
    refreshCall();
  }
  refreshCall() {
    getPersonCall();
    getAllService();
    getRestriction();
    getSettingdata();
    RIKeys?.josKeys11?.currentState?.changeSelectedItem("60 min");
  }

  int _selectedSlot = 0;

  getSelectedSlotIndex() => _selectedSlotIndex;

  setSelectedSlotIndex(int _i) {
    _selectedSlotIndex = _i;
    notifyListeners();
  }

  DateTime getInitialDate() => _initialDate ?? DateTime.now();

  setInitialDate(String _v) {
    _initialDate = DateTime.parse(_v);
    notifyListeners();
    getAppointmentCall();
  }

  bool _isDone = false;

  getServicesDD() => _servicesDD;

  setServicesDD(bool _val) {
    _servicesDD = _val;
    notifyListeners();
  }

  getPersonsDD() => _personsDD;

  setPersonsDD(bool _val) {
    _personsDD = _val;
  }

  int getSelectedSlot() => _selectedSlot ?? 0;

  void setSelectedSlot(int _val) {
    _selectedSlot = _val;
    notifyListeners();
  }

  funAddPerson(context) async {
    int _serviceId;
    for (var _va in _servicesList) {
      if (_va.serviceName == controller[3].text) {
        _serviceId = _va.id;
      }
    }

    Map _map = {
      "person_name": controller[0].text,
      "service_id": _serviceId,
      "person_mobile": controller[1].text,
      // "person_email": controller[2].text
    };
    setLoading(true);
    print("_map:${_map}");

    await WebService.funAppoinmentSavePerson(_map, context).then((value) {
      if (value.status == "success") {
        setLoading(false);
        BotToast.showText(text: value.message, duration: Duration(seconds: 5));
        Navigator.pop(context);
        for (int i = 0; i < 5; i++) controller[i].text = "";
      }
    });
  }

  void getPersonCall() async {
    await WebService.funAppoinmentPerson().then((_value) {
      if (_value.status == "success") {
        _personList.clear();
        _personList.addAll(_value.data);
        personListTxt.clear();
        for (var _va in _personList) personListTxt.add(_va.personName ?? "");
        controller[1].text = "";
        notifyListeners();
      }
    });
  }

  List<PersonList> getPerson() {
    print('llll${_personList?.length}');
    return _personList;
  }

  getPersonNameById(int _id) {
    String _name;
    for (var _va in _personList) {
      if (_id == _va.id) {
        _name = _va.personName;
      }
    }
    return _name;
  }

  getPersonIdByName(String _name) {
    int _id;
    for (var _va in _personList) {
      if (_name == _va.personName) {
        _id = _va.id;
      }
    }
    return _id;
  }

  funAddServicesCall() async {
    if (controller[6].text != "") {
      WebService.funAppoinmentSaveService({"service_name": controller[6].text})
          .then((value) {
        if (value.status == "success") {
          controller[6].text = '';
          notifyListeners();

          BotToast.showText(
              text: value.message, duration: Duration(seconds: 5));
          getAllService();
        }
      });
    }
  }

  void getAllService() async {
    setLoading(true);
    await WebService.funAppoinmentService().then((_value) {
      if (_value.status == "success") {
        setLoading(false);
        setServicesList(_value.data);
        servicesString.clear();
        for (var _va in _servicesList)
          servicesString.add(_va.serviceName ?? "");
      }
    });
    notifyListeners();
  }

//_servicesList
  setServicesList(List _list) {
    _servicesList.clear();
    _servicesList = _list;
    notifyListeners();
  }

  getServiceNameById(int _id) {
    String _name;
    for (var _va in _servicesList) {
      if (_id == _va.id) {
        _name = _va.serviceName;
      }
    }
    print("name:$_name");
    return _name;
  }

  getServiceIdByName(String _name) {
    int _id;
    for (var _va in _servicesList) {
      if (_name.trim() == _va.serviceName) {
        _id = _va.id;
      }
    }
    print("id:$_id");
    return _id;
  }

  getServicesList() => _servicesList;

  getLoading() => _loading;

  setLoading(bool _val) {
    _loading = _val;
    notifyListeners();
  }

  getRestriction() async {
    await WebService.funAppoinmentRestriction().then((_value) {
      if (_value.status == "success") {
        try {
          setRestrictionList(_value.data);
        } catch (e) {
          print("Error:$e");
        }
        _restrictedServicesTxt.clear();
        for (var _va in _restrictionList) {
          _restrictedServicesTxt.add(_va.serviceName);
        }
      }
    });
  }

  addition(_id){
      int _i = int.parse(controller[_id].text);
      if(_id ==12){
        if(controller[12].text!=controller[13].text){
          controller[_id].text= (((_i<8))?++_i:_i).toString();
        }else return;
      }else{
          controller[_id].text= (((_i<8))?++_i:_i).toString();
      }
      setDone(true);
  }
  subTraction(_id){
    int _i = int.parse(controller[_id].text);
    if(_id ==13){
      if(controller[12].text!=controller[13].text){
          controller[_id].text = (_i > 1 ? _i - 1 : _i).toString();
      }else return;
    }else{
      controller[_id].text = (_i > 1 ? _i - 1 : _i).toString();
    }
    setDone(true);
  }

  getRestrictionList() => _restrictionList;

  setRestrictionList(List<RestrictionOnlyModel> _list) {
    _restrictionList.clear();
    _restrictionList = _list;
    notifyListeners();
  }

  deleteRestrictions(_va, context) async {
    await WebService.funAppoinmentDeleteRestriction(
            {"restriction_id": _va.id}, context)
        .then((value) {
      if (value.status == "success") {
        _restrictionList.remove(_va);
        notifyListeners();
      }
    });
  }

  cleanAllPerson() {
    controller[0].text = "";
    controller[1].text = "";
    controller[2].text = "";
  }

  void cleanAll() {
    cleanAllPerson();
    controller[3].text = "";
    controller[4].text = "";

    _servicesDD = false;
    _personsDD = false;
    if (_selectedRestrictionId != 0) {
      RestrictionOnlyModel _data = getSelectedRestriction();
      if (_data != null) {
        _servicesDD = false;
        _personsDD = false;
        if (_data.serviceId != 0) {
          controller[4].text = "Services";
          _servicesDD = true;
        }
        if (_data.personId != 0) {
          _personsDD = true;
          controller[4].text = "Person";
        }

        if (_data.serviceId != 0 && _data.personId != 0) {
          controller[4].text = "Both";
          _personsDD = true;
          _servicesDD = true;
        }
        controller[0].text = _data.serviceName ?? "";
        controller[1].text = _data.personName ?? "";
        controller[2].text = ((_data.dateTime ?? "").split(" - "))[0];
        controller[3].text = ((_data.dateTime ?? "").split(" - "))[1];
      }
    }
  }

  appClean() {
    controller[2].text = '';
    controller[3].text = '';
    controller[4].text = '';
    controller[5].text = '';
    controller[6].text = '';
    notifyListeners();
  }

  getSelectedRestriction() {
    RestrictionOnlyModel _data = RestrictionOnlyModel();
    for (var _va in _restrictionList) {
      if (_va.id == _selectedRestrictionId) {
        _data = _va;
      }
    }

    return _data;
  }

  selectDate(context, localizations) {
    var _d;
    var _t;
    if (controller[2].text.contains(':')) {
      _d = DateTime.parse((controller[2].text.split(' '))[0].trim());
    } else {
      _d = DateTime.now();
    }

    showDatePicker(
            context: context,
            initialDate: _d,
            firstDate: DateTime.now(),
            lastDate: DateTime(2022))
        .then((_val) {
      // showTimePicker(
      //   context: context,
      //   initialTime: TimeOfDay.now(),
      //   builder: (BuildContext context, Widget child) {
      //     return MediaQuery(
      //         data:
      //             MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
      //         child: child);
      //   },
      // ).then((value) {
        String date = dateFormat1.format(_val);
        // String time =
        //     localizations.formatTimeOfDay(value, alwaysUse24HourFormat: true);
        // print(date + " " + time);
        controller[3].text = date;
      // });
    });
    notifyListeners();
  }

  selectDate2(context, localizations) {
    var _ab;
    if (controller[2].text == '') {
      _ab = DateTime.now();
    } else {
      _ab = DateTime.parse(controller[2].text.trim());
    }
    print("_ab${_ab}");
    showDatePicker(
            context: context,
            initialDate: _ab,
            firstDate: DateTime.now(),
            lastDate: DateTime(2022))
        .then((_val) {
      // showTimePicker(
      //   context: context,
      //   initialTime: TimeOfDay.now(),
      //   builder: (BuildContext context, Widget child) {
      //     return MediaQuery(
      //       data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
      //       child: child,
      //     );
      //   },
      // ).then((value) {
        String date = dateFormat1.format(_val);
        // String time =
        //     localizations.formatTimeOfDay(value, alwaysUse24HourFormat: true);
        // print(date + " " + time);
        // controller[2].text = date + " " + time;
        controller[2].text = date;
      // });
    });
    notifyListeners();
  }

  setSelectedRestrictionId(int _val) {
    _selectedRestrictionId = _val;
    notifyListeners();
  }

  funDropDownChange(_value) {
    setServicesDD(false);
    setPersonsDD(false);
    switch (_value) {
      case "Services":
        setServicesDD(true);
        break;

      case "Person":
        setPersonsDD(true);
        break;

      case "Both":
        {
          setServicesDD(true);
          setPersonsDD(true);
          break;
        }
      default:
        {
          setServicesDD(false);
          setPersonsDD(false);
        }
    }
    controller[4].text = _value;
  }

  postRestriction(context) async {
    int _serviceId;
    int _personId;
    for (var _va in _servicesList) {
      if (_va.serviceName == controller[0].text) {
        _serviceId = _va.id;
      }
    }
    for (var _va in getPerson()) {
      if (_va.personName == controller[1].text) {
        _personId = _va.id;
      }
    }

    int _v1 = (controller[4].text == "Services" || controller[4].text == "Both")
        ? _serviceId
        : null;

    int _v2 = (controller[4].text == "Person" || controller[4].text == "Both")
        ? _personId
        : null;

    Map _map = {
      "restriction_id": _selectedRestrictionId ?? '',
      "service_id": [_v1],
      "person_id": [_v2],
      "start_datetime": controller[2].text,
      "end_datetime": controller[3].text
    };
    print("aaa:${controller[4].text}");
    if (controller[4].text != null && controller[4].text != "") {
      print("_map:${_map.toString()}");
      setLoading(true);

      await WebService.funAppoinmentSaveRestriction(
              _map, !(_selectedRestrictionId > 0), context)
          .then((_value) {
        if (_value.status == "success") {
          setLoading(false);
          BotToast.showText(
              text: _value.message, duration: Duration(seconds: 5));
          getRestriction();
          Navigator.pop(context);
        }
      });
    }
  }

  refresh() => notifyListeners();

  getStartTime() => _startTime;

  getEndTime() => _endTime;

  dateTimePicker(bool _val, localizations) {
    
    localizations = MaterialLocalizations.of(RIKeys.josKeys10.currentContext);
    showTimePicker(
      
      initialEntryMode: TimePickerEntryMode.input,
      context: RIKeys.josKeys10.currentContext,
      // initialTime: _val?_startTime:_endTime,
      initialTime: TimeOfDay(
          hour: int.parse((_val ? _startTime : _endTime).split(":")[0]),
          minute: int.parse((_val ? _startTime : _endTime).split(":")[1])),
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
      else {
        setEndTime(_va);
      }
      setDone(true);
    });
  }

  setStartTime(String _txt) {
    _startTime = _txt;
    notifyListeners();
  }

  setEndTime(String _txt) {
    _endTime = _txt;
    notifyListeners();
  }

  setDone(bool _val) {
    _isDone = _val;
    notifyListeners();
  }

  getDone() => _isDone;

  funSettingSubmit() async {
    Map _map = {
      "start_time": _startTime,
      "end_time": _endTime,
      "advance_booking_start_days": '0',
      "advance_booking_end_days": controller[9].text,
      "advance_booking_hours": (int.parse(controller[10].text)) * 60,
      "slot_length": controller[11].text,
      "booking_per_slot": controller[12].text,
      "booking_per_day": controller[13].text,
      "announcement": controller[14].text,
    };
    print('SettingDataSaving:${_map.toString()}');
    await WebService.funAppoinmentSaveSetting(_map).then((value) {
      if (value.status == "success") {
        setDone(false);

    refreshCall();
        BotToast.showText(text: value.message, duration: Duration(seconds: 5));
      }
    });
  }

  changeit(int i, bool val, String identifire) async {
    if (identifire == "p") {
      getPerson()[i].isActive = val ? 1 : 0;
      var _va = {
        "person_id": getPerson()[i].id,
        "is_active": getPerson()[i].isActive
      };
    print("datap:$_va");
      await WebService.funAppoinmentServicePersonOnOff(_va, false)
          .then((value) {
        if (value.status == "success") {
          BotToast.showText(
              text: value.message, duration: Duration(seconds: 5));
        }
      });
    }

    if (identifire == "s") {
      _servicesList[i].isActive = val ? 1 :0;

      var _va = {
        "service_id": _servicesList[i].id,
        "is_active": _servicesList[i].isActive
      };
      print("datas:$_va");
      await WebService.funAppoinmentServicePersonOnOff(_va, true).then((value) {
        if (value.status == "success") {
          BotToast.showText(
              text: value.message, duration: Duration(seconds: 5));
        }
      });
    }
    notifyListeners();
  }

  getSettingdata() async {
    await WebService.funAppoinmentSetting().then((value) {
      if (value.status == 'success') {
        _settingData = value.data[0];
        _startTime = _settingData?.startTime?.trim()?.substring(0, 5);
        _endTime = _settingData?.endTime?.trim()?.substring(0, 5);
        controller[9].text = _settingData.advanceBookingEndDays.toString();
        controller[10].text =
            '${(_settingData.advanceBookingHours / 60).toString().substring(0, 1)}';
        controller[11].text = _settingData.slotLength.toString();
        controller[12].text = _settingData.bookingPerSlot.toString();
        controller[13].text = _settingData.bookingPerDay.toString();
        controller[14].text = _settingData.announcement ?? "";
        RIKeys.josKeys11?.currentState?.changeSelectedItem(
            (_settingData.slotLength.toString().trim() ?? '60') + ' min');
        setDone(false);
      }
    });
  }

//appointment data get
  void getAppointmentCall() async {
    var _va = dateFormat1.format(_initialDate);
    print("appointment:${_va.toString()}");
    await WebService.funAppoinmentList({'appointment_date': _va}).then((value) {
      if (value.status == "success") {
        setAppoinmentData(value);
        notifyListeners();
      }
    });
  }

  void setAppoinmentData(bookingListModel _value) {
    _blm = _value;
    notifyListeners();
  }

  bookingListModel getAppointmentData() => _blm;

  setSelectedAppointmentId(int _id) {
    _selectedAppointmentId = _id;
    if (_id != 0) getAppoinmentDetail();
  }

  getSelectedAppointmentId() => _selectedAppointmentId;
//findAppointment by id
  getAppoinmentDetail() async {
    await WebService.funAppoinmentDetail(
        {'appointment_id': _selectedAppointmentId}).then((value) {
      if (value.status == 'success') {
        controller[0].text =
            "${value.data.createdDate.substring(6, 10)}-${value.data.createdDate.substring(3, 5)}-${value.data.createdDate.substring(0, 2)}";
        controller[1].text = value.data.createdTime;
        controller[2].text = value.data?.name ?? '';
        controller[3].text = value.data?.contact?.toString() ?? "";
        // controller[4].text = value.data.serviceId;
        // controller[5].text = value.data.name;
        controller[6].text = value.data?.specialNotes ?? '';
        RIKeys.josKeys14.currentState
            .changeSelectedItem(getServiceNameById(value.data?.serviceId));
        RIKeys.josKeys15.currentState
            .changeSelectedItem(getPersonNameById(value.data?.personId));
        controller[4].text = getServiceNameById(value.data?.serviceId);
        notifyListeners();
      }
    });
  }

  showOnlyDatePicker(context, int _controllerId) {
    var _ab;
    // if(controller[_controllerId].text=='Select Date'){
    _ab = DateTime.now();
    // }else{
    //   _ab = DateTime.parse(controller[_controllerId].text.trim());
    // }
    showDatePicker(
            context: context,
            initialDate: _ab,
            firstDate: DateTime.now(),
            lastDate: DateTime.now()
                .add(Duration(days: _settingData.advanceBookingEndDays-1)))
        .then((_val) {
      controller[_controllerId].text = dateFormat1.format(_val);
      notifyListeners();
    });
  }

  showOnlyTimePicker(context, int _controllerId) {
    var _abc;
    if (controller[_controllerId].text.contains(':')) {
      _abc = TimeOfDay(
          hour: int.parse(controller[_controllerId].text.split(":")[0]),
          minute: int.parse(controller[_controllerId].text.split(":")[1]));
    } else {
      _abc = TimeOfDay.now();
    }
    showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: _abc,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    ).then((value) {
      controller[_controllerId].text = MaterialLocalizations.of(context)
          .formatTimeOfDay(value, alwaysUse24HourFormat: true);
      notifyListeners();
    });
  }

  funSubmitManualAppointment(context) async {
    if (controller[0].text == 'Select Date') {
      BotToast.showText(
          text: "Please select a date", duration: Duration(seconds: 5));
      return;
    }
    if (controller[1].text == 'Select Time') {
      BotToast.showText(
          text: "Please select a time", duration: Duration(seconds: 5));
      return;
    }
    // for (var v in _servicesList ) {
    //   if (v.serviceName == controller[4].text)
    //     selectedService = v.id;
    // }
    // s// }
    var _va1 = getServiceIdByName(controller[4].text);
    var _va2 = getPersonIdByName(controller[5].text);
    Map<String, dynamic> _map1 = {
      "appointment_id": _selectedAppointmentId ?? 0,
      "created_date": controller[0].text,
      "created_time": controller[1].text,
      "name": controller[2].text,
      "contact": controller[3].text,
      "service_id": _va1,
      "person_id": _va2,
      "special_notes": controller[6].text
    };

    Map<String, dynamic> _map2 = {
      "created_date": controller[0].text,
      "created_time": controller[1].text,
      "name": controller[2].text,
      "contact": controller[3].text,
      "service_id": _va1,
      "person_id": _va2,
      "special_notes": controller[6].text
    };
    print("_map ${_selectedAppointmentId == 0 ? _map2 : _map1}");
    await WebService.funAppoinmentCreate(
            _selectedAppointmentId == 0 ? _map2 : _map1,
            _selectedAppointmentId == 0)
        .then((value) {
      if (value.status == "success") {
        BotToast.showText(text: value.message, duration: Duration(seconds: 5));
        Navigator.pop(context);
      }
    });
  }

  localAuth() async {
    if (preferences.getString('businessId') != _businessId) {
      _businessId = preferences.getString('businessId');
      _blm = bookingListModel();
      notifyListeners();
    }
  }
}
