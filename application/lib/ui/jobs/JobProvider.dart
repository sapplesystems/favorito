import 'package:Favorito/model/job/CreateJobRequestModel.dart';
import 'package:Favorito/model/job/CreateJobRequiredDataModel.dart';
import 'package:Favorito/model/job/PincodeListModel.dart';
import 'package:Favorito/model/job/SkillListRequiredDataModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';

class JobProvider extends ChangeNotifier {
  int jobId;
  BuildContext context;
  List<String> contactOptionsList = [];
  List<CityList> cityList = [];
  List<SkillListRequiredDataModel> selectedSkillList = [];
  List<PincodeModel> pincodesForCity = [];
  List<String> title = [
    'City',
    'Pin',
    'Title',
    'Description',
    'Search Skill',
    'Contact Via',
    'Enter value'
  ];
  List<String> hint = [
    'Select city',
    'Enter pincode',
    'Enter job title',
    'Enter title description',
    'Enter skills required for job',
    'Via',
    'Contact number'
  ];
  List<int> maxline = [1, 1, 1, 4, 4, 1, 1];

  List<TextEditingController> controller = [];

  String contactHint = '';
  String selectedContactOption = '';
  CityList selectedCity;

  bool autoValidateForm = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  JobProvider() {
    for (int _i = 0; _i < 7; _i++) controller.add(TextEditingController());
    initializeDefaultValues();
    verbose();
  }
  setContext(BuildContext _context) {
    this.context = _context;
  }

  changeCity(_val) async {
    selectedCity = _val;
    pincodesForCity.clear();
    await WebService.funGetPicodesForCity(selectedCity.id, context)
        .then((value) {
      pincodesForCity = value.pincodeModel;
    });
  }

  void submit() async {
    if (formKey.currentState.validate()) {
      var _requestData = CreateJobRequestModel();
      _requestData.title = controller[0].text;
      _requestData.description = controller[1].text;
      for (var skill in selectedSkillList) {
        if (selectedSkillList.indexOf(skill) == 0) {
          _requestData.skills = skill.skillName;
        } else if (selectedSkillList.indexOf(skill) ==
            selectedSkillList.length) {}
      }
      _requestData.contact_via = selectedContactOption;
      _requestData.contact_value = controller[3].text;
      _requestData.city = selectedCity.id.toString();
      _requestData.pincode = controller[2].text;
      if (jobId == null) {
        await WebService.funCreateJob(_requestData, context).then((value) {
          if (value.status == 'success') {
            BotToast.showText(text: value.message);
            initializeDefaultValues();
          } else {
            BotToast.showText(text: value.message);
          }
        });
      } else {
        _requestData.id = jobId.toString();
        await WebService.funEditJob(_requestData, context).then((value) {
          if (value.status == 'success') {
            BotToast.showText(text: value.message);
          } else {
            BotToast.showText(text: value.message);
          }
        });
      }
    } else
      autoValidateForm = true;
  }

  getCityByPincode() {
    WebService.funGetCityByPincode({'pincode': controller[2].text})
        .then((value) {
      CityList city = CityList();
      city.id = value.data.id;
      city.city = value.data.city;
      selectedCity = city;
    });
  }

  contactVia(_val) {
    if (_val == contactOptionsList[0]) {
      contactHint = 'Enter number for call';
    } else {
      contactHint = 'Enter email for chat';
    }
    selectedContactOption = _val;
    notifyListeners();
  }

  void verbose() async {
    await WebService.funGetCreteJobDefaultData(context).then((value) {
      contactOptionsList.clear();
      cityList.clear();
      contactOptionsList.addAll(value.data.contactVia);
      cityList.addAll(value.data.cityList);
      notifyListeners();
    });
  }

  initializeDefaultValues() {
    if (jobId == null) {
      selectedSkillList.clear();
      contactHint = '';
      selectedContactOption = '';
      selectedCity = null;
      autoValidateForm = false;
      controller[0].text = '';
      controller[1].text = '';
      controller[3].text = '';
      controller[2].text = '';
    }
  }

  void getJobDataById() {
    WebService.funGetEditJobData(jobId, context).then((value) {
      contactOptionsList.clear();
      cityList.clear();
      contactOptionsList = value.verbose.contactVia;
      for (var temp in value.verbose.cityList) {
        CityList city = CityList();
        city.id = temp.id;
        city.city = temp.city;
        cityList.add(city);
      }
      var tempList = value.data[0].skills.split(",");
      for (var temp in tempList) {
        SkillListRequiredDataModel skill =
            SkillListRequiredDataModel(temp, tempList.indexOf(temp));
        selectedSkillList.add(skill);
      }
      selectedContactOption = value.data[0].contactVia;
      for (var city in cityList) {
        if (city.id == value.data[0].id) {
          selectedCity = city;
          break;
        }
      }
      controller[0].text = value.data[0].title;
      controller[1].text = value.data[0].description;
      controller[3].text = value.data[0].contactVia;
      controller[2].text = value.data[0].pincode;
      notifyListeners();
    });
  }
}
