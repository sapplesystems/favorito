import 'dart:convert' as convert;
import 'package:Favorito/model/BaseResponse/BaseResponseModel.dart';
import 'package:Favorito/model/notification/CityListModel.dart';
import 'package:Favorito/model/notification/CreateNotificationRequestModel.dart';
import 'package:Favorito/model/notification/CreateNotificationRequiredDataModel.dart';
import 'package:Favorito/model/notification/NotificationListRequestModel.dart';
import 'package:Favorito/model/notification/NotificationOneModel.dart';
import 'package:Favorito/network/RequestModel.dart';
import 'package:Favorito/network/serviceFunction.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:bot_toast/bot_toast.dart';
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
  bool _countryVisible;
  bool _stateVisible;
  bool _cityVisible = false;
  bool _pincodeVisible = false;
  bool autoValidateForm = false;
  bool validatePincode = false;
  bool _showDone = false;
  bool get showDone => this._showDone;

  set showDone(bool value) {
    this._showDone = value;
    notifyListeners();
  }

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
    notifyListeners();
  }

  getStateVisible() => _stateVisible ?? false;
  setStateVisible(bool _val) {
    this._stateVisible = _val;
    notifyListeners();
  }

  selectArea(String _val) {
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

    showDone = true;
  }

  getCityVisible() => _cityVisible ?? false;
  setCityVisible(bool _val) {
    this._cityVisible = _val;
    notifyListeners();
  }

  getCountryVisible() => _countryVisible ?? false;
  setCountryVisible(bool _val) {
    this._countryVisible = _val;
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
    notificationDetAIL();
  }

  getData() {
    WebService.funGetNotifications(_context).then((value) {
      notificationsListdata = value;
      notifyListeners();
    });
  }

  getActionData() => notificationRequiredData?.data?.action;

  verbose() async {
    await WebService.funGetCreateNotificationDefaultData(_context)
        .then((value) => notificationRequiredData = value);
    notifyListeners();
  }

  get cityListData => cityListModel?.data;
  notificationDetAIL() {
    if (_notificationId != null) {
      WebService.funNotificationsDetail({"id": _notificationId}, _context)
          .then((value) {
        notificationOneModel = value;
        contactHintText = value.data[0].contact;
        selectedAction = value.data[0].action;
        selectedAudience = value.data[0].audience;
        selectedArea = value.data[0].area;
        selectedCountry = value.data[0].areaDetail;
        selectedQuantity = value.data[0].quantity;

        setCountryVisible(false);
        setStateVisible(false);
        setCityVisible(false);
        setPincodeVisible(false);
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
    // funValidPincode
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

  changeArea(value) {
    selectedArea = value;
    if (value == notificationRequiredData.data.area[0]) {
      setCountryVisible(true);
      setStateVisible(false);
      setCityVisible(false);
      setPincodeVisible(false);
    } else if (value == notificationRequiredData.data.area[1]) {
      setCountryVisible(false);
      setStateVisible(true);
      setCityVisible(false);
      setPincodeVisible(false);
    } else if (value == notificationRequiredData.data.area[2]) {
      setCountryVisible(false);
      setStateVisible(true);

      setCityVisible(true);
      setPincodeVisible(false);
    } else {
      setCountryVisible(false);
      setStateVisible(true);

      setCityVisible(false);
      setPincodeVisible(true);
      validatePincode = true;

      showDone = true;
    }
  }

  submit() {
    if (formKey.currentState.validate()) {
      var requestData = CreateNotificationRequestModel();
      requestData.title = myTitleEditController.text;
      requestData.description = myDescriptionEditController.text;
      requestData.selectedAction = selectedAction;
      requestData.contact = myContactEditController.text;
      requestData.selectedAudience = selectedAudience;
      requestData.selectedArea = selectedArea;
      if (selectedArea == notificationRequiredData.data.area[0]) {
        requestData.areaDetail = selectedCountry;
      } else if (selectedArea == notificationRequiredData.data.area[1]) {
        requestData.areaDetail = selectedState.state;
      } else if (selectedArea == notificationRequiredData.data.area[2]) {
        requestData.areaDetail = selectedCity.city;
      } else if (selectedArea == notificationRequiredData.data.area[3]) {
        requestData.areaDetail = myPincodeEditController.text;
      }
      requestData.selectedQuantity = selectedQuantity;
      WebService.funCreateNotification(requestData, _context).then((value) {
        if (value.status == 'success') {
          // setState(() {
          //   initializeDefaultValues();
          // });
        } else {
          BotToast.showText(text: value.message);
        }
      });
    } else {
      autoValidateForm = true;
    }
  }

  allClear() {
    myTitleEditController.text = '';
    myDescriptionEditController.text = '';
    myContactEditController.text = '';
    myPincodeEditController.text = '';
    selectedAction = '';
    selectedAudience = '';
    selectedArea = '';
    selectedCountry = '';
    selectedState.state = '';
    selectedCity.city = '';
    selectedQuantity = '';
    notifyListeners();
  }
}
