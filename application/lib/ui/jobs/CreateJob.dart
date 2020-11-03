import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/model/job/CreateJobRequestModel.dart';
import 'package:Favorito/model/job/CreateJobRequiredDataModel.dart';
import 'package:Favorito/model/job/PincodeListModel.dart';
import 'package:Favorito/model/job/SkillListRequiredDataModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tagging/flutter_tagging.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/utils/myColors.dart';

class CreateJob extends StatefulWidget {
  final int _jobId;
  CreateJob(this._jobId);

  @override
  _CreateJobState createState() => _CreateJobState(_jobId);
}

class _CreateJobState extends State<CreateJob> {
  int _jobId;
  List<String> _contactOptionsList = [];
  List<CityList> _cityList = [];
  List<SkillListRequiredDataModel> _selectedSkillList = [];
  List<PincodeModel> _pincodesForCity = [];

  String _contactHint = '';
  String _selectedContactOption = '';
  CityList _selectedCity;

  bool _autoValidateForm = false;

  final _myTitleEditController = TextEditingController();
  final _myDescriptionEditController = TextEditingController();
  final _myContactEditController = TextEditingController();
  final _myPincodeEditController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _CreateJobState(this._jobId);

  @override
  void initState() {
    if (_jobId == null) {
      WebService.funGetCreteJobDefaultData().then((value) {
        setState(() {
          _contactOptionsList.clear();
          _cityList.clear();
          _contactOptionsList = value.data.contactVia;
          _cityList = value.data.cityList;
        });
      });
    } else {
      WebService.funGetEditJobData(_jobId).then((value) {
        setState(() {
          _contactOptionsList.clear();
          _cityList.clear();
          _contactOptionsList = value.verbose.contactVia;
          for (var temp in value.verbose.cityList) {
            CityList city = CityList();
            city.id = temp.id;
            city.city = temp.city;
            _cityList.add(city);
          }
          var tempList = value.data[0].skills.split(",");
          for (var temp in tempList) {
            SkillListRequiredDataModel skill =
                SkillListRequiredDataModel(temp, tempList.indexOf(temp));
            _selectedSkillList.add(skill);
          }
          _selectedContactOption = value.data[0].contactVia;
          for (var city in _cityList) {
            if (city.id == value.data[0].id) {
              _selectedCity = city;
              break;
            }
          }
          _myTitleEditController.text = value.data[0].title;
          _myDescriptionEditController.text = value.data[0].description;
          _myContactEditController.text = value.data[0].contactVia;
          _myPincodeEditController.text = value.data[0].pincode;
        });
      });
    }
    super.initState();
    initializeDefaultValues();
  }

