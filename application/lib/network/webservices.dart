import 'package:application/model/CatListModel.dart';
import 'package:application/model/NotificationListModel.dart';
import 'package:application/model/busyListModel.dart';
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

  static Future<CatListModel> funGetCatList() async {
    CatListModel _data = CatListModel();
    response = await dio.post(serviceFunction.funCatList, data: null);
    _data = CatListModel.fromJson(convert.json.decode(response.toString()));
    print("responseData3:${_data.status}");
    return _data;
  }

  static Future<NotificationListModel> funGetNotifications() async {
    NotificationListModel _data = NotificationListModel();
    // response = await dio.post(serviceFunction.funGetNotifications, data: 1);
    // _data = NotificationListModel.fromJson(
    //     convert.json.decode(response.toString()));
    // print("responseData3:${_data.status}");
    // return _data;
    NotificationModel model1 = NotificationModel();
    model1.title = "Notification 1";
    model1.description = "Description is that it is a description";
    _data.notifications.add(model1);

    NotificationModel model2 = NotificationModel();
    model2.title = "Notification 1";
    model2.description = "Description is that it is a description";
    _data.notifications.add(model2);

    return _data;
  }
}
