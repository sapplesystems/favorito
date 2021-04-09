import 'package:favorito_user/Providers/BaseProvider.dart';
import 'package:favorito_user/model/appModel/BookingOrAppointment/BookTableVerbose.dart';
import 'package:favorito_user/model/appModel/BookingOrAppointment/BookingOrAppointmentDataModel.dart';
import 'package:favorito_user/model/appModel/SlotListModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/business/BusinessProfileProvider.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class AppBookProvider extends BaseProvider {
  AppBookProvider() : super() {
    _selectedTab = 'History';
    getrefreshedData();
  }
  bool canAdd;
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

  // var _myUserNameEditTextController = TextEditingController();
  // // var _noOfPeopleEditTextController = TextEditingController();
  // var _myMobileEditTextController = TextEditingController();
  // var _myNotesEditTextController = TextEditingController();
  List<TextEditingController> controller = [
    for (int i = 0; i < 5; i++) TextEditingController()
  ];

  String _selectedOccasion;

  String _selectedDateText;

  DateTime _initialDate;

  List<SlotListModel> slotList = [];

  int _participent = 0;
  String _message;
  int _isBooking;
  String _selectedTab;
  List<BookingOrAppointmentDataModel> _data = [];
  List<BookingOrAppointmentDataModel> newData = [];
  List<BookingOrAppointmentDataModel> oldData = [];
  BookTableVerbose _bookTableVerbose;
  BookTableVerbose getBookTableVerbose() => this._bookTableVerbose;

  setBookTableVerbose(BookTableVerbose value) {
    this._bookTableVerbose = value;
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

  set selectedOccasion(String value) => this._selectedOccasion = value;

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
    print("1servicess are called:${this.getBusinessId()}");
    await APIManager.baseUserBookingList(
            {"business_id": this.getBusinessId() ?? null}, _isBooking)
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
    print(
        "2servicess are called:${Provider.of<BusinessProfileProvider>(context, listen: false).getBusinessId()}");
    await APIManager.baseUserBookingVerbose({
      "business_id":
          Provider.of<BusinessProfileProvider>(context, listen: false)
                  .getBusinessId() ??
              null
    }).then((value) {
      setIsVerboseCall(false);
      _message = value.message;
      if (value.status == 'success') {
        setBookTableVerbose(value);
      }
    });
  }
}