  initializeDefaultValues() {
    if (_jobId == null) {
      _selectedSkillList.clear();
      _contactHint = '';
      _selectedContactOption = '';
      _selectedCity = null;
      _autoValidateForm = false;
      _myTitleEditController.text = '';
      _myDescriptionEditController.text = '';
      _myContactEditController.text = '';
      _myPincodeEditController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: myBackGround,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            "Create Job",
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
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
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
                              child: FlutterTagging<SkillListRequiredDataModel>(
                                initialItems: _selectedSkillList,
                                textFieldConfiguration: TextFieldConfiguration(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(),
                                    ),
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    hintText: 'Search Skill',
                                    labelText: 'Select Skill',
                                  ),
                                ),
                                findSuggestions: WebService.getLanguages,
                                additionCallback: (value) {
                                  return SkillListRequiredDataModel(value, 0);
                                },
                                onAdded: (skill) {
                                  // can call a service to add new skill
                                  return SkillListRequiredDataModel(
                                      skill.skillName, skill.id);
                                },
                                configureSuggestion: (skill) {
                                  return SuggestionConfiguration(
                                    title: Text(skill.skillName),
                                    additionWidget: Chip(
                                      avatar: Icon(
                                        Icons.add_circle,
                                        color: Colors.white,
                                      ),
                                      label: Text('Add New Tag'),
                                      labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                                configureChip: (skill) {
                                  return ChipConfiguration(
                                    label: Text(skill.skillName),
                                    backgroundColor: Colors.green,
                                    labelStyle: TextStyle(color: Colors.white),
                                    deleteIconColor: Colors.white,
                                  );
                                },
                                onChanged: () {
                                  setState(() {});
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: DropdownSearch<String>(
                                validator: (v) =>
                                    v == '' ? "required field" : null,
                                autoValidate: _autoValidateForm,
                                mode: Mode.MENU,
                                selectedItem: _selectedContactOption,
                                items: _contactOptionsList,
                                label: "Contact Via",
                                hint: "Please Select Option",
                                showSearchBox: false,
                                onChanged: (value) {
                                  setState(() {
                                    if (value == _contactOptionsList[0]) {
                                      _contactHint = 'Enter number for call';
                                    } else {
                                      _contactHint = 'Enter email for chat';
                                    }
                                    _selectedContactOption = value;
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
                                hint: _contactHint,
                                maxLines: 1,
                                valid: true,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: DropdownSearch<CityList>(
                                validator: (v) =>
                                    v == null ? "required field" : null,
                                autoValidate: _autoValidateForm,
                                mode: Mode.MENU,
                                showSelectedItem: true,
                                compareFn: (CityList i, CityList s) =>
                                    i.isEqual(s),
                                itemAsString: (CityList u) => u.userAsString(),
                                selectedItem: _selectedCity,
                                items: _cityList,
                                label: "City",
                                hint: "Please Select City",
                                showSearchBox: false,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCity = value;
                                    _pincodesForCity.clear();
                                    WebService.funGetPicodesForCity(
                                            _selectedCity.id)
                                        .then((value) {
                                      setState(() {
                                        _pincodesForCity = value.pincodeModel;
                                      });
                                    });
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: txtfieldboundry(
                                controller: _myPincodeEditController,
                                title: "Pincode",
                                security: false,
                                hint: 'Please enter pincode',
                                maxLines: 1,
                                valid: true,
                                maxlen: 6,
                                myOnChanged: (val) {
                                  if (_myPincodeEditController.text.length ==
                                      6) {
                                    if (_pincodesForCity.length != 0) {
                                      for (var temp in _pincodesForCity) {
                                        if (temp.pincode ==
                                            _myPincodeEditController.text) {
                                          break;
                                        } else {
                                          if (_pincodesForCity.indexOf(temp) ==
                                              _pincodesForCity.length - 1) {
                                            _pincodesForCity.clear();
                                            _selectedCity = null;
                                            BotToast.showText(
                                                text:
                                                    "Please enter a pincode from selected city");
                                          }
                                        }
                                      }
                                    } else {
                                      WebService.funGetCityByPincode(
                                              _myPincodeEditController.text)
                                          .then((value) {
                                        setState(() {
                                          CityList city = CityList();
                                          city.id = value.data.id;
                                          city.city = value.data.city;
                                          _selectedCity = city;
                                        });
                                      });
                                    }
                                  }
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
                  width: sm.scaledWidth(50),
                  margin: EdgeInsets.only(bottom: 16.0),
                  child: roundedButton(
                    clicker: () {
                      if (_formKey.currentState.validate()) {
                        var _requestData = CreateJobRequestModel();
                        _requestData.title = _myTitleEditController.text;
                        _requestData.description =
                            _myDescriptionEditController.text;
                        for (var skill in _selectedSkillList) {
                          if (_selectedSkillList.indexOf(skill) == 0) {
                            _requestData.skills = skill.skillName;
                          } else if (_selectedSkillList.indexOf(skill) ==
                              _selectedSkillList.length) {}
                        }
                        _requestData.contact_via = _selectedContactOption;
                        _requestData.contact_value =
                            _myContactEditController.text;
                        _requestData.city = _selectedCity.id.toString();
                        _requestData.pincode = _myPincodeEditController.text;
                        if (_jobId == null) {
                          WebService.funCreateJob(_requestData).then((value) {
                            if (value.status == 'success') {
                              setState(() {
                                BotToast.showText(text: value.message);
                                initializeDefaultValues();
                              });
                            } else {
                              BotToast.showText(text: value.message);
                            }
                          });
                        } else {
                          _requestData.id = _jobId.toString();
                          WebService.funEditJob(_requestData).then((value) {
                            if (value.status == 'success') {
                              setState(() {
                                BotToast.showText(text: value.message);
                              });
                            } else {
                              BotToast.showText(text: value.message);
                            }
                          });
                        }
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
