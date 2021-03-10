import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:favorito_user/model/WorkingHoursModel.dart';
import 'package:favorito_user/model/appModel/AddressListModel.dart';
import 'package:favorito_user/model/appModel/BookingOrAppointment/BookTableVerbose.dart';
import 'package:favorito_user/model/appModel/BookingOrAppointment/BookingOrAppointmentListModel.dart';
import 'package:favorito_user/model/appModel/Business/BaseResponse.dart';
import 'package:favorito_user/model/appModel/Business/NewBusinessModel.dart';
import 'package:favorito_user/model/appModel/Business/businessProfileModel.dart';
import 'package:favorito_user/model/appModel/Carousel/CarouselModel.dart';
import 'package:favorito_user/model/appModel/Catlog/CatlogModel.dart';
import 'package:favorito_user/model/appModel/CheckAccountmodel.dart';
import 'package:favorito_user/model/appModel/Menu/MenuItemBaseModel.dart';
import 'package:favorito_user/model/appModel/Menu/MenuTabModel.dart';
import 'package:favorito_user/model/appModel/Menu/order/ModelOption.dart';
import 'package:favorito_user/model/appModel/PostalCodeModel.dart';
import 'package:favorito_user/model/appModel/ProfileData/ProfileModel.dart';
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
import 'package:favorito_user/model/otp/SendOtpModel.dart';
import 'dart:convert' as convert;

import 'package:favorito_user/services/function.dart';
import 'package:favorito_user/ui/Login.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/Prefs.dart';
import 'package:favorito_user/utils/UtilProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:progress_dialog/progress_dialog.dart';

class APIManager {
  static Response response;
  static Dio dio = Dio();
  service fn = service();

  static UtilProvider utilProvider = UtilProvider();

