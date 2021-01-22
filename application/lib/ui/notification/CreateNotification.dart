import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/model/notification/CityListModel.dart';
import 'package:Favorito/model/notification/CreateNotificationRequestModel.dart';
import 'package:Favorito/model/notification/CreateNotificationRequiredDataModel.dart';
import 'package:Favorito/model/notification/NotificationOneModel.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';

class CreateNotification extends StatefulWidget {
  int id;
  CreateNotification({this.id});
  @override
  _CreateNotificationState createState() => _CreateNotificationState();
}

class _CreateNotificationState extends State<CreateNotification> {
  List<String> _countryList = ['India'];
  List<String> _quantityList = ['quantity 1', 'quantity 2'];
  CreateNotificationRequiredDataModel _notificationRequiredData =
      CreateNotificationRequiredDataModel();
  NotificationOneModel notificationOneModel;
  CityListModel _cityListModel = CityListModel();
  String _contactHintText = '';
  String _selectedAction = '';
  String _selectedAudience = '';
  String _selectedArea = '';
  String _selectedCountry = '';
  StateModel _selectedState = StateModel();
  CityModel _selectedCity = CityModel();
  String _selectedQuantity = '';
  bool _countryVisible;
  bool _stateVisible;
  bool _cityVisible;
  bool _pincodeVisible;
  bool _autoValidateForm = false;
  bool _validatePincode = false;

