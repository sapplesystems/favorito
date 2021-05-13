import 'dart:convert' as convert;
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:favorito_user/model/CityStateModel.dart';
import 'package:favorito_user/model/Follow/followingModel.dart';
import 'package:favorito_user/model/ProfilePhoto.dart';
import 'package:favorito_user/model/RatingModel.dart';
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
import 'package:favorito_user/model/appModel/Menu/Customization.dart/CustomizationModel.dart';
import 'package:favorito_user/model/appModel/Menu/IsFoodModel.dart';
import 'package:favorito_user/model/appModel/Menu/MenuItemBaseModel.dart';
import 'package:favorito_user/model/appModel/Menu/MenuTabModel.dart';
import 'package:favorito_user/model/appModel/Menu/order/ModelOption.dart';
import 'package:favorito_user/model/appModel/Menu/order/OrderListModel.dart';
import 'package:favorito_user/model/appModel/PostalCodeModel.dart';
import 'package:favorito_user/model/appModel/ProfileData/ProfileModel.dart';
import 'package:favorito_user/model/appModel/ProfileImageModel.dart';
import 'package:favorito_user/model/appModel/Relation.dart/relationBase.dart';
import 'package:favorito_user/model/appModel/Review/MyRatingModel.dart';
import 'package:favorito_user/model/appModel/Review/ReviewListModel.dart';
import 'package:favorito_user/model/appModel/Review/ReviewModel.dart';
import 'package:favorito_user/model/appModel/WaitList/WaitListBaseModel.dart';
import 'package:favorito_user/model/appModel/appointment/AppSerModel.dart';
import 'package:favorito_user/model/appModel/appointment/PersonListModel.dart';
import 'package:favorito_user/model/appModel/appointment/SlotModel.dart';
import 'package:favorito_user/model/appModel/businessOverViewModel.dart';
import 'package:favorito_user/model/appModel/job/JobListModel.dart';
import 'package:favorito_user/model/appModel/login/loginModel.dart';
import 'package:favorito_user/model/appModel/registerModel.dart';
import 'package:favorito_user/model/appModel/search/SearchBusinessListModel.dart';
import 'package:favorito_user/model/appModel/search/TrendingBusinessModel.dart';
import 'package:favorito_user/model/otp/SendOtpModel.dart';
import 'package:favorito_user/services/function.dart';
import 'package:favorito_user/ui/Login/Login.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/Prefs.dart';
import 'package:favorito_user/utils/RIKeys.dart';
import 'package:favorito_user/utils/UtilProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:progress_dialog/progress_dialog.dart';

class APIManager {
  static Response response;
  static Dio dio = Dio();
  service fn = service();

  static UtilProvider utilProvider = UtilProvider();

  static Options opt =
      Options(contentType: Headers.formUrlEncodedContentType, method: 'Post');

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
    print("Request URL:$url");
    print("responseData$url:${response.toString()}");
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

