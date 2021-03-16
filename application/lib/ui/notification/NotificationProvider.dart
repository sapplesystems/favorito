import 'dart:convert' as convert;
import 'package:Favorito/model/BaseResponse/BaseResponseModel.dart';
import 'package:Favorito/model/notification/CityListModel.dart';
import 'package:Favorito/model/notification/CreateNotificationRequiredDataModel.dart';
import 'package:Favorito/model/notification/NotificationListRequestModel.dart';
import 'package:Favorito/model/notification/NotificationOneModel.dart';
import 'package:Favorito/network/RequestModel.dart';
import 'package:Favorito/network/serviceFunction.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class NotificationsProvider extends ChangeNotifier {
  int _notificationId = 0;

  List<String> countryList = ['India'];
  List<String> quantityList = ['quantity 1', 'quantity 2'];
  CreateNotificationRequiredDataModel notificationRequiredData =
      CreateNotificationRequiredDataModel();
  NotificationOneModel notificationOneModel;
  CityListModel cityListModel = CityListModel();
  String contactHintText = '';
  String selectedAction = '';
  String selectedAudience = '';
  String selectedArea = '';
  String selectedCountry = '';
  StateModel selectedState = StateModel();
  CityModel selectedCity = CityModel();
  String selectedQuantity = '';
  bool _countryVisible = false;
  bool _stateVisible;
  bool _cityVisible = false;
  bool _pincodeVisible = false;
  bool autoValidateForm = false;
  bool validatePincode = false;
  bool _showDone = false;
  bool getShowDone() => this._showDone;
  String _myAreaDetails = '';
  setShowDone(bool value) {
    _showDone = (value);
    // _showDone = (value && (_notificationId == 0));
    notifyListeners();
  }

  getMyAreaDetails() => _myAreaDetails;
  final actioncKey = GlobalKey<DropdownSearchState<String>>();
  final audienceKey = GlobalKey<DropdownSearchState<String>>();
  final areaKey = GlobalKey<DropdownSearchState<String>>();
  final countryKey = GlobalKey<DropdownSearchState<String>>();
  final cityKey = GlobalKey<DropdownSearchState<String>>();
  final stateKey = GlobalKey<DropdownSearchState<String>>();
  final quantityKey = GlobalKey<DropdownSearchState<String>>();
  final myTitleEditController = TextEditingController();
  final myDescriptionEditController = TextEditingController();
  final myContactEditController = TextEditingController();
  final myPincodeEditController = TextEditingController();
  List<String> errors = [null, null, null, null];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  NotificationListRequestModel notificationsListdata =
      NotificationListRequestModel();
  BuildContext _context;
  setContext(BuildContext _context) {
    this._context = _context;
  }

  getPincodeVisible() => _pincodeVisible ?? false;
  setPincodeVisible(bool _val) {
    this._pincodeVisible = _val;
    myPincodeEditController.text = getMyAreaDetails() ?? '';
    notifyListeners();
  }

  getStateVisible() => _stateVisible ?? false;
  setStateVisible(bool _val) {
    _stateVisible = _val;
    if (_val) {
      stateKey?.currentState
          ?.changeSelectedItem(getMyAreaDetails().toString().trim());
      selectedState.state = getMyAreaDetails().toString().trim();
    }

    notifyListeners();
  }

  selectArea(String _val) {
    this.selectedArea = _val;

    if (_val == 'Country') {
      setCountryVisible(true);
      setStateVisible(false);
      setCityVisible(false);
      setPincodeVisible(false);
    } else if (_val == 'State') {
      setStateVisible(true);
      setCountryVisible(false);
      setCityVisible(false);
      setPincodeVisible(false);
    } else if (_val == 'City') {
      setCityVisible(true);
      setCountryVisible(false);
      setStateVisible(false);
      setPincodeVisible(false);
    } else if (_val == 'Pincode') {
      setPincodeVisible(true);
      setCountryVisible(false);
      setStateVisible(false);
      setCityVisible(false);
      validatePincode = true;
    }
  }

  getCityVisible() => _cityVisible ?? false;
  setCityVisible(bool _val) {
    this._cityVisible = _val;
    if (_val) {
      cityKey?.currentState?.changeSelectedItem(getMyAreaDetails() ?? '');
      selectedCity.city = getMyAreaDetails() ?? '';
    }

    notifyListeners();
  }

  getCountryVisible() => _countryVisible;
  setCountryVisible(bool _val) {
    print("ddd0${getMyAreaDetails()}");
    this._countryVisible = _val;
    if (_val) {
      countryKey?.currentState?.changeSelectedItem(getMyAreaDetails() ?? '');
      selectedCountry = getMyAreaDetails() ?? '';
    }
    notifyListeners();
  }

  NotificationsProvider() {
    getData();
    verbose();
    getCityData();
  }
  getNotificationId() => _notificationId;
  setNotificationId(int _id) {
    print(_id);
    this._notificationId = _id;
    notificationDetait();
  }

  getData() {
    WebService.funGetNotifications(_context).then((value) {
      notificationsListdata = value;
      notifyListeners();
      setCityVisible(false);
      setCountryVisible(false);
      setStateVisible(false);
      setCityVisible(false);
    });
  }

  getActionData() => notificationRequiredData?.data?.action;

  verbose() async {
    await WebService.funGetCreateNotificationDefaultData(_context)
        .then((value) => notificationRequiredData = value);
    notifyListeners();
  }

  get cityListData => cityListModel?.data;
  notificationDetait() {
    if (_notificationId != null) {
      RequestModel requestModel = RequestModel();
      requestModel.data = {"id": _notificationId};
      requestModel.context = _context;
      requestModel.url = serviceFunction.funNotificationsDetail;

      WebService.serviceCall(requestModel).then((_v) {
        var value =
            NotificationOneModel.fromJson(convert.json.decode(_v.toString()));
        notificationOneModel = value;

        _myAreaDetails = value.data[0].areaDetail;
        actioncKey?.currentState?.changeSelectedItem(value.data[0].action);
        audienceKey?.currentState?.changeSelectedItem(value.data[0].audience);
        quantityKey?.currentState?.changeSelectedItem(value.data[0].quantity);
        areaKey?.currentState?.changeSelectedItem(value.data[0].area);

        selectArea(value.data[0].area);

        validatePincode = false;
        autoValidateForm = false;
        myTitleEditController.text = value.data[0].title;
        myDescriptionEditController.text = value.data[0].description;
        myContactEditController.text = value.data[0].contact;

        notifyListeners();
      });
    }
  }

  verifyPinCode(String _val) async {
    RequestModel requestModel = RequestModel();
    requestModel.context = _context;
    requestModel.url = serviceFunction.funGetCityByPincode;
    requestModel.data = {"pincode": _val};
    if (_val.length == 6)
      await WebService.serviceCall(requestModel).then((value) {
        var _v =
            BaseResponseModel.fromJson(convert.json.decode(value.toString()));
        if (_v.status == 'success') {
          errors[3] = null;
          return;
        } else {
          errors[3] = null;
          myPincodeEditController.text = '';
          errors[3] = _v.message;
          return;
        }
      });
  }

  initializeDefaultValues() {
    contactHintText = '';
    selectedAction = '';
    selectedAudience = '';
    selectedArea = '';
    selectedCountry = 'India';
    selectedState = null;
    selectedCity = null;
    selectedQuantity = '';
    setCountryVisible(false);
    setStateVisible(false);
    setCityVisible(false);
    setPincodeVisible(false);
    validatePincode = false;
    autoValidateForm = false;
    myTitleEditController.text = '';
    myDescriptionEditController.text = '';
    myContactEditController.text = '';
    myPincodeEditController.text = '';
  }

  getCityData() async {
    await WebService.funGetCities().then((value) => cityListModel = value);
  }

  submit() {
    print("sss:$selectedArea:$selectedCountry");
    if (formKey.currentState.validate()) {
      int areaDetailId =
          notificationRequiredData.data.area.indexOf(selectedArea);
      print("detail is $areaDetailId");
      var areaDetail = (areaDetailId == 0)
          ? selectedCountry
          : (areaDetailId == 1)
              ? selectedState.state
              : (areaDetailId == 2)
                  ? selectedCity.city
                  : myPincodeEditController.text;

      Map _map = {
        "title": this.myTitleEditController.text,
        "description": this.myDescriptionEditController.text,
        "action": this.selectedAction,
        "contact": this.myContactEditController.text,
        "audience": this.selectedAudience,
        "area": this.selectedArea,
        "area_detail": areaDetail,
        "quantity": this.selectedQuantity
      };
      print("_map");
      RequestModel requestModel = RequestModel();
      requestModel.data = _map;
      requestModel.context = _context;
      requestModel.url = serviceFunction.funCreateNotification;
      print(_map);
      WebService.funCreateNotification(requestModel, _context).then((value) {
        BotToast.showText(text: value.message);
        if (value.status == 'success') {
          getData();
          Navigator.pop(_context);
        } else {}
      });
    } else {
      autoValidateForm = true;
    }
  }

  allClear() {
    _myAreaDetails = '';
    myTitleEditController.text = '';
    myDescriptionEditController.text = '';
    myContactEditController.text = '';
    myPincodeEditController.text = '';
    selectedAction = '';
    selectedAudience = '';
    selectedArea = '';
    selectedCountry = '';
    selectedState = StateModel();
    selectedCity.city = '';
    selectedQuantity = '';
  }
}
