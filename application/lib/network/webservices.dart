import 'dart:io';
import 'package:Favorito/model/BaseResponse/BaseResponseModel.dart';
import 'package:Favorito/model/CatListModel.dart';
import 'package:Favorito/model/job/CreateJobRequestModel.dart';
import 'package:Favorito/model/job/CreateJobRequiredDataModel.dart';
import 'package:Favorito/model/job/JobListRequestModel.dart';
import 'package:Favorito/model/job/SkillListRequiredDataModel.dart';
import 'package:Favorito/model/dashModel.dart';
import 'package:Favorito/model/loginModel.dart';
import 'package:Favorito/model/notification/CityListModel.dart';
import 'package:Favorito/model/notification/CreateNotificationRequestModel.dart';
import 'package:Favorito/model/notification/CreateNotificationRequiredDataModel.dart';
import 'package:Favorito/model/notification/NotificationListRequestModel.dart';
import 'package:Favorito/model/busyListModel.dart';
import 'package:Favorito/model/offer/CreateOfferRequestModel.dart';
import 'package:Favorito/model/offer/CreateOfferRequiredDataModel.dart';
import 'package:Favorito/model/registerModel.dart';
import 'package:Favorito/network/serviceFunction.dart';
import 'package:Favorito/utils/Prefs.dart';
import 'package:dio/dio.dart';
import 'dart:convert' as convert;

class WebService {
  static Response response;
  static Dio dio = new Dio();
  static Options opt = Options(contentType: Headers.formUrlEncodedContentType);

  static Future<busyListModel> funGetBusyList() async {
    busyListModel _data = busyListModel();
    print("Request URL:${serviceFunction.funBusyList}");
    response = await dio.post(serviceFunction.funBusyList);
    _data = busyListModel.fromJson(convert.json.decode(response.toString()));
    print("responseData1:${_data.status}");
    return _data;
  }

  static Future<CatListModel> funGetCatList(Map _map) async {
    CatListModel _data = CatListModel();
    print("Request URL:${serviceFunction.funCatList}");
    response = await dio.post(serviceFunction.funCatList, data: _map);
    _data = CatListModel.fromJson(convert.json.decode(response.toString()));
    print("responseData2:${_data.status}");
    return _data;
  }