  static Future<CarouselModel> carousel(map) async {
    String token = await Prefs.token;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    print("businessCarousel URL:${service.businessCarousel}");
    try {
      response =
          await dio.post(service.businessCarousel, data: map, options: opt);
    } catch (e) {
      // BotToast.showText(text: e.toString());
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
      String searchString, GlobalKey<ScaffoldState> josKeys) async {
    if (!await utilProvider.checkInternet())
      return SearchBusinessListModel(
          status: 'fail', message: 'Please check internet connections');
    final ProgressDialog pr = ProgressDialog(josKeys.currentContext,
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
    String url = service.search;
    print("url:$url");
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    Map<String, dynamic> _map = {"keyword": searchString};

    try {
      response = await dio.post(url, data: _map, options: opt);
      pr.hide();
    } on DioError catch (e) {
      ExceptionHandler(e, pr, url, josKeys);
    } finally {
      pr.hide();
    }

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
    response = await dio.post(url, data: _map, options: opt);

    print("Request URL:$url");
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
      String searchString, GlobalKey<ScaffoldState> josKeys) async {
    if (!await utilProvider.checkInternet())
      return SearchBusinessListModel(
          status: 'fail', message: 'Please check internet connections');
    final ProgressDialog pr = ProgressDialog(josKeys.currentContext,
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
    String url = service.freelanceBusiness;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    Map<String, dynamic> _map = {"keyword": searchString};
    try {
      response = await dio.post(url, data: _map, options: opt);
      pr.hide();
    } on DioError catch (e) {
      ExceptionHandler(e, pr, url, josKeys);
    } finally {
      pr.hide();
    }
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
    response = await dio.post(url, options: opt);

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
  static Future<ProfileModel> userdetail(
      Map _map, GlobalKey<ScaffoldState> josKeys10) async {
    if (!await utilProvider.checkInternet())
      return ProfileModel(
          status: 'fail', message: 'Please check internet connections');

    String token = await Prefs.token;
    print('token : ${token.toString()}');
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    String url = service.userdetail;
    try {
      response = await dio.post(url, data: _map, options: opt);
    } on DioError catch (e) {
      ExceptionHandler(e, null, url, josKeys10);
    }
    print("service.mostPopulerBusiness : ${response.toString}");
    return ProfileModel.fromJson(convert.jsonDecode(response.toString()));
  }

  static Future<BusinessProfileModel> baseUserProfileDetail(
      Map _map, GlobalKey<ScaffoldState> josKeys2) async {
    if (!await utilProvider.checkInternet())
      return BusinessProfileModel(
          status: 'fail', message: 'Please check internet connections');
    final ProgressDialog pr = ProgressDialog(josKeys2.currentContext,
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
    String token = await Prefs.token;
    print('token : ${token.toString()}');
    String url = service.baseUserProfileDetail;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print(" url: $url");
    print("RequestData: ${_map.toString()}");

    try {
      response = await dio.post(url, data: _map, options: opt);
      // pr.hide();
    } on DioError catch (e) {
      ExceptionHandler(e, pr, url, josKeys2);
    } finally {
      // pr.hide();
    }

    print("service.mostPopulerBusiness response: ${response.toString}");

    return BusinessProfileModel.fromJson(
        convert.jsonDecode(response.toString()));
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
  static Future<WaitListBaseModel> baseUserWaitlistVerbose(
      Map _map, GlobalKey<ScaffoldState> _key) async {
    if (!await utilProvider.checkInternet())
      return WaitListBaseModel(
          status: 'fail', message: 'Please check internet connections');

    String token = await Prefs.token;
    print('token : ${token.toString()}');
    opt = Options(
        // contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print(
        "service.baseUserWaitlistVerbose : ${service.baseUserWaitlistVerbose}");
    String url = service.baseUserWaitlistVerbose;
    try {
      response = await dio.post(url, data: _map, options: opt);

      print("service.baseUserWaitlistVerbose : ${response.toString}");
    } on DioError catch (e) {
      ExceptionHandler(e, null, url, _key);
    }
    print("service.baseUserWaitlistVerbose : ${response.toString}");
    print("aaaaaa" + response.statusMessage.toString());
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
    print("token : $token");
    return WaitListBaseModel.fromJson(convert.jsonDecode(response.toString()));
  }

  static Future<WaitListBaseModel> baseUserWaitlistCancel(
      Map _map, GlobalKey _key) async {
    if (!await utilProvider.checkInternet())
      return WaitListBaseModel(
          status: 'fail', message: 'Please check internet connections');

    String token = await Prefs.token;
    print('token : ${token.toString()}');
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    String url = service.baseUserWaitlistCancel;
    print("$url : $url");
    print("RequestData12 : ${_map.toString()}");

    try {
      response = await dio.post(url, data: _map, options: opt);
      print("service.baseUserWaitlistVerbose : ${response.toString}");
    } on DioError catch (e) {
      ExceptionHandler(e, null, url, _key);
    }

    print("$url : ${response.toString}");
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

    return RelationBase.fromJson(convert.jsonDecode('$response'));
  }

  //booking
  static Future<BookingOrAppointmentListModel> baseUserBookingList(
      bool isBooking, GlobalKey<ScaffoldState> formKey) async {
    if (!await utilProvider.checkInternet())
      return BookingOrAppointmentListModel(
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
    String url = isBooking
        ? service.baseUserBookingList
        : service.baseUserAppointmentList;

    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});

    print("url : $url");
    try {
      response = await dio.post(url, options: opt);
      pr.hide();
    } on DioError catch (e) {
      ExceptionHandler(e, pr, url, formKey);
    } finally {
      pr.hide();
    }
    return BookingOrAppointmentListModel.fromJson(
        convert.jsonDecode(response.toString()));
  }

  // baseUserAppointmentVerboseService
  static Future<AppSerModel> baseUserAppointmentVerboseService(Map _map) async {
    if (!await utilProvider.checkInternet())
      return AppSerModel(
          status: 'fail', message: 'Please check internet connections');
    String token = await Prefs.token;
    String url = service.baseUserAppointmentVerboseService;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print("service.baseUserBookingList : $url");
    try {
      response = await dio.post(url, data: _map, options: opt);
    } on DioError catch (e) {
      BotToast.showText(
          text: 'baseUserAppointmentVerboseService:${e.toString}');
    }
    return AppSerModel.fromJson(convert.jsonDecode(response.toString()));
  }

  // baseUserAppointmentPersonByServiceid
  static Future<PersonListModel> baseUserAppointmentPersonByServiceid(
      Map _map) async {
    if (!await utilProvider.checkInternet())
      return PersonListModel(
          status: 'fail', message: 'Please check internet connections');
    String token = await Prefs.token;
    String url = service.baseUserAppointmentPersonByServiceid;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print("Url: : $url");
    try {
      response = await dio.post(url, data: _map, options: opt);
    } on DioError catch (e) {
      BotToast.showText(
          text: 'baseUserAppointmentPersonByServiceid:${e.toString}');
    }
    return PersonListModel.fromJson(convert.jsonDecode(response.toString()));
  }

  // baseUserAppointmentSlots
  static Future<SlotModel> baseUserAppointmentSlots(Map _map) async {
    if (!await utilProvider.checkInternet())
      return SlotModel(
          status: 'fail', message: 'Please check internet connections');
    String token = await Prefs.token;
    String url = service.baseUserAppointmentSlots;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print("Url: : $url");
    try {
      response = await dio.post(url, data: _map, options: opt);
    } on DioError catch (e) {
      BotToast.showText(text: '$url:${e.toString}');
    }
    return SlotModel.fromJson(convert.jsonDecode(response.toString()));
  }

  // create appointment
  static Future<BaseResponse> baseUserAppointmentCreate(Map _map) async {
    if (!await utilProvider.checkInternet())
      return BaseResponse(
          status: 'fail', message: 'Please check internet connections');
    String token = await Prefs.token;
    String url = service.baseUserAppointmentCreate;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print("Url: : $url");
    try {
      response = await dio.post(url, data: _map, options: opt);
    } on DioError catch (e) {
      BotToast.showText(text: '$url:${e.toString}');
    }
    return BaseResponse.fromJson(convert.jsonDecode(response.toString()));
  }

  //getTableVerboseData --table booking
  static Future<BookTableVerbose> baseUserBookingVerbose(
      Map _map, context) async {
    if (!await utilProvider.checkInternet())
      return BookTableVerbose(
          status: 'fail', message: 'Please check internet connections');
    String token = await Prefs.token;
    String url = service.baseUserBookingVerbose;
    print('Resuest data : ${_map.toString()}');
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print("baseUserBookingVerbose : $url");
    try {
      response = await dio.post(url, data: _map, options: opt);
    } on DioError catch (e) {
      BotToast.showText(
          text:
              BaseResponse.fromJson(convert.json.decode(e.response.toString()))
                  .message);
      Navigator.pop(context);
    }
    print("baseUserBookingVerbose response : ${response.toString}");
    return BookTableVerbose.fromJson(convert.jsonDecode(response.toString()));
  }

  //baseUserBookingCreate
  // static Future<BookTableVerbose> baseUserBookingVerbose(Map _map) async {
  static Future<BaseResponse> baseUserBookingCreate(Map _map) async {
    if (!await utilProvider.checkInternet())
      return BaseResponse(
          status: 'fail', message: 'Please check internet connections');
    String token = await Prefs.token;
    String url = service.baseUserBookingCreate;
    print('Resuest data : ${_map.toString()}');
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print("baseUserBookingCreate : $url");
    try {
      response = await dio.post(url, data: _map, options: opt);
    } on DioError catch (e) {
      BotToast.showText(
          text:
              BaseResponse.fromJson(convert.json.decode(e.response.toString()))
                  .message);
    }
    print("baseUserBookingCreate response : ${response.toString}");
    return BaseResponse.fromJson(convert.jsonDecode(response.toString()));
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

  //set-Review
  static Future<BaseResponse> businessSetReview(Map _map) async {
    String token = await Prefs.token;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    String _url = service.businessSetReview;
    print("$_url : $_url");
    response = await dio.post(_url, data: _map, options: opt);
    return BaseResponse.fromJson(convert.jsonDecode(response.toString()));
  }

  //get-Review-replies
  static Future<ReviewModel> getReviewReplies(Map _map) async {
    String token = await Prefs.token;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    String _url = service.getReviewReplies;
    print("$_url : $_url");
    response = await dio.post(_url, data: _map, options: opt);
    return ReviewModel.fromJson(convert.jsonDecode(response.toString()));
  }

  //get-getReviewListing
  static Future<ReviewListModel> getReviewListing(
      Map _map, BuildContext context) async {
    String token = await Prefs.token;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    String _url = service.getReviewListing;
    print("$_url : $_url");
    response = await dio.post(_url, data: _map, options: opt);
    return ReviewListModel.fromJson(convert.jsonDecode(response.toString()));
  }

  //get-getrating
  static Future<RatingModel> getrating(Map _map) async {
    String token = await Prefs.token;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    String _url = service.getrating;
    print("$_url : $_url");
    response = await dio.post(_url, data: _map, options: opt);
    return RatingModel.fromJson(convert.jsonDecode(response.toString()));
  }

  //setRating
  static Future<BaseResponse> setRating(Map _map) async {
    String token = await Prefs.token;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    String _url = service.setRating;
    print("$_url : $_url");
    response = await dio.post(_url, data: _map, options: opt);
    return BaseResponse.fromJson(convert.jsonDecode(response.toString()));
  }

  //getRating
  static Future<MyRatingModel> getRating(Map _map) async {
    String token = await Prefs.token;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    String _url = service.getRating;
    print("$_url : $_url");
    response = await dio.post(_url, data: _map, options: opt);
    return MyRatingModel.fromJson(convert.jsonDecode(response.toString()));
  }

  //Menu
  static Future<IsFoodModel> menusIsFoodItem(Map _map) async {
    String token = await Prefs.token;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    String url = service.menusIsFoodItem;
    print("$url : $url");
    response = await dio.post(url, data: _map, options: opt);
    print("url : ${response.toString}");
    return IsFoodModel.fromJson(convert.jsonDecode(response.toString()));
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

//Menu item customizetion
  static Future<CustomizationItemModel> menuItemCust(Map _map) async {
    String token = await Prefs.token;
    print("menuItemRequest : ${_map.toString()}");
    opt = Options(headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    String url = service.menuItemCust;
    print("$url : ${service.menuTabItemGet}");
    response = await dio.post(url, data: _map, options: opt);
    print("$url : ${response.toString}");
    return CustomizationItemModel.fromJson(
        convert.jsonDecode(response.toString()));
  }

//order Create
  static Future<BaseResponse> userOrderCreate(Map _map) async {
    String token = await Prefs.token;
    print("menuItemRequest : ${_map.toString()}");
    opt = Options(headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    print("service.userOrderCreate : ${service.userOrderCreate}");
    response =
        await dio.post(service.userOrderCreate, data: _map, options: opt);

    return BaseResponse.fromJson(convert.jsonDecode(response.toString()));
  }

//order verbose
  static Future<ModelOption> userOrderCreateVerbose(Map _map) async {
    String token = await Prefs.token;
    print("menuItemRequest : ${_map.toString()}");
    print("token : $token");
    opt = Options(headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    String url = service.userOrderCreateVerbose;
    print("$url : ${service.userOrderCreateVerbose}");
    response = await dio.post(url, data: _map, options: opt);
    print("$url : ${response.toString}");
    return ModelOption.fromJson(convert.jsonDecode(response.toString()));
  }

//order list
  static Future<OrderListModel> userOrderList() async {
    String token = await Prefs.token;
    print("token : $token");
    opt = Options(headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    String _url = service.userOrderList;
    print("$_url : ${service.userOrderList}");
    response = await dio.post(_url, options: opt);
    print("$_url : ${response.toString}");
    return OrderListModel.fromJson(convert.jsonDecode(response.toString()));
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
  static Future<CheckAccountmodel> checkId(
      Map _map, GlobalKey<ScaffoldState> formKey) async {
    print("url : ${service.verifyOtp}");
    if (!await utilProvider.checkInternet())
      return CheckAccountmodel(
          status: 'fail', message: 'Please check internet connections');

    opt.method = 'post';
    try {
      response = await dio.post(service.checkId, data: _map, options: opt);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        ScaffoldMessenger.of(formKey.currentContext).showSnackBar(SnackBar(
          content:
              Text('Something went wrong :${e?.error?.osError?.errorCode}'),
          duration: const Duration(seconds: 2),
          // action: SnackBarAction(label: 'ACTION', onPressed: () {})
        ));
        return null;
      }
    }
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
                  color: Colors.black,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400),
              messageTextStyle: TextStyle(
                  color: myRed, fontSize: 19.0, fontWeight: FontWeight.w600))
        // ..show()
        ;
    String url = service.checkPostalCode;
    print("url : $url");
    try {
      response = await dio.post(url, data: _map);
      // pr.hide();
    } on DioError catch (e) {
      // pr.hide();
      ExceptionHandler(e, pr, url, formKey);
    } finally {
      // pr.hide();
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

  static Future<WorkingHoursModel> changeAddress(
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
              color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
          messageTextStyle: TextStyle(
              color: myRed, fontSize: 19.0, fontWeight: FontWeight.w600))
      ..show();
    String url = service.changeAddress;
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

  static Future<WorkingHoursModel> deleteAddress(
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
              color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
          messageTextStyle: TextStyle(
              color: myRed, fontSize: 19.0, fontWeight: FontWeight.w600))
      ..show();
    String token = await Prefs.token;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    String url = service.deleteAddress;
    print("url : $url");
    print("requestData : ${_map.toString()}");
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

  static Future<WorkingHoursModel> modifyAddress(
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
              color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
          messageTextStyle: TextStyle(
              color: myRed, fontSize: 19.0, fontWeight: FontWeight.w600))
      ..show();
    String token = await Prefs.token;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    String url = service.modifyAddress;
    print("url : $url");
    print("requestData : ${_map.toString()}");
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

  static Future<ProfilePhoto> profileImageUpdate(
      File file, BuildContext _context) async {
    if (!await utilProvider.checkInternet())
      return ProfilePhoto(
          status: 'fail', message: 'Please check internet connections');
    final ProgressDialog pr = ProgressDialog(_context,
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
    Options _opt =
        Options(contentType: Headers.formUrlEncodedContentType, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap(
        {"photo": await MultipartFile.fromFile(file.path, filename: fileName)});

    try {
      response = await dio.post(service.profileImageUpdate,
          data: formData, options: _opt);
      pr.hide();
    } on DioError catch (e) {
      pr.hide();
      if (e.error is SocketException) {
        BotToast.showText(text: "Server not responding");
        return ProfilePhoto(status: 'fail', message: "Server not responding");
      }
    } finally {
      if (pr.isShowing()) pr.hide();
    }
    // response = await dio.post(serviceFunction.funProfileUpdatephoto,
    //     data: formData, options: _opt);

    return ProfilePhoto.fromJson(convert.json.decode(response.toString()));
  }

  static Future<CityStateModel> stateList(
      Map _map, GlobalKey<ScaffoldState> formKey) async {
    if (!await utilProvider.checkInternet())
      return CityStateModel(
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
    String url = service.stateList;
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
    return CityStateModel.fromJson(convert.jsonDecode(response.toString()));
  }

  static Future<BaseResponse> sendLoginotp(
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
    String url = service.sendLoginotp;
    print("url : $url");
    print("Request data: : ${_map.toString()}");
    try {
      response = await dio.post(url, data: _map, options: opt);
      pr.hide();
    } on DioError catch (e) {
      ExceptionHandler(e, pr, url, formKey);
    } finally {
      pr.hide();
    }
    print("service.verifyOtp : ${response.toString}");
    return BaseResponse.fromJson(convert.jsonDecode(response.toString()));
  }

  static Future<BaseResponse> emailRegister(
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
    String url = service.emailRegister;
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
    return BaseResponse.fromJson(convert.jsonDecode(response.toString()));
  }

  static Future<loginModel> verifyLogin(
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
    String url = service.verifyLogin;
    print("url : $url");
    print("Request Data : ${_map.toString()}");
    try {
      response = await dio.post(url, data: _map, options: opt);
      pr.hide();
    } on DioError catch (e) {
      ExceptionHandler(e, pr, url, formKey);
    } finally {
      pr.hide();
    }
    print("service.verifyOtp : ${response.toString}");
    return loginModel.fromJson(convert.jsonDecode(response.toString()));
  }

  static Future<loginModel> changePassword(
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
    String url = service.changePassword;
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
    return loginModel.fromJson(convert.jsonDecode(response.toString()));
  }

  static Future<FollowingModel> getFollowing(Map _map) async {
    if (!await utilProvider.checkInternet())
      return FollowingModel(
          status: 'fail', message: 'Please check internet connections');
    String _url = service.getFollowing;
    print("url : $_url");
    try {
      response = await dio.post(_url, data: _map, options: opt);
    } on DioError catch (e) {
      ExceptionHandler(e, null, _url, null);
    }
    return FollowingModel.fromJson(convert.jsonDecode(response.toString()));
  }

  static void ExceptionHandler(DioError e, pr, url, formKey) {
    pr?.hide();
    if (e.error is SocketException) {
      BotToast.showText(text: "Server not responding");
      response = null;
    } else {
      if (e.response.statusCode == 401) {
        Navigator.of(formKey.currentContext).pushNamed('/login');
      }

      if (e.response.statusCode == 500) {
        BotToast.showText(
            text: BaseResponse.fromJson(
                    convert.json.decode(e.response.toString()))
                .message);
        print("$url:500");
        // Navigator.of(formKey.currentContext).pushNamed('/login');
      }
      if (e.response.statusCode == 400) {
        BotToast.showText(
            text: BaseResponse.fromJson(
                    convert.json.decode(e.response.toString()))
                .message);
        print("$url:400");
        // Navigator.of(formKey.currentContext).pushNamed('/login');
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

  static Future<void> onWillPop(context) async {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => SystemNavigator.pop(),
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
