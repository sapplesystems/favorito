import 'package:favorito_user/Providers/BaseProvider.dart';
import 'package:favorito_user/model/appModel/BookingOrAppointment/BookTableVerbose.dart';
import 'package:favorito_user/model/appModel/BookingOrAppointment/BookingOrAppointmentDataModel.dart';
import 'package:favorito_user/services/APIManager.dart';

class AppBookProvider extends BaseProvider {
  AppBookProvider() {
    _selectedTab = 'History';
    getrefreshedData();
    baseUserBookingVerbose();
  }
  String _businessId;
  BaseProvider baseProvider = BaseProvider();
  int _participent = 0;
  String _message;
  int _isBooking;
  String _selectedTab;
  List<BookingOrAppointmentDataModel> _data = [];
  List<BookingOrAppointmentDataModel> newData = [];
  List<BookingOrAppointmentDataModel> oldData = [];
  BookTableVerbose bookTableVerbose;

  setBusinessId(String _val) {
    _businessId = _val;
    notifyListeners();
  }

  String getBusinessId() => _businessId;
  changeParticipent(bool _val) {
    if (_val)
      ++_participent;
    else {
      if (_participent > 1) --_participent;
    }

    notifyListeners();
  }

  // int i = int.parse(controller[0].text);
  //           controller[0].text = (i > 1 ? --i : i).toString();

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

  getMessage() => _message;

  getrefreshedData() async {
    print("1servicess are called:$_businessId");
    await APIManager.baseUserBookingList(
            {"business_id": _businessId ?? null}, _isBooking)
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

  Future<BookTableVerbose> baseUserBookingVerbose() async {
    print("2servicess are called:$_businessId");
    await APIManager.baseUserBookingVerbose(
        {"business_id": _businessId ?? null}).then((value) {
      _message = value.message;
      if (value.status == 'success') {
        bookTableVerbose = value;
      }
    });
    return bookTableVerbose;
  }
}
