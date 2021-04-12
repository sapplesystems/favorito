import 'package:favorito_user/Providers/BaseProvider.dart';
import 'package:favorito_user/model/appModel/BookingOrAppointment/BookTableVerbose.dart';
import 'package:favorito_user/model/appModel/BookingOrAppointment/BookingOrAppointmentDataModel.dart';
import 'package:favorito_user/model/appModel/SlotListModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/business/BusinessProfileProvider.dart';
import 'package:favorito_user/utils/Acces.dart';
import 'package:favorito_user/utils/RIKeys.dart';
import 'package:favorito_user/utils/dateformate.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class AppBookProvider extends BaseProvider {
  AppBookProvider() : super() {
    _selectedTab = 'History';
    // getrefreshedData();
  }
  bool _submitCalled =false;
  List<String> _occasionNameList = [];
  List<Occasion> _occasionList = [];
  String _selectedOccasion;
  int _selectedOccutionId;
  int _selectedDateIndex = 0;
  int _selectedTimeIndex = 0;
  String _selectedDate = dateFormat1.format(DateTime.now());
  String _selectedTime = ' ';
  bool canAdd;

  List<Acces> acces = [for (int i = 0; i < 5; i++) Acces()];

  List<SlotListModel> slotList = [];

  int _participent = 1;
  String _message;
  int _isBooking;
  String _selectedTab;
  get getCanAdd => this.canAdd;

  set setCanAdd(bool canAdd) {
    this.canAdd = canAdd;
    notifyListeners();
  }

  bool _isVerboseCall = true;

  bool getIsVerboseCall() => _isVerboseCall;

  setIsVerboseCall(bool _val) {
    _isVerboseCall = _val;
  }
getSubmitCalled()=>_submitCalled;
setSubmitCalled(bool _val){
  _submitCalled=_val;
  notifyListeners();
}

  setSelectDate(context, int _i) {
    _selectedDateIndex = _i;
    _selectedDate = getBookTableVerbose().data.availableDates[_i].date;
    bookingVerbose(context);
    notifyListeners();
  }

  getSelectDate() => _selectedDateIndex;

  setSelectTime(int _i) {
    _selectedTimeIndex = _i;
    _selectedTime = getBookTableVerbose()?.data?.slots[_i].startTime;
    notifyListeners();
  }

  getSelectTime() => _selectedTimeIndex;

  List<BookingOrAppointmentDataModel> _data = [];
  List<BookingOrAppointmentDataModel> newData = [];
  List<BookingOrAppointmentDataModel> oldData = [];
  BookTableVerbose _bookTableVerbose;

  BookTableVerbose getBookTableVerbose() => this._bookTableVerbose;

  setBookTableVerbose(BookTableVerbose value) {
    this._bookTableVerbose = value;
    _occasionList.clear();
    _occasionList.add(Occasion(id: 0,occasion: "Select Occasion"));

    _occasionList.addAll(value.data.occasion);
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
    // _selectedOccutionId =
    for (int _i = 0; _i < _occasionList.length; _i++) {
      if(value.toLowerCase().trim() == _occasionList[_i].occasion.toLowerCase().trim()){
        _selectedOccutionId =_occasionList[_i].id;
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

  setIsBooking(int _val) {
    //this will used to confirm thiis bookking or appoinment , here 0 is booking , i is appoinment and 2 is for all
    _isBooking = _val;
  }

  int getIsBooking() => _isBooking;

  setPageData() {
    _data.clear();
    _data.addAll(_selectedTab == 'New' ? newData : oldData);
    notifyListeners();
  }

  getPageData() => _data;

  String getSelectedTab() => _selectedTab;

  void setSelectedTab(String _val) {
    _selectedTab = _val;
    setPageData();
    notifyListeners();
  }

  getOccasionList() {
    _occasionNameList.clear();
    for (int _i = 0; _i < _occasionList.length; _i++) {
      _occasionNameList.add(_occasionList[_i].occasion);
    }
    return _occasionNameList;
  }

  funSubmitBooking(context) async{
    var _v = Provider.of<BusinessProfileProvider>(context, listen: false)
        .getBusinessId().toString()??
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
Map _map ={'no_of_person':_participent,
'date_time':'${_selectedDate.toString()} ${_selectedTime.toString()}',
    'name':acces[0].controller.text,
    'phone':acces[1].controller.text,
    'special_notes':acces[2].controller.text,
    'business_id':_v,
    'occasion_id':_selectedOccutionId,
    'booking_id':''
};
    setSubmitCalled(true);
    await APIManager.baseUserBookingCreate(_map).then((value) {
      this.snackBar(value.message, RIKeys.josKeys19);
      if(value.status=='success'){

        _participent=1;
        acces[0].controller.text='';
        acces[1].controller.text='';
        acces[2].controller.text='';
        acces[0].error='';
        acces[1].error='';
        acces[2].error='';

        setSubmitCalled(false);
      }
    });
  }

  getMessage() => _message;

  getrefreshedData(context) async {
    print("1servicess are called:${this.getBusinessId()}");
    await APIManager.baseUserBookingList(
            {"business_id": Provider.of<BusinessProfileProvider>(context, listen: false)
                .getBusinessId() ??
                ''}, _isBooking)
        .then((value) {
      _message = value.message;
      if (value.status == 'success') {
        newData.clear();
        oldData.clear();
        for (int _i = 0; _i < value.data.length; _i++) {
          DateTime.parse(value.data[_i].createdDatetime).isAfter(DateTime.now())
              ? newData.add(value.data[_i])
              : oldData.add(value.data[_i]);
        }
      }
    });
  }

  bookingVerbose(context) async {
    await APIManager.baseUserBookingVerbose({
      "business_id":
          Provider.of<BusinessProfileProvider>(context, listen: false)
                  .getBusinessId() ??
              '',
      "date": _selectedDate
    }).then((value) {
      setIsVerboseCall(false);
      _message = value.message;

      if (value.status == 'success') {
        _selectedTime = getBookTableVerbose()?.data?.slots[0].startTime;
        _selectedOccasion="Select Occasion";
        setBookTableVerbose(value);

      }
    });
  }
}
