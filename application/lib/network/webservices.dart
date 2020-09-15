import 'package:application/model/CatListModel.dart';
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

  static Future<CatListModel> funGetCatList() async {
    CatListModel _data = CatListModel();
    response = await dio.post(serviceFunction.funCatList, data: null);
    _data = CatListModel.fromJson(convert.json.decode(response.toString()));
    print("responseData3:${_data.status}");
    return _data;
  }

  static Future<registerModel> funRegister(Map _map) async {
    registerModel _data = registerModel();
    response = await dio.post(serviceFunction.funBusyRegister, data: _map);
    _data = registerModel.fromJson(convert.json.decode(response.toString()));
    print("responseData3:${_data.status}");
    return _data;
  }
}
