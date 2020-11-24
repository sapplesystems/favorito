import 'dart:io';

import 'package:favorito_user/model/serviceModel/Carousel/CarouselData.dart';
import 'package:favorito_user/model/serviceModel/Carousel/CarouselModel.dart';
import 'package:favorito_user/model/serviceModel/login/loginModel.dart';
import 'package:favorito_user/model/serviceModel/registerModel.dart';
import 'package:dio/dio.dart';
import 'dart:convert' as convert;

import 'package:favorito_user/services/function.dart';
import 'package:favorito_user/utils/Prefs.dart';

class APIManager {
  static Response response;
  static Dio dio = new Dio();
  service fn = service();
  static Options opt = Options(contentType: Headers.formUrlEncodedContentType);

//this is used for register new user
  static Future<registerModel> register(Map _map) async {
    print("responseData1:${_map.toString()}");
    response = await dio.post(service.register, data: _map, options: opt);
    print("Request URL:${service.register}");
    print("responseData1:${response.toString()}");
    return registerModel.fromJson(convert.json.decode(response.toString()));
  }

  static Future<loginModel> login(Map _map) async {
    print("responseData1:${_map.toString()}");
    response = await dio.post(service.login, data: _map, options: opt);
    print("Request URL:${service.register}");
    print("responseData1:${response.toString()}");
    return loginModel.fromJson(convert.json.decode(response.toString()));
  }

  static Future<CarouselModel> carousel() async {
    String token = await Prefs.token;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(service.businessCarousel, options: opt);
    print("Request URL:${service.register}");
    print("responseData1:${response.toString()}");
    return CarouselModel.fromJson(convert.json.decode(response.toString()));
  }
}
