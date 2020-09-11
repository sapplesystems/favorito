import 'package:application/model/CatListModel.dart';
import 'package:application/model/busyListModel.dart';
import 'package:application/network/serviceFunction.dart';
import 'package:dio/dio.dart';
import 'dart:convert' as convert;

class WebService {
  static Response response;
  static Dio dio = new Dio();
  static Future<busyListModel> funGetBusyList(Map _map) async {
    busyListModel _data = busyListModel();
    response = await dio.post(serviceFunction.funBusyList, data: _map);
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
}
