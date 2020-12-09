import 'dart:io';
import 'package:favorito_user/model/appModel/AddressListModel.dart';
import 'package:favorito_user/model/appModel/Business/NewBusinessModel.dart';
import 'package:favorito_user/model/appModel/Carousel/CarouselModel.dart';
import 'package:favorito_user/model/appModel/login/loginModel.dart';
import 'package:favorito_user/model/appModel/search/SearchBusinessListModel.dart';
import 'package:favorito_user/model/appModel/ProfileImageModel.dart';
import 'package:favorito_user/model/appModel/registerModel.dart';
import 'package:dio/dio.dart';
import 'dart:convert' as convert;

import 'package:favorito_user/services/function.dart';
import 'package:favorito_user/ui/Login.dart';
import 'package:favorito_user/utils/Prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

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

  static Future<CarouselModel> carousel(context) async {
    String token = await Prefs.token;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(service.businessCarousel, options: opt);
    print("Request URL:${service.register}");
    print("responseData1:${response.toString()}");
    return CarouselModel.fromJson(convert.json.decode(response.toString()));
  }

  static Future<AddressListModel> getAddress(context) async {
    String token = await Prefs.token;
    String url = service.getAddress;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio
        .post(url, options: opt)
        .catchError((onError) => onErrorCall(onError, context));

    print("Request URL:$url.toString()");
    print("responseData1:${response.toString()}");
    return AddressListModel.fromJson(convert.json.decode(response.toString()));
  }

  static Future<ProfileImageModel> getUserImage(context) async {
    String token = await Prefs.token;
    String url = service.getUserImage;
    opt = Options(
        contentType: Headers.jsonContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio
        .post(url, options: opt)
        .catchError((onError) => onErrorCall(onError, context));

    return ProfileImageModel.fromJson(convert.json.decode(response.toString()));
  }

  static onErrorCall(onError, context) async {
    if (onError.error == "Http status error [401]") {
      Prefs().clear();
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }

  static Future<SearchBusinessListModel> search(
      context, String searchString) async {
    String token = await Prefs.token;
    String url = service.search;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    Map<String, dynamic> _map = {"keyword": searchString};
    response = await dio
        .post(url, data: _map, options: opt)
        .catchError((onError) => onErrorCall(onError, context));

    print("Request URL:$url.toString()");
    print("responseData1:${response.toString()}");
    return SearchBusinessListModel.fromJson(
        convert.json.decode(response.toString()));
  }

//this is used for get small list of hot and new businesses
  static Future<NewBusinessModel> hotAndNewBusiness(context) async {
    String token = await Prefs.token;
    print("token:$token");

    String url = service.hotAndNewBusiness;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    print("hotAndNewBusiness Request URL:$url");
    response = await dio
        .post(url, options: opt)
        .catchError((onError) => onErrorCall(onError, context));

    print("hotAndNewBusiness responseData:${response.toString()}");
    return NewBusinessModel.fromJson(convert.json.decode(response.toString()));
  }
}
