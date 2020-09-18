import 'package:application/model/BaseResponse/BaseResponseModel.dart';
import 'package:application/model/CatListModel.dart';
import 'package:application/model/job/CreateJobRequiredDataModel.dart';
import 'package:application/model/job/JobListRequestModel.dart';
import 'package:application/model/job/SkillListRequiredDataModel.dart';
import 'package:application/model/notification/CityListModel.dart';
import 'package:application/model/notification/CreateNotificationRequestModel.dart';
import 'package:application/model/notification/CreateNotificationRequiredDataModel.dart';
import 'package:application/model/notification/NotificationListRequestModel.dart';
import 'package:application/model/busyListModel.dart';
import 'package:application/model/registerModel.dart';
import 'package:application/network/serviceFunction.dart';
import 'package:dio/dio.dart';
import 'dart:convert' as convert;

class WebService {
  static Response response;
  static Dio dio = new Dio();
  static Future<busyListModel> funGetBusyList() async {
    busyListModel _data = busyListModel();
    response = await dio.post(serviceFunction.funBusyList, data: null);
    _data = busyListModel.fromJson(convert.json.decode(response.toString()));
    print("responseData3:${_data.status}");
    return _data;
  }

  static Future<CatListModel> funGetCatList(Map _map) async {
    CatListModel _data = CatListModel();
    response = await dio.post(serviceFunction.funCatList, data: _map);
    _data = CatListModel.fromJson(convert.json.decode(response.toString()));
    print("responseData3:${_data.status}");
    return _data;
  }

  static Future<NotificationListRequestModel> funGetNotifications() async {
    NotificationListRequestModel _returnData = NotificationListRequestModel();
    response = await dio.post(serviceFunction.funGetNotifications, data: 1);
    _returnData = NotificationListRequestModel.fromJson(
        convert.json.decode(response.toString()));
    return _returnData;
  }

  static Future<CreateNotificationRequiredDataModel>
      funGetCreateNotificationDefaultData() async {
    CreateNotificationRequiredDataModel _returnData =
        CreateNotificationRequiredDataModel();
    _returnData.actionList = ['Call', 'Direct Chat'];
    _returnData.audienceList = ['Paid', 'Free'];
    _returnData.areaList = ['Country', 'State', 'City', 'Pincode'];
    _returnData.countryList = ['India'];
    _returnData.stateList = ['Uttar Pradesh', 'Madhya Pradesh', 'Maharashtra'];
    _returnData.quantityList = [
      '10000 (Rs 1100)',
      '1000 (Rs 110)',
      '15000 (Rs 1650)'
    ];

    return _returnData;
  }

  static Future<BaseResponseModel> funCreateNotification(
      CreateNotificationRequestModel requestData) async {
    BaseResponseModel _returnData = BaseResponseModel();
    _returnData.status = 1;
    _returnData.message = 'success';

    return _returnData;
  }

  static Future<registerModel> funRegister(Map _map) async {
    registerModel _data = registerModel();
    response = await dio.post(serviceFunction.funBusyRegister,
        data: _map,
        options: Options(contentType: Headers.formUrlEncodedContentType));
    _data = registerModel.fromJson(convert.json.decode(response.toString()));
    print("responseData3:${_data.status}");
    return _data;
  }

  static Future<CityListModel> funGetCities() async {
    CityListModel _returnData = CityListModel();
    _returnData.cityList = ['Noida', 'New Delhi', 'Agra', 'Ghaziabad'];

    return _returnData;
  }

  static Future<BaseResponseModel> funValidPincode(String pincode) async {
    if (pincode == '000000') {
      BaseResponseModel _returnData = BaseResponseModel();
      _returnData.status = 1;
      _returnData.message = 'success';

      return _returnData;
    } else {
      return null;
    }
  }

  static Future<JobListRequestModel> funGetJobs() async {
    JobListRequestModel _returnData = JobListRequestModel();

    JobModel model1 = JobModel();
    model1.title = "Receptionist";
    _returnData.jobs.add(model1);

    JobModel model2 = JobModel();
    model2.title = "Waiter";
    _returnData.jobs.add(model2);

    return _returnData;
  }

  static Future<CreateJobRequiredDataModel> funGetCreteJobDefaultData(
      int jobId) async {
    CreateJobRequiredDataModel _returnData = CreateJobRequiredDataModel();
    _returnData.contactOptionsList = ['Call', 'Email'];
    _returnData.cityList = ['Noida', 'New Delhi', 'Agra', 'Ghaziabad'];

    return _returnData;
  }

  static Future<List<SkillListRequiredDataModel>> funGetSkillList() async {
    List<SkillListRequiredDataModel> _returnData = [];
    SkillListRequiredDataModel model1 = SkillListRequiredDataModel('abc', 1);
    SkillListRequiredDataModel model2 = SkillListRequiredDataModel('abcde', 2);
    SkillListRequiredDataModel model3 = SkillListRequiredDataModel('qwerty', 3);
    SkillListRequiredDataModel model4 = SkillListRequiredDataModel('zxcv', 4);
    _returnData.add(model1);
    _returnData.add(model2);
    _returnData.add(model3);
    _returnData.add(model4);

    return _returnData;
  }

  static Future<List<SkillListRequiredDataModel>> getLanguages(
      String query) async {
    List<SkillListRequiredDataModel> _returnData = [];
    SkillListRequiredDataModel model1 = SkillListRequiredDataModel('abc', 1);
    SkillListRequiredDataModel model2 = SkillListRequiredDataModel('abcde', 2);
    SkillListRequiredDataModel model3 = SkillListRequiredDataModel('qwerty', 3);
    SkillListRequiredDataModel model4 = SkillListRequiredDataModel('zxcv', 4);
    _returnData.add(model1);
    _returnData.add(model2);
    _returnData.add(model3);
    _returnData.add(model4);

    return _returnData
        .where((skill) =>
            skill.skillName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
