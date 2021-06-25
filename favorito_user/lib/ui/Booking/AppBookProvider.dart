import 'package:favorito_user/Providers/BaseProvider.dart';
import 'package:favorito_user/model/appModel/BookingOrAppointment/BookTableVerbose.dart';
import 'package:favorito_user/model/appModel/BookingOrAppointment/BookingOrAppointmentDataModel.dart';
import 'package:favorito_user/model/appModel/SlotListModel.dart';
import 'package:favorito_user/model/appModel/appointment/Occasion.dart';
import 'package:favorito_user/model/appModel/appointment/Slots.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/business/BusinessProfileProvider.dart';
import 'package:favorito_user/ui/user/PersonalInfo/PersonalInfoProvider.dart';
import 'package:favorito_user/utils/Acces.dart';
import 'package:favorito_user/utils/RIKeys.dart';
import 'package:favorito_user/utils/dateformate.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class AppBookProvider extends BaseProvider {
  AppBookProvider() : super() {
    _selectedTab = 'New';
    // getrefreshedData();
  }
  bool _isProcessing = false;

  List<String> appBookingHeaderList = ['Appointments', 'Booking'];
  String _appBookingHeader = 'Booking';
  bool _submitCalled = false;
  List<String> _occasionNameList = [];
  List<Occasion> _occasionList = [];
  String _selectedOccasion;
  int _selectedOccutionId;
  int _selectedDateIndex = 0;
  int _selectedTimeIndex = 0;
  String _selectedDate ;
  // = dateFormat1.format(DateTime.now());
  String _selectedTime ;
  // = ' ';
  List<Slots> _slots;

  List<Acces> acces = [for (int i = 0; i < 5; i++) Acces()];

  List<SlotListModel> slotList = [];

  int _participent = 1;
  String _message;
  bool _isBook = true;
  String _selectedTab;

  bool _isVerboseCall = true;

  String getAppBookingHeader() => _appBookingHeader;

  void setAppBookingHeader(String _name) {
    _appBookingHeader = _name;
    notifyListeners();
  }

  bool getIsVerboseCall() => _isVerboseCall;

  setIsVerboseCall(bool _val) {
    _isVerboseCall = _val;
  }

  getSubmitCalled()=> _submitCalled;
  

  setSubmitCalled(bool _val) {
    _submitCalled = _val;
    notifyListeners();
  }

  setSelectDate(context, int _i) {
    _selectedDateIndex = _i;
    _selectedDate = _bookTableVerbose.data.availableDates[_i].date;
    bookingVerbose(context);
    notifyListeners();
  }