  static Options opt = Options(contentType: Headers.formUrlEncodedContentType);

//this is used for register new user
  static Future<registerModel> register(
      Map _map, GlobalKey<ScaffoldState> formKey) async {
    if (!await utilProvider.checkInternet())
      return registerModel(
          status: 'fail', message: 'Please check internet connections');
    final ProgressDialog pr = ProgressDialog(formKey.currentContext,
        type: ProgressDialogType.Normal, isDismissible: false)
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
              color: myRed, fontSize: 19.0, fontWeight: FontWeight.w600))
      ..show();

    print("responseData1:${_map.toString()}");
    String url = service.register;
    try {
      response = await dio.post(url, data: _map, options: opt);
    } on DioError catch (e) {
      ExceptionHandler(e, pr, url, formKey);
    } finally {
      pr.hide();
    }
    print("Request URL:${service.register}");
    print("responseData1:${response.toString()}");
    return registerModel.fromJson(convert.json.decode(response.toString()));
  }

  static Future<loginModel> login(
      Map _map, GlobalKey<ScaffoldState> formKey) async {
    if (!await utilProvider.checkInternet())
      return loginModel(
          status: 'fail', message: 'Please check internet connections');
    final ProgressDialog pr = ProgressDialog(formKey.currentContext,
        type: ProgressDialogType.Normal, isDismissible: false)
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
              color: myRed, fontSize: 19.0, fontWeight: FontWeight.w600))
      ..show();

    print("RequestData1:${_map.toString()}");
    print("Login Request Url:${service.login}");
    String url = service.login;
    try {
      response = await dio.post(url, data: _map, options: opt);
      pr.hide();
    } on DioError catch (e) {
      ExceptionHandler(e, pr, url, formKey);
    } finally {
      pr.hide();
    }
    print("Login Request Url:${service.login}");
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
    print("Request URL:${service.businessCarousel}");
    print("responseData1:${response.toString()}");
    return CarouselModel.fromJson(convert.json.decode(response.toString()));
  }

  static Future<AddressListModel> getAddress() async {
    String token = await Prefs.token;
    String url = service.getAddress;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, options: opt);

    print("Request URL:$url.toString()");
    print("responseData1:${response.toString()}");
    return AddressListModel.fromJson(convert.json.decode(response.toString()));
  }

  static Future<ProfileImageModel> getUserImage() async {
    String token = await Prefs.token;
    String url = service.getUserImage;
    opt = Options(
        contentType: Headers.jsonContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, options: opt);

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

  static Future<SearchBusinessListModel> foodBusiness(
      context, String searchString) async {
    String token = await Prefs.token;
    String url = service.foodBusiness;
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

  static Future<SearchBusinessListModel> bookTableBusiness(
      context, String searchString) async {
    String token = await Prefs.token;
    String url = service.bookTableBusiness;
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

  static Future<SearchBusinessListModel> doctorBusiness(
      context, String searchString) async {
    String token = await Prefs.token;
    String url = service.doctorBusiness;
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

  static Future<SearchBusinessListModel> jobBusiness(
      context, String searchString) async {
    String token = await Prefs.token;
    String url = service.jobBusiness;
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

  static Future<SearchBusinessListModel> freelanceBusiness(
      context, String searchString) async {
    String token = await Prefs.token;
    String url = service.freelanceBusiness;
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

  static Future<SearchBusinessListModel> appointmentBusiness(
      context, String searchString) async {
    String token = await Prefs.token;
    String url = service.appointmentBusiness;
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

//userdetail
  static Future<ProfileModel> userdetail(Map _map) async {
    String token = await Prefs.token;
    print('token : ${token.toString()}');
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    response = await dio.post(service.userdetail, data: _map, options: opt);
    print("service.mostPopulerBusiness : ${response.toString}");
    return ProfileModel.fromJson(convert.jsonDecode(response.toString()));
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

  //booking
  static Future<BookingOrAppointmentListModel> baseUserBookingList(
      Map _map, int isBooking) async {
    String token = await Prefs.token;
    String url = isBooking == 0
        ? service.baseUserBookingList
        : service.baseUserAppointmentList;

    print('Resuest data : ${_map.toString()}');
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print("service.baseUserBookingList : $url");

    response = await dio.post(url, data: _map, options: opt);
    print("service.baseUserBookingList : ${response.toString}");
    return BookingOrAppointmentListModel.fromJson(
        convert.jsonDecode(response.toString()));
  }

  //getTableVerboseData
  // static Future<BookTableVerbose> baseUserBookingVerbose(Map _map) async {
  static Future<BookTableVerbose> baseUserBookingVerbose(Map _map) async {
    String token = await Prefs.token;
    String url = service.baseUserBookingVerbose;
    print('Resuest data : ${_map.toString()}');
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print("baseUserBookingVerbose : $url");

    response = await dio.post(url, data: _map, options: opt);
    print("baseUserBookingVerbose response : ${response.toString}");
    return BookTableVerbose.fromJson(convert.jsonDecode(response.toString()));
  }

  //Menu
  static Future<MenuTabModel> menuTabGet(Map _map) async {
    String token = await Prefs.token;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print("service.menuTabGet : ${service.menuTabGet}");
    response = await dio.post(service.menuTabGet, data: _map, options: opt);
    print("service.menuTabGet : ${response.toString}");
    return MenuTabModel.fromJson(convert.jsonDecode(response.toString()));
  }

//Menu item
  static Future<MenuItemBaseModel> menuTabItemGet(Map _map) async {
    String token = await Prefs.token;
    print("menuItemRequest : ${_map.toString()}");
    opt = Options(headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print("service.menuTabItemGet : ${service.menuTabItemGet}");
    response = await dio.post(service.menuTabItemGet, data: _map, options: opt);
    print("service.menuTabItemGet : ${response.toString}");
    return MenuItemBaseModel.fromJson(convert.jsonDecode(response.toString()));
  }

//order
  static Future<BaseResponse> userOrderCreate(Map _map) async {
    String token = await Prefs.token;
    print("menuItemRequest : ${_map.toString()}");
    opt = Options(headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print("service.userOrderCreate : ${service.userOrderCreate}");
    response =
        await dio.post(service.userOrderCreate, data: _map, options: opt);
    print("service.userOrderCreate : ${response.toString}");
    return BaseResponse.fromJson(convert.jsonDecode(response.toString()));
  }

//order verbose
  static Future<ModelOption> userOrderCreateVerbose(Map _map) async {
    String token = await Prefs.token;
    print("menuItemRequest : ${_map.toString()}");
    opt = Options(headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print("service.userOrderCreateVerbose : ${service.userOrderCreateVerbose}");
    response = await dio.post(service.userOrderCreateVerbose,
        data: _map, options: opt);
    print("service.userOrderCreateVerbose : ${response.toString}");
    return ModelOption.fromJson(convert.jsonDecode(response.toString()));
  }

//sendOtp
  static Future<SendOtpModel> sendOtp(
      Map _map, GlobalKey<ScaffoldState> formKey) async {
    if (!await utilProvider.checkInternet())
      return SendOtpModel(
          status: 'fail', message: 'Please check internet connections');
    final ProgressDialog pr = ProgressDialog(formKey.currentContext,
        type: ProgressDialogType.Normal, isDismissible: false)
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
              color: myRed, fontSize: 19.0, fontWeight: FontWeight.w600))
      ..show();
    String url = service.sendOtp;
    print("url : ${service.sendOtp}");

    try {
      response = await dio.post(url, data: _map);
      pr.hide();
    } on DioError catch (e) {
      ExceptionHandler(e, pr, url, formKey);
    } finally {
      pr.hide();
    }
    print("service.userOrderCreateVerbose : ${response.toString}");
    return SendOtpModel.fromJson(convert.jsonDecode(response.toString()));
  }

//verify otp
  static Future<BaseResponse> verifyOtp(
      Map _map, GlobalKey<ScaffoldState> formKey) async {
    if (!await utilProvider.checkInternet())
      return BaseResponse(
          status: 'fail', message: 'Please check internet connections');
    final ProgressDialog pr = ProgressDialog(formKey.currentContext,
        type: ProgressDialogType.Normal, isDismissible: false)
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
              color: myRed, fontSize: 19.0, fontWeight: FontWeight.w600))
      ..show();

    String token = await Prefs.token;
    print("token : $token");
    String url = service.verifyOtp;
    try {
      response = await dio.post(url, data: _map);
      pr.hide();
    } on DioError catch (e) {
      ExceptionHandler(e, pr, url, formKey);
    } finally {
      if (pr.isShowing()) pr.hide();
    }
    print("service.verifyOtp : ${response.toString}");
    return BaseResponse.fromJson(convert.jsonDecode(response.toString()));
  }

//verify otp
  static Future<CheckAccountmodel> checkId(Map _map) async {
    print("url : ${service.verifyOtp}");
    response = await dio.post(service.checkId, data: _map);
    print("service.verifyOtp : ${response.toString}");
    return CheckAccountmodel.fromJson(convert.jsonDecode(response.toString()));
  }

//verify Email/Mobile
  static Future<CheckAccountmodel> checkMobileOrEmail(Map _map) async {
    print("url : ${service.verifyOtp}");
    response = await dio.post(service.checkMobileOrEmail, data: _map);
    print("service.verifyOtp : ${response.toString}");
    return CheckAccountmodel.fromJson(convert.jsonDecode(response.toString()));
  }

  static Future<PostalCodeModel> checkPostalCode(
      Map _map, GlobalKey<ScaffoldState> formKey) async {
    if (!await utilProvider.checkInternet())
      return PostalCodeModel(
          status: 'fail', message: 'Please check internet connections');
    final ProgressDialog pr = ProgressDialog(formKey.currentContext,
        type: ProgressDialogType.Normal, isDismissible: false)
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
              color: myRed, fontSize: 19.0, fontWeight: FontWeight.w600))
      ..show();
    String url = service.checkPostalCode;
    print("url : $url");
    try {
      response = await dio.post(url, data: _map);
      pr.hide();
    } on DioError catch (e) {
      ExceptionHandler(e, pr, url, formKey);
    } finally {
      pr.hide();
    }

    print("service.verifyOtp : ${response.toString}");
    return PostalCodeModel.fromJson(convert.jsonDecode(response.toString()));
  }

  static Future<WorkingHoursModel> workingHours(
      Map _map, GlobalKey<ScaffoldState> formKey) async {
    if (!await utilProvider.checkInternet())
      return WorkingHoursModel(
          status: 'fail', message: 'Please check internet connections');
    final ProgressDialog pr = ProgressDialog(formKey.currentContext,
            type: ProgressDialogType.Normal, isDismissible: false)
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
                  color: Colors.black,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400),
              messageTextStyle: TextStyle(
                  color: myRed, fontSize: 19.0, fontWeight: FontWeight.w600))
        // ..show()
        ;
    String url = service.workingHours;
    print("url : $url");
    try {
      response = await dio.post(url, data: _map, options: opt);
      pr.hide();
    } on DioError catch (e) {
      ExceptionHandler(e, pr, url, formKey);
    } finally {
      pr.hide();
    }

    print("service.verifyOtp : ${response.toString}");
    return WorkingHoursModel.fromJson(convert.jsonDecode(response.toString()));
  }

  static void ExceptionHandler(DioError e, pr, url, formKey) {
    pr.hide();
    if (e.error is SocketException) {
      BotToast.showText(text: "Server not responding");
      response = null;
    } else {
      pr.hide();
      if (e.response.statusCode == 401) {
        BotToast.showText(
            text: BaseResponse.fromJson(
                    convert.json.decode(e.response.toString()))
                .message);
        print("$url:401");
        Navigator.of(formKey.currentContext).pushNamed('/login');
      }

      if (e.response.statusCode == 403) {
        BotToast.showText(
            text: BaseResponse.fromJson(
                    convert.json.decode(e.response.toString()))
                .message);
        print("$url:403");
      }
    }
  }
}
