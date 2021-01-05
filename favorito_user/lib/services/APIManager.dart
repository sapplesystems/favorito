import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:favorito_user/model/appModel/AddressListModel.dart';
import 'package:favorito_user/model/appModel/Business/NewBusinessModel.dart';
import 'package:favorito_user/model/appModel/Business/businessProfileModel.dart';
import 'package:favorito_user/model/appModel/Carousel/CarouselModel.dart';
import 'package:favorito_user/model/appModel/Catlog/CatlogModel.dart';
import 'package:favorito_user/model/appModel/Relation.dart/relationBase.dart';
import 'package:favorito_user/model/appModel/WaitList/WaitListBaseModel.dart';
import 'package:favorito_user/model/appModel/businessOverViewModel.dart';
import 'package:favorito_user/model/appModel/job/JobListModel.dart';
import 'package:favorito_user/model/appModel/login/loginModel.dart';
import 'package:favorito_user/model/appModel/search/SearchBusinessListModel.dart';
import 'package:favorito_user/model/appModel/ProfileImageModel.dart';
import 'package:favorito_user/model/appModel/registerModel.dart';
import 'package:dio/dio.dart';
import 'package:favorito_user/model/appModel/search/TrendingBusinessModel.dart';
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
    try {
      response = await dio.post(service.login, data: _map, options: opt);
    } catch (e) {
      BotToast.showText(text: e.toString());
    }
    print("Request URL:${service.register}");
    print("responseData1:${response.toString()}");
    return loginModel.fromJson(convert.json.decode(response.toString()));
  }

  static Future<CarouselModel> carousel(context, [map]) async {
    String token = await Prefs.token;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    print("businessCarousel URL:${service.businessCarousel}");
    try {
      response =
          await dio.post(service.businessCarousel, data: map, options: opt);
    } catch (e) {
      BotToast.showText(text: e.toString());
    }
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
    NewBusinessModel data =
        NewBusinessModel.fromJson(convert.json.decode(response.toString()));

    return data;
  }

  //this is used for get small list of hot and new businesses
  static Future<TrendingBusinessModel> trendingBusiness(context) async {
    String token = await Prefs.token;
    print("token:$token");

    String url = service.trendingBusiness;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    print("hotAndNewBusiness Request URL:$url");
    response = await dio
        .post(url, options: opt)
        .catchError((onError) => onErrorCall(onError, context));

    print("hotAndNewBusiness responseData:${response.toString()}");
    return TrendingBusinessModel.fromJson(
        convert.json.decode(response.toString()));
  }

  //this is used for get small list of hot and new businesses
  static Future<TrendingBusinessModel> topRatedBusiness(context) async {
    String token = await Prefs.token;
    print("token:$token");

    String url = service.topRatedBusiness;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    print("topRatedBusiness Request URL:$url");
    response = await dio
        .post(url, options: opt)
        .catchError((onError) => onErrorCall(onError, context));
    print("topRatedBusiness responseData:${response.toString()}");
    return TrendingBusinessModel.fromJson(
        convert.json.decode(response.toString()));
  }

  static Future<TrendingBusinessModel> mostPopulerBusiness() async {
    String token = await Prefs.token;
    print("token:$token");

    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    response = await dio.post(service.mostPopulerBusiness, options: opt);
    print("topRatedBusiness responseData:${response.toString()}");
    return TrendingBusinessModel.fromJson(
        convert.json.decode(response.toString()));
  }

  static Future<businessOverViewModel> baseUserProfileOverview(Map _map) async {
    String token = await Prefs.token;
    print('token : ${token.toString()}');

    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    response = await dio.post(service.baseUserProfileOverview,
        data: _map, options: opt);
    print("service.mostPopulerBusiness : ${response.toString}");
    return businessOverViewModel
        .fromJson(convert.jsonDecode(response.toString()));
  }

  static Future<businessProfileModel> baseUserProfileDetail(Map _map) async {
    String token = await Prefs.token;
    print('token : ${token.toString()}');
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print(
        "service.baseUserProfileDetail url: ${service.baseUserProfileDetail}");
    print("service.baseUserProfileDetail request: ${_map.toString()}");

    response =
        await dio.post(service.baseUserProfileDetail, data: _map, options: opt);
    print("service.mostPopulerBusiness response: ${response.toString}");
    return businessProfileModel
        .fromJson(convert.jsonDecode(response.toString()));
  }

  static Future<CatlogModel> baseUserProfileBusinessCatalogList(
      Map _map) async {
    String token = await Prefs.token;
    print('token : ${token.toString()}');
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print("service.baseUserProfileDetail : ${service.baseUserProfileDetail}");

    response = await dio.post(service.baseUserProfileBusinessCatalogList,
        data: _map, options: opt);
    print("service.mostPopulerBusiness : ${response.toString}");
    return CatlogModel.fromJson(convert.jsonDecode(response.toString()));
  }

  static Future<JobListModel> joblist(Map _map) async {
    String token = await Prefs.token;
    print('token : ${token.toString()}');
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print("service.joblist : ${service.joblist}");

    response = await dio.post(service.joblist, data: _map, options: opt);
    print("service.joblist : ${response.toString}");
    return JobListModel.fromJson(convert.jsonDecode(response.toString()));
  }

  //WaitList
  static Future<WaitListBaseModel> baseUserWaitlistVerbose(Map _map) async {
    String token = await Prefs.token;
    print('token : ${token.toString()}');
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print(
        "service.baseUserWaitlistVerbose : ${service.baseUserWaitlistVerbose}");

    response = await dio.post(service.baseUserWaitlistVerbose,
        data: _map, options: opt);
    print("service.baseUserWaitlistVerbose : ${response.toString}");
    return WaitListBaseModel.fromJson(convert.jsonDecode(response.toString()));
  }

  static Future<WaitListBaseModel> baseUserWaitlistSet(Map _map) async {
    String token = await Prefs.token;
    print('token : ${token.toString()}');
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print("service.baseUserWaitlistSet : ${service.baseUserWaitlistSet}");

    response =
        await dio.post(service.baseUserWaitlistSet, data: _map, options: opt);
    print("service.baseUserWaitlistSet : ${response.toString}");
    return WaitListBaseModel.fromJson(convert.jsonDecode(response.toString()));
  }

  static Future<WaitListBaseModel> baseUserWaitlistGet(Map _map) async {
    String token = await Prefs.token;
    print('token : ${token.toString()}');
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print("service.baseUserWaitlistGet : ${service.baseUserWaitlistGet}");

    response =
        await dio.post(service.baseUserWaitlistGet, data: _map, options: opt);
    print("service.baseUserWaitlistGet : ${response.toString}");
    return WaitListBaseModel.fromJson(convert.jsonDecode(response.toString()));
  }

  static Future<WaitListBaseModel> baseUserWaitlistCancel(Map _map) async {
    String token = await Prefs.token;
    print('token : ${token.toString()}');
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print("service.baseUserWaitlistCancel : ${service.baseUserWaitlistCancel}");

    response = await dio.post(service.baseUserWaitlistCancel,
        data: _map, options: opt);
    print("service.baseUserWaitlistCancel : ${response.toString}");
    return WaitListBaseModel.fromJson(convert.jsonDecode(response.toString()));
  }

  //relation
  static Future<RelationBase> businessRelationGet(Map _map) async {
    String token = await Prefs.token;
    print('_map : ${_map.toString()}');
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print("service.businessRelationGet : ${service.businessRelationGet}");

    response =
        await dio.post(service.businessRelationGet, data: _map, options: opt);
    print("service.businessRelationGet : ${response.toString}");
    return RelationBase.fromJson(convert.jsonDecode(response.toString()));
  }
}