  final _myTitleEditController = TextEditingController();
  final _myDescriptionEditController = TextEditingController();
  final _myContactEditController = TextEditingController();
  final _myPincodeEditController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WebService.funGetCreateNotificationDefaultData(context)
        .then((value) => _notificationRequiredData = value);
    super.initState();
    initializeDefaultValues();
    if (widget.id != null) {
      WebService.funNotificationsDetail({"id": widget.id}, context)
          .then((value) {
        setState(() {
          notificationOneModel = value;
          _contactHintText = value.data[0].contact;
          _selectedAction = value.data[0].action;
          _selectedAudience = value.data[0].audience;
          _selectedArea = value.data[0].area;
          _selectedCountry = value.data[0].areaDetail;
          // _selectedState = value.data[0].sta;
          // _selectedCity = value.data[0].city;
          _selectedQuantity = value.data[0].quantity;
          _countryVisible = false;
          _stateVisible = false;
          _cityVisible = false;
          _pincodeVisible = false;
          _validatePincode = false;
          _autoValidateForm = false;
          _myTitleEditController.text = value.data[0].title;
          _myDescriptionEditController.text = value.data[0].description;
          _myContactEditController.text = value.data[0].contact;

          setState(() {
            // _myPincodeEditController.text = value.data[0].;
          });
        });
      });
    }
    setState(() {});
  }

  initializeDefaultValues() {
    _contactHintText = '';
    _selectedAction = '';
    _selectedAudience = '';
    _selectedArea = '';
    _selectedCountry = 'India';
    _selectedState = null;
    _selectedCity = null;
    _selectedQuantity = '';
    _countryVisible = false;
    _stateVisible = false;
    _cityVisible = false;
    _pincodeVisible = false;
    _validatePincode = false;
    _autoValidateForm = false;
    _myTitleEditController.text = '';
    _myDescriptionEditController.text = '';
    _myContactEditController.text = '';
    _myPincodeEditController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            "Create Notification",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
            decoration: BoxDecoration(
              color: myBackGround,
            ),
            child: ListView(children: [
              Container(
                margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32.0),
                child: Card(
                    child: Builder(
                  builder: (context) => Form(
                    key: _formKey,
                    autovalidate: _autoValidateForm,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: txtfieldboundry(
                            controller: _myTitleEditController,
                            title: "Title",
                            security: false,
                            valid: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: txtfieldboundry(
                            controller: _myDescriptionEditController,
                            title: "Description",
                            security: false,
                            maxLines: 5,
                            valid: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: DropdownSearch<String>(
                            validator: (v) => v == '' ? "required field" : null,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            mode: Mode.MENU,
                            selectedItem: _selectedAction,
                            items: _notificationRequiredData.data != null
                                ? _notificationRequiredData.data.action
                                : null,
                            label: "Action",
                            hint: "Please Select Action",
                            showSearchBox: false,
                            onChanged: (value) {
                              setState(() {
                                if (value ==
                                    _notificationRequiredData.data.action[0]) {
                                  _contactHintText = 'Enter number for call';
                                } else {
                                  _contactHintText = 'Enter email for chat';
                                }
                                _selectedAction = value;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: txtfieldboundry(
                            controller: _myContactEditController,
                            title: "Contact",
                            security: false,
                            keyboardSet: TextInputType.number,
                            maxlen: 10,
                            hint: _contactHintText,
                            maxLines: 1,
                            valid: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: DropdownSearch<String>(
                            validator: (v) => v == '' ? "required field" : null,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            mode: Mode.MENU,
                            showSelectedItem: true,
                            selectedItem: _selectedAudience,
                            items: _notificationRequiredData.data != null
                                ? _notificationRequiredData.data.audience
                                : null,
                            label: "Audience",
                            hint: "Please Select Audience",
                            showSearchBox: false,
                            onChanged: (value) {
                              setState(() {
                                _selectedAudience = value;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: DropdownSearch<String>(
                            validator: (v) => v == '' ? "required field" : null,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            mode: Mode.MENU,
                            showSelectedItem: true,
                            selectedItem: _selectedArea,
                            items: _notificationRequiredData.data != null
                                ? _notificationRequiredData.data.area
                                : null,
                            label: "Area",
                            hint: "Please Select Area",
                            showSearchBox: false,
                            onChanged: (value) {
                              setState(() {
                                _selectedArea = value;
                                if (value ==
                                    _notificationRequiredData.data.area[0]) {
                                  _countryVisible = true;
                                  _stateVisible = false;
                                  _cityVisible = false;
                                  _pincodeVisible = false;
                                } else if (value ==
                                    _notificationRequiredData.data.area[1]) {
                                  _countryVisible = false;
                                  _stateVisible = true;
                                  _cityVisible = false;
                                  _pincodeVisible = false;
                                } else if (value ==
                                    _notificationRequiredData.data.area[2]) {
                                  _countryVisible = false;
                                  _stateVisible = false;
                                  _cityVisible = true;
                                  _pincodeVisible = false;
                                  WebService.funGetCities(context)
                                      .then((value) {
                                    setState(() {
                                      _cityListModel = value;
                                    });
                                  });
                                } else {
                                  _countryVisible = false;
                                  _stateVisible = false;
                                  _cityVisible = false;
                                  _pincodeVisible = true;
                                  _validatePincode = true;
                                }
                              });
                            },
                          ),
                        ),
                        Visibility(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: DropdownSearch<String>(
                              validator: (v) =>
                                  v == '' ? "required field" : null,
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              mode: Mode.MENU,
                              showSelectedItem: true,
                              selectedItem: _selectedCountry,
                              items: _countryList,
                              label: "Country",
                              showSearchBox: false,
                            ),
                          ),
                          visible: _countryVisible,
                        ),
                        Visibility(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: DropdownSearch<StateModel>(
                              validator: (v) =>
                                  v == null ? "required field" : null,
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              compareFn: (StateModel i, StateModel s) =>
                                  i.isEqual(s),
                              mode: Mode.MENU,
                              showSelectedItem: true,
                              itemAsString: (StateModel u) => u.userAsString(),
                              selectedItem: _selectedState,
                              items: _notificationRequiredData.data != null
                                  ? _notificationRequiredData.data.stateList
                                  : null,
                              label: "State",
                              hint: "Please Select State",
                              showSearchBox: false,
                              onChanged: (value) {
                                setState(() {
                                  _selectedState = value;
                                });
                              },
                            ),
                          ),
                          visible: _stateVisible,
                        ),
                        Visibility(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: DropdownSearch<CityModel>(
                              validator: (v) =>
                                  v == null ? "required field" : null,
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              mode: Mode.MENU,
                              showSelectedItem: true,
                              compareFn: (CityModel i, CityModel s) =>
                                  i.isEqual(s),
                              itemAsString: (CityModel u) => u.userAsString(),
                              selectedItem: _selectedCity,
                              items: _cityListModel.data != null
                                  ? _cityListModel.data
                                  : null,
                              label: "City",
                              hint: "Please Select City",
                              showSearchBox: true,
                              onChanged: (value) {
                                setState(() {
                                  _selectedCity = value;
                                });
                              },
                            ),
                          ),
                          visible: _cityVisible,
                        ),
                        Visibility(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: txtfieldboundry(
                              controller: _myPincodeEditController,
                              title: "Pincode",
                              security: false,
                              hint: 'Please enter pincode',
                              maxLines: 1,
                              valid: _validatePincode,
                              maxlen: 6,
                              myOnChanged: (val) {
                                if (_myPincodeEditController.text.length == 6) {
                                  WebService.funValidPincode(
                                          _myPincodeEditController.text,
                                          context)
                                      .then((value) {
                                    if (value.status == 'success') {
                                      BotToast.showText(
                                          text: "Pincode verified");
                                      return;
                                    } else {
                                      _myPincodeEditController.text = '';
                                      BotToast.showText(
                                          text: "Please enter valid pincode");
                                      return;
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                          visible: _pincodeVisible,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: DropdownSearch<String>(
                            validator: (v) => v == '' ? "required field" : null,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            mode: Mode.MENU,
                            selectedItem: _selectedQuantity,
                            items: _quantityList,
                            label: "Quantity",
                            hint: "Please Select Quantity",
                            showSearchBox: false,
                            onChanged: (value) {
                              setState(() {
                                _selectedQuantity = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
              ),
              Visibility(
                visible: widget.id == null,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: sm.w(50),
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: roundedButton(
                      clicker: () {
                        if (_formKey.currentState.validate()) {
                          var requestData = CreateNotificationRequestModel();
                          requestData.title = _myTitleEditController.text;
                          requestData.description =
                              _myDescriptionEditController.text;
                          requestData.selectedAction = _selectedAction;
                          requestData.contact = _myContactEditController.text;
                          requestData.selectedAudience = _selectedAudience;
                          requestData.selectedArea = _selectedArea;
                          if (_selectedArea ==
                              _notificationRequiredData.data.area[0]) {
                            requestData.areaDetail = _selectedCountry;
                          } else if (_selectedArea ==
                              _notificationRequiredData.data.area[1]) {
                            requestData.areaDetail = _selectedState.state;
                          } else if (_selectedArea ==
                              _notificationRequiredData.data.area[2]) {
                            requestData.areaDetail = _selectedCity.city;
                          } else if (_selectedArea ==
                              _notificationRequiredData.data.area[3]) {
                            requestData.areaDetail =
                                _myPincodeEditController.text;
                          }
                          requestData.selectedQuantity = _selectedQuantity;
                          WebService.funCreateNotification(requestData, context)
                              .then((value) {
                            if (value.status == 'success') {
                              setState(() {
                                initializeDefaultValues();
                              });
                            } else {
                              BotToast.showText(text: value.message);
                            }
                          });
                        } else {
                          _autoValidateForm = true;
                        }
                      },
                      clr: Colors.red,
                      title: "Send",
                    ),
                  ),
                ),
              ),
            ])));
  }
}
