import 'package:application/component/roundedButton.dart';
import 'package:application/component/txtfieldboundry.dart';
import 'package:application/model/job/SkillListRequiredDataModel.dart';
import 'package:application/network/webservices.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tagging/flutter_tagging.dart';
import 'package:velocity_x/velocity_x.dart';

class CreateJob extends StatefulWidget {
  final int _jobId;
  CreateJob(this._jobId);

  @override
  _CreateJobState createState() => _CreateJobState(_jobId);
}

class _CreateJobState extends State<CreateJob> {
  int _jobId;
  List<String> _contactOptionsList = [];
  List<String> _cityList = [];
  List<String> _skillList = [];
  List<SkillListRequiredDataModel> _selectedSkillList = [];

  String _contactHint = '';
  String _selectedContactOption = '';
  String _selectedCity = '';

  bool _autoValidateForm = false;

  final _myTitleEditController = TextEditingController();
  final _myDescriptionEditController = TextEditingController();
  final _myContactEditController = TextEditingController();
  final _myPincodeEditController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _CreateJobState(this._jobId);

  @override
  void initState() {
    WebService.funGetCreteJobDefaultData(_jobId).then((value) {
      setState(() {
        _contactOptionsList = value.contactOptionsList;
        _cityList = value.cityList;
      });
    });
    super.initState();
    initializeDefaultValues();
  }

  initializeDefaultValues() {
    _selectedSkillList.clear();
    _contactHint = '';
    _selectedContactOption = '';
    _selectedCity = '';
    _autoValidateForm = false;
    _myTitleEditController.text = '';
    _myDescriptionEditController.text = '';
    _myContactEditController.text = '';
    _myPincodeEditController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                autoValidate: true,
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
                                ctrl: _myContactEditController,
                                title: "Contact",
                                security: false,
                                hint: _contactHint,
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
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: txtfieldboundry(
                                ctrl: _myPincodeEditController,
                                title: "Pincode",
                                security: false,
                                hint: 'Please enter pincode',
                                maxLines: 1,
                                valid: true,
                                maxlen: 6,
                                myOnChanged: (val) {
                                  if (_myPincodeEditController.text.length ==
                                      6) {}
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
                        initializeDefaultValues();
                      } else {
                        initializeDefaultValues();
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
