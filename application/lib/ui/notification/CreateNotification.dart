import 'package:application/component/roundedButton.dart';
import 'package:application/component/txtfieldboundry.dart';
import 'package:application/model/notification/CreateNotificationRequestModel.dart';
import 'package:application/network/webservices.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CreateNotification extends StatefulWidget {
  @override
  _CreateNotificationState createState() => _CreateNotificationState();
}

class _CreateNotificationState extends State<CreateNotification> {
  List<String> _actionList;
  List<String> _audienceList;
  List<String> _areaList;
  List<String> _countryList;
  List<String> _stateList;
  List<String> _cityList;
  List<String> _quantityList;

  String _contactHintText;
  String _selectedAction;
  String _selectedAudience;
  String _selectedArea;
  String _selectedCountry;
  String _selectedState;
  String _selectedCity;
  String _selectedQuantity;
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
    WebService.funGetCreateNotificationDefaultData().then((value) {
      setState(() {
        _actionList = value.actionList;
        _audienceList = value.audienceList;
        _areaList = value.areaList;
        _stateList = value.stateList;
        _quantityList = value.quantityList;
      });
    });
    super.initState();
    initializeDefaultValues();
  }

  initializeDefaultValues() {
    _contactHintText = '';
    _selectedAction = '';
    _selectedAudience = '';
    _selectedArea = '';
    _selectedCountry = 'India';
    _selectedState = '';
    _selectedCity = '';
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
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Color(0xfffff4f4),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            "Notification",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
            decoration: BoxDecoration(
              color: Color(0xfffff4f4),
            ),
            child: ListView(children: [
              Container(
                height: context.percentHeight * 75,
                margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32.0),
                child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    child: Builder(
                      builder: (context) => Form(
                        key: _formKey,
                        autovalidate: _autoValidateForm,
                        child: ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: txtfieldboundry(
                                ctrl: _myTitleEditController,
                                title: "Title",
                                security: false,
                                valid: true,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: txtfieldboundry(
                                ctrl: _myDescriptionEditController,
                                title: "Description",
                                security: false,
                                maxLines: 5,
                                valid: true,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: DropdownSearch<String>(
                                validator: (v) =>
                                    v == '' ? "required field" : null,
                                autoValidate: true,
                                mode: Mode.MENU,
                                selectedItem: _selectedAction,
                                items: _actionList,
                                label: "Action",
                                hint: "Please Select Action",
                                showSearchBox: false,
                                onChanged: (value) {
                                  setState(() {
                                    if (value == _actionList[0]) {
                                      _contactHintText =
                                          'Enter number for call';
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
                                ctrl: _myContactEditController,
                                title: "Contact",
                                security: false,
                                hint: _contactHintText,
                                maxLines: 1,
                                valid: true,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: DropdownSearch<String>(
                                validator: (v) =>
                                    v == '' ? "required field" : null,
                                autoValidate: true,
                                mode: Mode.MENU,
                                showSelectedItem: true,
                                selectedItem: _selectedAudience,
                                items: _audienceList,
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
                                validator: (v) =>
                                    v == '' ? "required field" : null,
                                autoValidate: true,
                                mode: Mode.MENU,
                                showSelectedItem: true,
                                selectedItem: _selectedArea,
                                items: _areaList,
                                label: "Area",
                                hint: "Please Select Area",
                                showSearchBox: false,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedArea = value;
                                    if (value == _areaList[0]) {
                                      _countryVisible = true;
                                      _stateVisible = false;
                                      _cityVisible = false;
                                      _pincodeVisible = false;
                                    } else if (value == _areaList[1]) {
                                      _countryVisible = false;
                                      _stateVisible = true;
                                      _cityVisible = false;
                                      _pincodeVisible = false;
                                    } else if (value == _areaList[2]) {
                                      _countryVisible = false;
                                      _stateVisible = false;
                                      _cityVisible = true;
                                      _pincodeVisible = false;
                                      WebService.funGetCities().then((value) {
                                        setState(() {
                                          _cityList = value.cityList;
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
                                  autoValidate: true,
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
                                child: DropdownSearch<String>(
                                  validator: (v) =>
                                      v == '' ? "required field" : null,
                                  autoValidate: true,
                                  mode: Mode.MENU,
                                  showSelectedItem: true,
                                  selectedItem: _selectedState,
                                  items: _stateList,
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
                                child: DropdownSearch<String>(
                                  validator: (v) =>
                                      v == '' ? "required field" : null,
                                  autoValidate: true,
                                  mode: Mode.MENU,
                                  showSelectedItem: true,
                                  selectedItem: _selectedCity,
                                  items: _cityList,
                                  label: "City",
                                  hint: "Please Select City",
                                  showSearchBox: false,
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
                                  ctrl: _myPincodeEditController,
                                  title: "Pincode",
                                  security: false,
                                  hint: 'Please enter pincode',
                                  maxLines: 1,
                                  valid: _validatePincode,
                                  maxlen: 6,
                                  myOnChanged: (val) {
                                    if (_myPincodeEditController.text.length ==
                                        6) {
                                      WebService.funValidPincode(
                                              _myPincodeEditController.text)
                                          .then((value) {
                                        if (value != null) {
                                          BotToast.showText(
                                              text: "Pincode verified");
                                          return;
                                        } else {
                                          _myPincodeEditController.text = '';
                                          BotToast.showText(
                                              text:
                                                  "Please enter valid pincode");
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
                                validator: (v) =>
                                    v == '' ? "required field" : null,
                                autoValidate: true,
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
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: context.percentWidth * 50,
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
                        if (_selectedArea == _areaList[0]) {
                          requestData.selectedCountry = _selectedCountry;
                        } else if (_selectedArea == _areaList[1]) {
                          requestData.selectedState = _selectedState;
                        } else if (_selectedArea == _areaList[2]) {
                          requestData.selectedCity = _selectedCity;
                        } else if (_selectedArea == _areaList[3]) {
                          requestData.pincode = _myPincodeEditController.text;
                        }
                        requestData.selectedQuantity = _selectedQuantity;
                        WebService.funCreateNotification(requestData)
                            .then((value) {
                          setState(() {
                            initializeDefaultValues();
                          });
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
            ])));
  }
}