checkMobile(val){
if(val.toString().trim().length!=10){
acces[1].error="Invalid mobile no";
notifyListeners();
}else{
acces[1].error=null;
notifyListeners();  
}
}
  getSelectDate() => _selectedDateIndex;

  setSelectTime(int _i) {
    _selectedTimeIndex = _i;
    _selectedTime = this._bookTableVerbose?.data?.slots[_i].startTime;
    notifyListeners();
  }

  getSelectTime() => _selectedTimeIndex;

  // List<BookingOrAppointmentDataModel> _data = [];
  List<BookingOrAppointmentDataModel> _appbookData = [];
  List<BookingOrAppointmentDataModel> _bookData = [];

  List<BookingOrAppointmentDataModel> newData = [];
  List<BookingOrAppointmentDataModel> oldData = [];
  BookTableVerbose _bookTableVerbose;

  BookTableVerbose getBookTableVerbose() {
    for (int i = 0;i <_bookTableVerbose?.data?.slots?.length;i++){
      print(_bookTableVerbose.data?.slots[i].startTime.substring(0, 5));
    }
    return this._bookTableVerbose;
  } 

  setBookTableVerbose(BookTableVerbose value) {
    this._bookTableVerbose = value;
    _occasionList.clear();
    _occasionList.add(Occasion(id: 0, occasion: "Select Occasion"));
    _occasionList.addAll(value.data.occasion);
    // dsfsdfsdfsdfds
    notifyListeners();
  }

  changeParticipent(bool _val) {
    if (_val)
      ++_participent;
    else {
      if (_participent > 1) --_participent;
    }

    notifyListeners();
  }

  String get selectedOccasion => this._selectedOccasion;

  set selectedOccasion(String value) {
    this._selectedOccasion = value;
    for (int _i = 0; _i < _occasionList.length; _i++) {
      if (value.toLowerCase().trim() ==
          _occasionList[_i].occasion.toLowerCase().trim()) {
        _selectedOccutionId = _occasionList[_i].id;
      }
    }
    notifyListeners();
  }

  getSelectedOccassionId() {
    for (var _v in _occasionList) {
      _selectedOccutionId = (selectedOccasion?.toString()?.trim() ==
              _v?.occasion?.toString()?.trim())
          ? _v.id
          : null;
    }
  }

  int getParticipent() => _participent;

  setIsBooking(bool _val) {
    _isBook = _val;
    notifyListeners();
  }

  bool getIsBooking() => _isBook;

  // setPageData() {
  //   _data.clear();
  //   _data.addAll(_selectedTab == 'History' ?oldData  : newData);
  //   notifyListeners();
  // }

  getPageData() => _selectedTab == 'History' ? oldData : newData;

  String getSelectedTab() => _selectedTab;

  void setSelectedTab(String _val) {
    _selectedTab = _val;
    // setPageData();
    notifyListeners();
  }

  getOccasionList() {
    _occasionNameList.clear();
    for (int _i = 0; _i < _occasionList.length; _i++) {
      _occasionNameList.add(_occasionList[_i].occasion);
    }
    return _occasionNameList;
  }

  funSubmitBooking(context) async {
    var _v = Provider.of<BusinessProfileProvider>(context, listen: false)
            .getBusinessId()
            .toString() ??
        '';
    if (acces[0].controller.text.isEmpty) {
      acces[0].error = 'Please Enter name';
      notifyListeners();
      return;
    } else
      acces[0].error = null;
    if (acces[1].controller.text.isEmpty) {
      acces[1].error = 'Please Enter mobile no';
      notifyListeners();
      return;
    } else
      acces[1].error = null;
    notifyListeners();
String date = 
    _bookTableVerbose.data.availableDates[_selectedDateIndex].date;
String time = 
    _bookTableVerbose.data.slots[_selectedTimeIndex].startTime;
    print("data:$date::time:$time");
    Map _map = {
      'no_of_person': _participent,
      'date_time': '$date $time',
      'name': acces[0].controller.text,
      'phone': acces[1].controller.text,
      'special_notes': acces[2].controller.text,
      'business_id': _v,
      'occasion_id': _selectedOccutionId,
      'booking_id': ''
    };
    setSubmitCalled(true);
    await APIManager.baseUserBookingCreate(_map).then((value) {
      this.snackBar(value.message, RIKeys.josKeys19);
      if (value.status == 'success') {
        _participent = 1;
        acces[0].controller.text = '';
        acces[1].controller.text = '';
        acces[2].controller.text = '';
        acces[0].error = '';
        acces[1].error = '';
        acces[2].error = '';

        setSubmitCalled(false);
        CallServiceForData(context);
        Navigator.pop(context);
      }
    });
  }

  getMessage() => _message;

  AppoointmentList(context) async {
    print("1servicess are called:${this.getBusinessId()}");
    await APIManager.baseUserBookingList(_isBook, RIKeys.josKeys22)
        .then((value) {
      _message = value.message;
      if (value.status == 'success') {
        _appbookData.clear();
        _appbookData.addAll(value.data);
        handleClick('Appointments');
      }
    });
  }

  BookingList(context) async {
    _isProcessing = true;
    await APIManager.baseUserBookingList(_isBook, RIKeys.josKeys22)
        .then((value) {
      _message = value.message;
      if (value.status == 'success') {
        print("app:book1:${_bookData.length}");
        _bookData.clear();

        print("app:book1:${_bookData.length}");
        _bookData.addAll(value.data);

        print("app:book1:${_bookData.length}");
        handleClick('Booking');
      }
    });
    notifyListeners();
  }

  CallServiceForData(context) {
    if (_isBook)
      BookingList(context);
    else
      AppoointmentList(context);
  }

  bookingVerbose(context) async {
    await APIManager.baseUserBookingVerbose({
      "business_id":
          Provider.of<BusinessProfileProvider>(context, listen: false)
                  .getBusinessId() ??
              '',
      "date": _selectedDate
    }, context)
        .then((value) {
      _message = value.message;
      
      if (value.status == 'success') {
     
        _selectedTime = value.data?.slots[0]?.startTime;
        _selectedOccasion = "Select Occasion";
        
        setBookTableVerbose(value);
      }
      _isVerboseCall = false;
    });
  }

  void setMyDetail(context) {
    acces[0].controller.text =
        Provider.of<PersonalInfoProvider>(context, listen: false)
                ?.profileModel
                ?.data
                ?.detail
                ?.fullName ??
            '';
    acces[1].controller.text =
        Provider.of<PersonalInfoProvider>(context, listen: false)
                ?.profileModel
                ?.data
                ?.detail
                ?.phone ??
            '';
    notifyListeners();
  }

  void handleClick(String value) {
    switch (value) {
      case 'Appointments':
        {
          print("app:app${_appbookData.length}");
          setIsBooking(false);
          setAppBookingHeader('Appointments');
          newData.clear();
          oldData.clear();

          for (int _i = 0; _i < _appbookData.length; _i++)
            DateTime.parse(_appbookData[_i].createdDatetime)
                    .isAfter(DateTime.now())
                ? newData.add(_appbookData[_i])
                : oldData.add(_appbookData[_i]);
          break;
        }
      case 'Booking':
        {
          print("app:book1:${_bookData.length}");
          setIsBooking(true);
          setAppBookingHeader('Booking');
          newData.clear();
          oldData.clear();
          for (int _i = 0; _i < _bookData.length; _i++) {
            // int _abc = DateTime.parse(_bookData[_i].createdDatetime).compareTo(DateTime.now());
            int _abc = DateTime.parse(_bookData[_i].createdDatetime)
                .difference(DateTime.now())
                .inMinutes;
            print("_abc:$_abc");
            print("_abcd:${_bookData[_i].createdDatetime}");
            if (_abc > 0) {
              newData.add(_bookData[_i]);
            } else {
              oldData.add(_bookData[_i]);
            }
          }
          break;
        }
    }
    notifyListeners();
    // setPageData();
  }
}
