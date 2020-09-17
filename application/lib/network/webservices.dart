import 'package:application/model/BaseResponse/BaseResponseModel.dart';
import 'package:application/model/CatListModel.dart';
import 'package:application/model/job/JobListRequestModel.dart';
import 'package:application/model/notification/CityListModel.dart';
import 'package:application/model/notification/CreateNotificationRequestModel.dart';
import 'package:application/model/notification/CreateNotificationRequiredDataModel.dart';
import 'package:application/model/notification/NotificationListRequestModel.dart';
import 'package:application/model/busyListModel.dart';
import 'package:application/model/registerModel.dart';
import 'package:application/network/serviceFunction.dart';
import 'package:application/utils/Prefs.dart';
import 'package:dio/dio.dart';
import 'dart:convert' as convert;

class WebService {
  static Response response;
  static Dio dio = new Dio();
  static Future<busyListModel> funGetBusyList() async {
    busyListModel _data = busyListModel();
    response = await dio.post(serviceFunction.funBusyList);
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
    // response = await dio.post(serviceFunction.funGetNotifications, data: 1);
    // _data = NotificationListModel.fromJson(
    //     convert.json.decode(response.toString()));
    // print("responseData3:${_data.status}");
    // return _data;
    NotificationModel model1 = NotificationModel();
    model1.title = "Notification 1";
    model1.description =
        "Description is that it is a description, and to test the bigger texts, now for even bigger text to check if the ui breaks";
    _returnData.notifications.add(model1);

    NotificationModel model2 = NotificationModel();
    model2.title = "Notification 1";
    model2.description = "Description is that it is a description";
    _returnData.notifications.add(model2);

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
    Prefs.setToken(_data.token.toString().trim());
    print("responseData3:${_data.toString().trim()}");
    print("token:${_data.token.toString().trim()}");
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
}
