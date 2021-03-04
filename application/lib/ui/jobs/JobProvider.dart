import 'package:Favorito/model/BaseResponse/BaseResponseModel.dart';
import 'package:Favorito/model/job/CityList.dart';
import 'package:Favorito/model/job/CityModelResponse.dart';
import 'package:Favorito/model/job/CreateJobRequestModel.dart';
import 'package:Favorito/model/job/JobListRequestModel.dart';
import 'package:Favorito/model/job/PincodeListModel.dart';
import 'package:Favorito/model/job/SkillListRequiredDataModel.dart';
import 'package:Favorito/network/RequestModel.dart';
import 'package:Favorito/network/serviceFunction.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/Regexer.dart';
import 'package:Favorito/utils/UtilProvider.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class JobProvider extends ChangeNotifier {
  JobListRequestModel jobList = JobListRequestModel();
  int jobId;
  bool jobDataCall = false;
  String formTitle = '';
  BuildContext context;
  List<String> contactOptionsList = ['Phone', 'Email'];
  List<CityList> cityList = [];
  List<SkillListRequiredDataModel> selectedSkillList = [];
  List<PincodeModel> pincodesForCity = [];
  List<String> error = [];
  ProgressDialog pr;
  String appBarHeading = '';

  int getSelectedJobId() => jobId;

  final cityKey = GlobalKey<DropdownSearchState<String>>();
  final contactKey = GlobalKey<DropdownSearchState<String>>();
  setSelectedJobId(int value) {
    jobId = value;
    if (value > 0) {
      appBarHeading = "Edit Job";
      getJobDataById();
    } else {
      appBarHeading = "Create Job";
    }
  }

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
  String contactTitle = '';
  RegExp contactRegex;
  String selectedContactOption = '';
  CityList selectedCity = CityList();

  bool autoValidateForm = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();

  JobProvider() {
    for (int _i = 0; _i < 7; _i++) {
      error.add(null);
      controller.add(TextEditingController());
    }
    verbose();
    initializeDefaultValues();
    getPageData();
  }

  getPageData() async {
    await WebService.funGetJobs(context).then((value) {
      jobList = value;
      notifyListeners();
    });
  }

  setContext(BuildContext _context) {
    this.context = _context;
    pr = ProgressDialog(context, type: ProgressDialogType.Normal)
      ..style(
          message: 'Please wait...',
          borderRadius: 8.0,
          backgroundColor: Colors.white,
          progressWidget: CircularProgressIndicator(),
          elevation: 8.0,
          insetAnimCurve: Curves.easeInOut,
          progress: 0.0,
          maxProgress: 100.0,
          progressTextStyle: TextStyle(
              color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
          messageTextStyle: TextStyle(
              color: myRed, fontSize: 19.0, fontWeight: FontWeight.w600));
  }

  void submit() async {
    if (formKey.currentState.validate()) {
      // var _requestData = CreateJobRequestModel();
      String _va = '';
      for (var skill in selectedSkillList) {
        _va = _va + '${_va == '' ? '' : ','}' + skill.skillName;
        // if (selectedSkillList.indexOf(skill) == 0) {
        //   _requestData.skills = skill.skillName;
        //   _va = _va == null ? '' : '$_va ,' + skill.skillName;
        // } else if (selectedSkillList.indexOf(skill) ==
        //     selectedSkillList.length) {}
      }

      Map<String, dynamic> _map = {
        'title': controller[0].text,
        "description": controller[1].text,
        "skills": _va,
        "contact_via": selectedContactOption,
        "contact_value": controller[2].text,
        "postal_code": controller[3].text
      };
      print('_map:${_map.toString()}');
      RequestModel requestModel = RequestModel();
      requestModel.data = _map;
      requestModel.url = serviceFunction.funCreateJob;
      requestModel.context = context;
      if (jobId == 0) {
        await WebService.serviceCall(requestModel).then((value) {
          var _v =
              BaseResponseModel.fromJson(convert.json.decode(value.toString()));
          if (_v.status == 'success') {
            BotToast.showText(text: _v.message);
            allClear();
            getPageData();
            Navigator.of(context).pop();
          }
        });
      } else {
        print("aaaedit");
        Map<String, dynamic> _map = {
          'job_id': jobId,
          'title': controller[0].text,
          "description": controller[1].text,
          "skills": _va,
          "contact_via": selectedContactOption,
          "contact_value": controller[2].text,
          "postal_code": controller[3].text
        };

        print("aaaedit${_map.toString()}");
        RequestModel requestModel = RequestModel();
        requestModel.data = _map;
        requestModel.url = serviceFunction.funEditJob;
        requestModel.context = context;
        if (await Provider.of<UtilProvider>(context, listen: false)
            .checkInternet())
          await WebService.funEditJob(requestModel, context).then((value) {
            if (value.status == 'success') {
              BotToast.showText(text: value.message);
              allClear();
              Navigator.of(context).pop();
            } else {
              BotToast.showText(text: value.message);
            }
          });
      }
    } else
      autoValidateForm = true;
    notifyListeners();
  }

  contactVia(_val) {
    if (_val == contactOptionsList[0]) {
      controller[2].text = '';
      contactHint = 'Enter number for call';
      contactTitle = 'Contact';
      contactRegex = mobileRegex;
    } else {
      controller[2].text = '';
      contactTitle = 'Email';
      contactHint = 'Enter email for chat';
    }
    selectedContactOption = _val;
    notifyListeners();
  }

  void verbose() async {
    await WebService.funGetCreteJobDefaultData(context).then((value) {
      // contactOptionsList.clear();
      cityList.clear();
      // contactOptionsList.addAll(value.data.contactVia);
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

  void getJobDataById() async {
    await WebService.funGetEditJobData(jobId, context).then((value) {
      cityList.clear();
      for (var temp in value.verbose.cityList) {
        CityList city = CityList();
        city.id = temp.id;
        city.city = temp.city;
        cityList.add(city);
      }
      var tempList = value.data[0].skills.split(",");
      selectedSkillList.clear();
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
      contactKey.currentState.changeSelectedItem(value.data[0].contactVia);
      controller[2].text = value.data[0].contactValue;
      controller[3].text = value.data[0].pincode;
      funPincode(value.data[0].pincode);
      notifyListeners();
    });
  }

  funPincode(String val) async {
    if (val.length != 6) return;

    RequestModel requestModel = RequestModel();
    requestModel.isRaw = true;
    requestModel.context = context;
    requestModel.url = serviceFunction.funGetCityByPincode;
    requestModel.data = {"pincode": val};
    if (await Provider.of<UtilProvider>(context, listen: false).checkInternet())
      await WebService.serviceCall(requestModel).then((value) {
        var _v =
            CityModelResponse.fromJson(convert.json.decode(value.toString()));
        print("ffff${_v.data.city}");

        try {
          if (_v.data.city == null) {
            controller[4].text = '';
            error[3] = _v.message;
          } else {
            error[3] = null;
            controller[4].text = _v.data.city.trim();
          }
        } catch (e) {
          print("error:${e.toString()}");
        }
        notifyListeners();
      });
  }

  allClear() {
    for (int i = 0; i < controller.length; i++) {
      controller[i].text = '';
    }
    selectedSkillList.clear();
    selectedContactOption = '';
  }
}