  static Future<dashData> funGetDashBoard() async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    dashModel _data = dashModel();
    print("Request URL:${serviceFunction.funDash}");
    response = await dio.post(serviceFunction.funDash, options: _opt);
    if (response.statusCode == 200) {
      _data = dashModel.fromJson(convert.json.decode(response.toString()));
    } else if (response.statusCode != 200) {
      Prefs().clear();
    }
    print("responseData3:${_data.status}");
    return _data.data;
  }

  static Future<NotificationListRequestModel> funGetNotifications() async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    NotificationListRequestModel _returnData = NotificationListRequestModel();
    response =
        await dio.post(serviceFunction.funGetNotifications, options: _opt);

    print("Request URL:${serviceFunction.funGetNotifications}");
    _returnData = NotificationListRequestModel.fromJson(
        convert.json.decode(response.toString()));
    print("responseData4:${_returnData.status}");
    return _returnData;
  }

  static Future<CreateNotificationRequiredDataModel>
      funGetCreateNotificationDefaultData() async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    CreateNotificationRequiredDataModel _returnData =
        CreateNotificationRequiredDataModel();

    print("Request URL:${serviceFunction.funGetCreateNotificationDefaultData}");
    response = await dio.post(
        serviceFunction.funGetCreateNotificationDefaultData,
        options: _opt);
    _returnData = CreateNotificationRequiredDataModel.fromJson(
        convert.json.decode(response.toString()));
    print("responseData5:${_returnData.status}");
    return _returnData;
  }

  static Future<BaseResponseModel> funCreateNotification(
      CreateNotificationRequestModel requestData) async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    BaseResponseModel _returnData = BaseResponseModel();
    Map<String, dynamic> _map = {
      "title": requestData.title,
      "description": requestData.description,
      "action": requestData.selectedAction,
      "contact": requestData.contact,
      "audience": requestData.selectedAudience,
      "area": requestData.selectedArea,
      "area_detail": requestData.areaDetail,
      "quantity": requestData.selectedQuantity
    };
    response = await dio.post(serviceFunction.funCreateNotification,
        data: _map, options: _opt);
    print("Request URL:${serviceFunction.funCreateNotification}");
    _returnData =
        BaseResponseModel.fromJson(convert.json.decode(response.toString()));
    print("responseData6:${_returnData.status}");
    return _returnData;
  }

  static Future<registerModel> funRegister(Map _map) async {
    registerModel _data = registerModel();
    response = await dio.post(serviceFunction.funBusyRegister,
        data: _map, options: opt);
    _data = registerModel.fromJson(convert.json.decode(response.toString()));
    Prefs.setToken(_data.token.toString().trim());
    print("responseData7:${_data.toString().trim()}");
    print("token:${_data.token.toString().trim()}");
    return _data;
  }

  static Future<loginModel> funGetLogin(Map _map) async {
    loginModel _data = loginModel();
    response =
        await dio.post(serviceFunction.funLogin, data: _map, options: opt);
    _data = loginModel.fromJson(convert.json.decode(response.toString()));
    Prefs.setToken(_data.token.toString().trim());
    return _data.status == "success" ? _data : _data;
  }

  static Future<CityListModel> funGetCities() async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    CityListModel _returnData = CityListModel();
    response = await dio.post(serviceFunction.funGetCities, options: _opt);
    _returnData =
        CityListModel.fromJson(convert.json.decode(response.toString()));
    print("responseData3:${_returnData.status}");
    return _returnData;
  }

  static Future<BaseResponseModel> funValidPincode(String pincode) async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    BaseResponseModel _returnData = BaseResponseModel();
    response = await dio.post(serviceFunction.funValidPincode, options: _opt);
    _returnData =
        BaseResponseModel.fromJson(convert.json.decode(response.toString()));
    print("responseData8:${_returnData.status}");
    return _returnData;
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

  static Future<CreateOfferRequiredDataModel>
      funGetCreateOfferDefaultData() async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    CreateOfferRequiredDataModel _returnData = CreateOfferRequiredDataModel();
    response = await dio.post(serviceFunction.funGetCreateOfferDefaultData,
        options: _opt);
    _returnData = CreateOfferRequiredDataModel.fromJson(
        convert.json.decode(response.toString()));
    print("responseData9:${_returnData.status}");
    return _returnData;
  }

  static Future<BaseResponseModel> funCreateOffer(
      CreateOfferRequestModel requestData) async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    BaseResponseModel _returnData = BaseResponseModel();
    Map<String, dynamic> _map = {
      "offer_title": requestData.title,
      "offer_description": requestData.description,
      "offer_status": requestData.selectedOfferState,
      "offer_type": requestData.selectedOfferType
    };
    response = await dio.post(serviceFunction.funCreateOffer,
        data: _map, options: _opt);
    _returnData =
        BaseResponseModel.fromJson(convert.json.decode(response.toString()));
    print("responseData10:${_returnData.status}");
    return _returnData;
  }

  static Future<BaseResponseModel> funCreateJob(
      CreateJobRequestModel requestData) async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    BaseResponseModel _returnData = BaseResponseModel();
    Map<String, dynamic> _map = {
      "title": requestData.title,
      "description": requestData.description,
      "skills": requestData.skills,
      "contact_via": requestData.contact_via,
      "contact_value": requestData.contact_value,
      "city": requestData.city,
      "pincode": requestData.pincode
    };
    response =
        await dio.post(serviceFunction.funCreateJob, data: _map, options: _opt);
    _returnData =
        BaseResponseModel.fromJson(convert.json.decode(response.toString()));
    print("responseData3:${_returnData.status}");
    return _returnData;
  }
}
