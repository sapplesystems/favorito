import 'dart:convert' as convert;

import 'dart:io';

import 'package:Favorito/model/BaseResponse/BaseResponseModel.dart';
import 'package:Favorito/model/CatListModel.dart';
import 'package:Favorito/model/Chat/ChatModel.dart';
import 'package:Favorito/model/Chat/ConnectionListModel.dart';
import 'package:Favorito/model/Chat/UserModel.dart';
import 'package:Favorito/model/Chat/getFBIdModel.dart';
import 'package:Favorito/model/Restriction/BookingRestrictionModel.dart';
import 'package:Favorito/model/StateListModel.dart';
import 'package:Favorito/model/SubCategoryModel.dart';
import 'package:Favorito/model/TagModel.dart';
import 'package:Favorito/model/VerifyOtp.dart';
import 'package:Favorito/model/adSpentModel.dart';
import 'package:Favorito/model/appoinment/RestrictionModel.dart';
import 'package:Favorito/model/appoinment/appoinmentSeviceModel.dart';
import 'package:Favorito/model/appoinment/appointmentModel.dart';
import 'package:Favorito/model/appoinment/appointmentServiceOnlyModel.dart';
import 'package:Favorito/model/appoinment/appointmentSettingModel.dart';
import 'package:Favorito/model/appoinment/personModel.dart';
import 'package:Favorito/model/booking/bookingListModel.dart';
import 'package:Favorito/model/booking/bookingSettingModel.dart';
import 'package:Favorito/model/business/BusinessProfileModel.dart';
import 'package:Favorito/model/business/HoursModel.dart';
import 'package:Favorito/model/businessInfo/businessInfoModel.dart';
import 'package:Favorito/model/businessInfoImage.dart';
import 'package:Favorito/model/busyListModel.dart';
import 'package:Favorito/model/campainVerbose.dart';
import 'package:Favorito/model/catalog/CatalogDetailModel.dart';
import 'package:Favorito/model/catalog/CatlogListModel.dart';
import 'package:Favorito/model/checkMailMobileModel.dart';
import 'package:Favorito/model/checkinsModel.dart';
import 'package:Favorito/model/claimInfo.dart';
import 'package:Favorito/model/contactPerson/ContactPersonRequiredDataModel.dart';
import 'package:Favorito/model/contactPerson/SearchBranchResonseModel.dart';
import 'package:Favorito/model/highLightesData.dart';
import 'package:Favorito/model/job/CityModelResponse.dart';
import 'package:Favorito/model/job/CreateJobRequestModel.dart';
import 'package:Favorito/model/job/CreateJobRequiredDataModel.dart';
import 'package:Favorito/model/job/EditJobDataModel.dart';
import 'package:Favorito/model/job/JobListRequestModel.dart';
import 'package:Favorito/model/job/PincodeListModel.dart';
import 'package:Favorito/model/job/SkillListRequiredDataModel.dart';
import 'package:Favorito/model/menu/MenuBaseModel.dart';
import 'package:Favorito/model/menu/MenuItem/MenuItem.dart';
import 'package:Favorito/model/menu/MenuItem/MenuItemModel.dart';
import 'package:Favorito/model/menu/MenuSettingModel.dart';
import 'package:Favorito/model/menu/MenuVerbose.dart';
import 'package:Favorito/model/notification/CityListModel.dart';
import 'package:Favorito/model/notification/CreateNotificationRequiredDataModel.dart';
import 'package:Favorito/model/notification/NotificationListRequestModel.dart';
import 'package:Favorito/model/notification/NotificationOneModel.dart';
import 'package:Favorito/model/offer/CreateOfferRequestModel.dart';
import 'package:Favorito/model/offer/CreateOfferRequiredDataModel.dart';
import 'package:Favorito/model/offer/OfferListDataModel.dart';
import 'package:Favorito/model/orderListModel.dart';
import 'package:Favorito/model/photoModel.dart';
import 'package:Favorito/model/profile/ProfileImage.dart';
import 'package:Favorito/model/profileDataModel.dart';
import 'package:Favorito/model/RegisterModel.dart';
import 'package:Favorito/model/review/ReviewListModel.dart';
import 'package:Favorito/model/review/ReviewModel.dart';
import 'package:Favorito/model/review/ReviewintroModel.dart';
import 'package:Favorito/model/waitlist/WaitlistListModel.dart';
import 'package:Favorito/model/waitlist/waitListSettingModel.dart';
import 'package:Favorito/model/websiteModel.dart';
import 'package:Favorito/network/RequestModel.dart';
import 'package:Favorito/network/serviceFunction.dart';
import 'package:Favorito/utils/Prefs.dart';
import 'package:Favorito/utils/UtilProvider.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

Response response;

class WebService {
  static Dio dio = new Dio();
  static Options opt = Options();

  static UtilProvider utilProvider = UtilProvider();
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

  static Future serviceCall(RequestModel requestModel) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      BotToast.showText(text: 'Please check internet connection..');
      return;
    }
    String token = await Prefs.token;
    // String token = await Prefs.token + 'abc';
    print("token:$token");
    print("requestData:${requestModel.data}");
    final ProgressDialog pr = ProgressDialog(requestModel.context,
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

    Options opt =
        Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    Options opt1 = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    try {
      response = await dio.post(requestModel.url,
          options: requestModel.isRaw ? opt : opt1, data: requestModel.data);

      pr.hide();
    } on DioError catch (e) {
      pr.hide();
      if (e.error is SocketException) {
        print("Login Error:${e.toString()}");
        BotToast.showText(text: "Server not responding");
        response = null;
      } else {
        pr.hide();
        if (e.response.statusCode == 401) {
          BotToast.showText(
              text: BaseResponseModel.fromJson(
                      convert.json.decode(e.response.toString()))
                  .message);
          print("${requestModel.url}:401");
          Navigator.of(requestModel.context).pushNamed('/login');
        }

        if (e.response.statusCode == 403) {
          BotToast.showText(
              text: BaseResponseModel.fromJson(
                      convert.json.decode(e.response.toString()))
                  .message);
          print("${requestModel.url}:403");
        }
      }
    } finally {
      pr.hide();
    }

    return response ?? '';
  }

  static Future<NotificationListRequestModel> funGetNotifications(
      context) async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    NotificationListRequestModel _returnData = NotificationListRequestModel();
    response =
        await dio.post(serviceFunction.funNotificationsList, options: _opt);

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:${serviceFunction.funNotificationsList}");
      _returnData = NotificationListRequestModel.fromJson(
          convert.json.decode(response.toString()));
    } else {
      print("responseData4:${response.statusCode}");
    }
    return _returnData;
  }

  static Future<photoModel> profileImageUpdate(
      File file, BuildContext _context) async {
    if (!await utilProvider.checkInternet())
      return photoModel(
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
      response = await dio.post(serviceFunction.funProfileUpdatephoto,
          data: formData, options: _opt);
      pr.hide();
    } on DioError catch (e) {
      pr.hide();
      if (e.error is SocketException) {
        BotToast.showText(text: "Server not responding");
        return photoModel(status: 'fail', message: "Server not responding");
      }
    } finally {
      if (pr.isShowing()) pr.hide();
    }
    // response = await dio.post(serviceFunction.funProfileUpdatephoto,
    //     data: formData, options: _opt);

    return photoModel.fromJson(convert.json.decode(response.toString()));
  }

  static Future<profileDataModel> getProfileData() async {
    if (!await utilProvider.checkInternet())
      return profileDataModel(
          status: 'fail', message: 'Please check internet connections');
    String token = await Prefs.token;
    print("token:$token");
    Options _opt =
        Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(serviceFunction.funUserProfile, options: _opt);
    if (response.statusCode == HttpStatus.ok) {
      return profileDataModel
          .fromJson(convert.json.decode(response.toString()));
    }
  }

  //*************************************/notification/*********************************/
  static Future<CreateNotificationRequiredDataModel>
      funGetCreateNotificationDefaultData(BuildContext context) async {
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

  static Future<NotificationOneModel> funNotificationsDetail(
      Map _map, BuildContext context) async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    print("Request URL:${serviceFunction.funGetCreateNotificationDefaultData}");
    response = await dio.post(serviceFunction.funNotificationsDetail,
        data: _map, options: _opt);
    return NotificationOneModel.fromJson(
        convert.json.decode(response.toString()));
  }

  static Future<BaseResponseModel> funCreateNotification(
      RequestModel _requestModel, BuildContext context) async {
    if (!await Provider.of<UtilProvider>(_requestModel.context, listen: false)
        .checkInternet())
      return BaseResponseModel(
          status: 'fail', message: 'Please check internet connections');
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(_requestModel.url,
        data: _requestModel.data, options: _opt);

    print("Request URL:${serviceFunction.funCreateNotification}");

    return BaseResponseModel.fromJson(convert.json.decode(response.toString()));
  }

  static Future<RegisterModel> funRegister(
      Map _map, BuildContext context) async {
    if (!await utilProvider.checkInternet())
      return RegisterModel(
          status: 'fail', message: 'Please check internet connections');
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    final ProgressDialog pr = ProgressDialog(context,
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
    print("Request URL:${serviceFunction.funGetJobs}");
    try {
      response = await dio.post(serviceFunction.funBusyRegister,
          data: _map, options: opt);
      pr.hide();
    } on DioError catch (e) {
      pr.hide();
      if (e.error is SocketException) {
        BotToast.showText(text: "Server not responding");
        return RegisterModel(status: 'fail', message: "Server not responding");
      }
    } finally {
      if (pr.isShowing()) pr.hide();
    }
    return RegisterModel.fromJson(convert.json.decode(response.toString()));
  }

  // static Future<loginModel> funGetLogin(Map _map, BuildContext context) async {
  //   loginModel _data = loginModel();
  //   print('Login Request : ${_data.toString()}');
  //   response =
  //       await dio.post(serviceFunction.funLogin, data: _map, options: opt);
  //   _data = loginModel.fromJson(convert.json.decode(response.toString()));
  //   Prefs.setToken(_data.token.toString().trim());
  //   return _data;
  // }

  static Future<CityListModel> funGetCities() async {
    if (!await utilProvider.checkInternet())
      return CityListModel(
          status: 'fail', message: 'Please check internet connections');
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

  static Future<StateListModel> funGetStates() async {
    if (!await utilProvider.checkInternet())
      return StateListModel(
          status: 'fail', message: 'Please check internet connections');
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    StateListModel _returnData = StateListModel();
    response = await dio.post(serviceFunction.funGetStates, options: _opt);
    _returnData =
        StateListModel.fromJson(convert.json.decode(response.toString()));
    print("responseData3:${_returnData.status}");
    return _returnData;
  }

  static Future<BaseResponseModel> funValidPincode(
      String pincode, BuildContext context) async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    Map<String, dynamic> _map = {"postal_code": int.parse(pincode)};
    response = await dio.post(serviceFunction.funValidPincode,
        data: _map, options: _opt);

    return BaseResponseModel.fromJson(convert.json.decode(response.toString()));
  }

  static Future<JobListRequestModel> funGetJobs(BuildContext context) async {
    if (!await utilProvider.checkInternet())
      return JobListRequestModel(
          status: 'fail', message: 'Please check internet connections');
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    final ProgressDialog pr = ProgressDialog(context,
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
    print("Request URL:${serviceFunction.funGetJobs}");
    try {
      response =
          await dio.post(serviceFunction.funGetJobs, data: null, options: _opt);
      pr.hide();
    } on DioError catch (e) {
      pr.hide();
      if (e.error is SocketException) {
        BotToast.showText(text: "Server not responding");
        return JobListRequestModel(
            status: 'fail', message: "Server not responding");
      }
    } finally {
      if (pr.isShowing()) pr.hide();
    }
    return JobListRequestModel.fromJson(
        convert.json.decode(response.toString()));
  }

  static Future<CreateJobRequiredDataModel> funGetCreteJobDefaultData(
      BuildContext context) async {
    if (!await utilProvider.checkInternet())
      return CreateJobRequiredDataModel(
          status: 'fail', message: 'Please check internet connections');
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    CreateJobRequiredDataModel _returnData = CreateJobRequiredDataModel();

    response = await dio.post(serviceFunction.funGetCreateJobDefaultData,
        data: null, options: _opt);
    _returnData = CreateJobRequiredDataModel.fromJson(
        convert.json.decode(response.toString()));
    return _returnData;
  }

  static Future<List<SkillListRequiredDataModel>> funGetSkillList(
      BuildContext context) async {
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

  static Future<CreateOfferRequiredDataModel> funGetCreateOfferDefaultData(
      BuildContext context) async {
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
      CreateOfferRequestModel requestData, BuildContext context) async {
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
      CreateJobRequestModel requestData, BuildContext context) async {
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
      "postal_code": requestData.pincode
    };
    response =
        await dio.post(serviceFunction.funCreateJob, data: _map, options: _opt);
    _returnData =
        BaseResponseModel.fromJson(convert.json.decode(response.toString()));
    print("responseData3:${_returnData.status}");
    return _returnData;
  }

  static Future<ContactPersonRequiredDataModel> funContactPersonRequiredData(
      BuildContext context) async {
    if (!await utilProvider.checkInternet())
      return ContactPersonRequiredDataModel(
          status: 'fail', message: 'Please check internet connections');
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    ContactPersonRequiredDataModel _returnData =
        ContactPersonRequiredDataModel();
    print("token:${token}");
    response = await dio.post(serviceFunction.funContactPersonRequiredData,
        data: null, options: _opt);
    _returnData = ContactPersonRequiredDataModel.fromJson(
        convert.json.decode(response.toString()));
    print("responseData5:${_returnData.status}");
    return _returnData;
  }

  static Future<BaseResponseModel> funUpdateContactPerson(Map _map) async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    response = await dio.post(serviceFunction.funUpdateContactPerson,
        data: _map, options: _opt);
    // .catchError((onError) => onErrorCall(onError, context))

    return BaseResponseModel.fromJson(convert.json.decode(response.toString()));
    ;
  }

  static Future<CityModelResponse> funGetCityByPincode(Map _map) async {
    if (!await utilProvider.checkInternet())
      return CityModelResponse(
          status: 'fail', message: 'Please check internet connections');
    Options _opt = Options(contentType: Headers.formUrlEncodedContentType);
    response = await dio.post(serviceFunction.funGetCityByPincode,
        data: _map, options: _opt);
    return CityModelResponse.fromJson(convert.json.decode(response.toString()));
  }

  static Future<PincodeListModel> funGetPicodesForCity(
      int cityId, BuildContext context) async {
    String token = await Prefs.token;
    Options _opt =
        Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    Map<String, dynamic> _map = {"city_id": cityId};
    PincodeListModel _returnData = PincodeListModel();
    response = await dio.post(serviceFunction.funGetPincodesForCity,
        data: _map, options: _opt);
    _returnData =
        PincodeListModel.fromJson(convert.json.decode(response.toString()));
    return _returnData;
  }

  //**************************************************Catalog*****************************************************

  static Future<CatlogListModel> funGetCatalogs(BuildContext context) async {
    if (!await utilProvider.checkInternet())
      return CatlogListModel(
          status: 'fail', message: 'Please check internet connections');
    final ProgressDialog pr = ProgressDialog(context,
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
              color: myRed, fontSize: 19.0, fontWeight: FontWeight.w600));
    // ..show();

    String token = await Prefs.token;
    print("token:$token");
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    try {
      response = await dio.post(serviceFunction.funGetCatalogs,
          data: null, options: _opt);
      // pr.hide();
    } on DioError catch (e) {
      // pr.hide();
      if (e.error is SocketException) {
        BotToast.showText(text: "Server not responding");
        return CatlogListModel(
            status: 'fail', message: "Server not responding");
      } else if (e.response.statusCode == 400) {
        BotToast.showText(
            text: BaseResponseModel.fromJson(
                    convert.json.decode(e.response.toString()))
                .message,
            duration: Duration(seconds: 6));
      } else if (e.response.statusCode == 401) {
        BotToast.showText(
            text: BaseResponseModel.fromJson(
                    convert.json.decode(e.response.toString()))
                .message);
        Navigator.of(context).pushNamed('/login');
      }

      if (e.response.statusCode == 403) {
        BotToast.showText(
            text: BaseResponseModel.fromJson(
                    convert.json.decode(e.response.toString()))
                .message);
      }
    }
    // pr.hide();
    print("funGetCatalogs:${response.toString()}");
    return CatlogListModel.fromJson(convert.json.decode(response.toString()));
  }

  //this api is used to upload photo of catalog
  static Future<businessInfoImage> catlogImageUpdate(List files, var id) async {
    String token = await Prefs.token;
    Options _opt =
        Options(contentType: Headers.formUrlEncodedContentType, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });

    List va = [];
    for (var v in files)
      va.add(await MultipartFile.fromFile(v.path,
          filename: v.path.split('/').last));
    Map<String, dynamic> _map = {"photo": va, "catalog_id": id};
    print("_map:${_map.toString()}");
    FormData formData = FormData.fromMap(_map);
    response = await dio.post(serviceFunction.funCatalogAddPhoto,
        data: formData, options: _opt);
    return businessInfoImage.fromJson(convert.json.decode(response.toString()));
  }

  // infoDeletePhote
  static Future<BaseResponseModel> infoDeletePhoto(
      Map _map, BuildContext context) async {
    String token = await Prefs.token;
    Options _opt =
        Options(contentType: Headers.formUrlEncodedContentType, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });
    String url = serviceFunction.infoDeletePhoto;
    print("_map:$url");
    response = await dio.post(url, data: _map, options: _opt);
    return BaseResponseModel.fromJson(convert.json.decode(response.toString()));
  }

  // checkEmailAndMobile
  static Future<checkMailMobileModel> checkEmailAndMobile(Map _map) async {
    if (!await utilProvider.checkInternet())
      return checkMailMobileModel(
          status: 'fail', message: 'Please check internet connections');

    String token = await Prefs.token;
    Options _opt =
        Options(contentType: Headers.formUrlEncodedContentType, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });
    String url = serviceFunction.checkEmailAndMobile;
    print("_map:$url");
    try {
      response = await dio.post(url, data: _map, options: _opt);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        BotToast.showText(text: "Server not responding");
        response = null;
      } else {
        if (e.response.statusCode == 401) {
          return checkMailMobileModel(
              status: 'fail', message: e.response.data['message']);

          //   BotToast.showText(
          //       text: BaseResponseModel.fromJson(
          //               convert.json.decode(e.response.toString()))
          //           .message);
          //   Navigator.of(key.currentContext).pushNamed('/login');
        }
        if (e.response.statusCode == 403) {
          return checkMailMobileModel(
              status: 'fail', message: e.response.data['message']);
        }
      }
    }
    return checkMailMobileModel
        .fromJson(convert.json.decode(response.toString()));
  }

  // funCatalogEdit
  static Future<businessInfoImage> catlogEdit(
      Map _map, BuildContext context) async {
    String token = await Prefs.token;
    Options _opt =
        Options(contentType: Headers.formUrlEncodedContentType, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });
    print("_map:${_map.toString()}");
    response = await dio.post(serviceFunction.funCatalogEdit,
        data: _map, options: _opt);
    print("catlogEdit:${response.toString()}");
    return businessInfoImage.fromJson(convert.json.decode(response.toString()));
  }

  // funCatalogEdit
  static Future<CatalogDetailModel> funCatalogDetail(Map _map) async {
    String token = await Prefs.token;
    print("token:$token");
    Options _opt =
        Options(contentType: Headers.formUrlEncodedContentType, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });
    print("_map:${_map.toString()}");
    response = await dio.post(serviceFunction.funCatalogDetail,
        data: _map, options: _opt);
    print("catlogEdit:${response.toString()}");
    return CatalogDetailModel.fromJson(
        convert.json.decode(response.toString()));
  }

  //********************************************************Waitlist***************************************************

  static Future<waitListSettingModel> funWaitlistSetting(
      BuildContext context) async {
    String token = await Prefs.token;
    print("token:${token}");
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(serviceFunction.funWaitlistSetting,
        data: null, options: opt);
    print("funGetCatalogs:${response.toString()}");
    return waitListSettingModel
        .fromJson(convert.json.decode(response.toString()));
  }

  static Future<BaseResponseModel> funWaitlistUpdateStatus(
      Map _map, BuildContext context) async {
    String token = await Prefs.token;
    opt = Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(serviceFunction.funWaitlistUpdateStatus,
        data: _map, options: opt);
    return BaseResponseModel.fromJson(convert.json.decode(response.toString()));
  }

  //this is used for delete waitlist
  static Future<BaseResponseModel> funWaitlistDelete(
      Map _map, BuildContext context) async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    BaseResponseModel _returnData = BaseResponseModel();

    response = await dio.post(serviceFunction.funWaitlistDelete,
        data: _map, options: _opt);
    _returnData =
        BaseResponseModel.fromJson(convert.json.decode(response.toString()));
    return _returnData;
  }

  //used to save waitlist setting
  static Future<BaseResponseModel> funWaitlistSaveSetting(
      Map _map, BuildContext context) async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    BaseResponseModel _returnData = BaseResponseModel();

    response = await dio.post(serviceFunction.funWaitlistSaveSetting,
        data: _map, options: _opt);
    _returnData =
        BaseResponseModel.fromJson(convert.json.decode(response.toString()));
    return _returnData;
  }

  static Future<WaitlistListModel> funGetWaitlist(BuildContext context) async {
    if (!await utilProvider.checkInternet())
      return WaitlistListModel(
          status: 'fail', message: 'Please check internet connections');

    final ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true)
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
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    try {
      response = await dio.post(serviceFunction.funGetWaitlist, options: _opt);
      pr.hide();
    } on DioError catch (e) {
      pr.hide();
      if (e.error is SocketException) {
        BotToast.showText(text: "Server not responding");
        return WaitlistListModel(
            status: 'fail', message: "Server not responding");
      } else if (e.response.statusCode == 400) {
        BotToast.showText(
            text: BaseResponseModel.fromJson(
                    convert.json.decode(e.response.toString()))
                .message,
            duration: Duration(seconds: 6));
      } else if (e.response.statusCode == 401) {
        BotToast.showText(
            text: BaseResponseModel.fromJson(
                    convert.json.decode(e.response.toString()))
                .message);
        Navigator.of(context).pushNamed('/login');
      }

      if (e.response.statusCode == 403) {
        BotToast.showText(
            text: BaseResponseModel.fromJson(
                    convert.json.decode(e.response.toString()))
                .message);
      }
    }

    return WaitlistListModel.fromJson(convert.json.decode(response.toString()));
  }

  static Future<WaitlistListModel> funCreateWaitlist(
      Map _map, BuildContext context) async {
    if (!await utilProvider.checkInternet())
      return WaitlistListModel(
          status: 'fail', message: 'Please check internet connections');

    final ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true)
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
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    try {
      response = await dio.post(serviceFunction.funCreateWaitlist,
          data: _map, options: _opt);
    } on DioError catch (e) {
      pr.hide();
      if (e.error is SocketException) {
        BotToast.showText(text: "Server not responding");
        return WaitlistListModel(
            status: 'fail', message: "Server not responding");
      } else if (e.response.statusCode == 400) {
        BotToast.showText(
            text: BaseResponseModel.fromJson(
                    convert.json.decode(e.response.toString()))
                .message,
            duration: Duration(seconds: 6));
      } else if (e.response.statusCode == 401) {
        BotToast.showText(
            text: BaseResponseModel.fromJson(
                    convert.json.decode(e.response.toString()))
                .message);
        Navigator.of(context).pushNamed('/login');
      }

      if (e.response.statusCode == 403) {
        BotToast.showText(
            text: BaseResponseModel.fromJson(
                    convert.json.decode(e.response.toString()))
                .message);
      }
    }
    return WaitlistListModel.fromJson(convert.json.decode(response.toString()));
  }

  //********************************Booking***************************/
  static Future<BaseResponseModel> funCreateManualBooking(
      Map _map, BuildContext context) async {
    String token = await Prefs.token;
    opt = Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(serviceFunction.funManualBooking,
        data: _map, options: opt);
    return BaseResponseModel.fromJson(convert.json.decode(response.toString()));
  }

  static Future<BaseResponseModel> funBookingEdit(Map _map) async {
    String token = await Prefs.token;
    print("Edit Data:${_map.toString()}");
    opt = Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(serviceFunction.funBookingEdit,
        data: _map, options: opt);
    return BaseResponseModel.fromJson(convert.json.decode(response.toString()));
  }

  static Future<BaseResponseModel> funBookingSaveSetting(
      Map _map, BuildContext context) async {
    String token = await Prefs.token;
    opt = Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(serviceFunction.funBookingSaveSetting,
        data: _map, options: opt);
    return BaseResponseModel.fromJson(convert.json.decode(response.toString()));
  }

  static Future<bookingSettingModel> funBookingSetting() async {
    String token = await Prefs.token;
    opt = Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(serviceFunction.funBookingSetting, options: opt);
    return bookingSettingModel
        .fromJson(convert.json.decode(response.toString()));
  }

//  setRestrinction deleteRestrinction
  static Future<BaseResponseModel> restrinction(_map, isDelete) async {
    String token = await Prefs.token;
     Options _opt = Options(
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
        

    String _url = isDelete
        ? serviceFunction.deleteRestrinction
        : serviceFunction.setRestrinction;
        print("DeleteUrl:$_url");
        print("DeleteUrl:${_map.toString()}");
    response = await dio.post(_url, data: _map, options: _opt);
    return BaseResponseModel.fromJson(convert.json.decode(response.toString()));
  }

//  getRestrinction
  static Future<BookingRestrictionModel> getRestrinction() async {
    String token = await Prefs.token;
    opt = Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    String _url = serviceFunction.getRestrinction;
    response = await dio.post(_url, options: opt);
    return BookingRestrictionModel.fromJson(
        convert.json.decode(response.toString()));
  }

  static Future<bookingListModel> funBookingList(Map _map) async {
    String token = await Prefs.token;
    opt = Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(serviceFunction.funBookingList,
        options: opt, data: _map);
    return bookingListModel.fromJson(convert.json.decode(response.toString()));
  }

  static Future<SearchBranchResponseModel> funSearchBranches(
      String searchText, BuildContext context) async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    Map<String, dynamic> _map = {"search_branch": searchText};
    SearchBranchResponseModel _returnData = SearchBranchResponseModel();
    response = await dio.post(serviceFunction.funSearchBranches,
        data: _map, options: _opt);
    _returnData = SearchBranchResponseModel.fromJson(
        convert.json.decode(response.toString()));
    return _returnData;
  }

  //this api is used to upload photo of catalog
  static Future<businessInfoImage> funCatalogAddPhoto(
      List files, var id) async {
    String token = await Prefs.token;
    Options _opt =
        Options(contentType: Headers.formUrlEncodedContentType, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });

    List va = [];
    for (var v in files)
      va.add(await MultipartFile.fromFile(v.path,
          filename: v.path.split('/').last));
    Map<String, dynamic> _map = {"photo": va, "catalog_id": id};
    print("_map:${_map.toString()}");
    FormData formData = FormData.fromMap(_map);
    response = await dio.post(serviceFunction.funCatalogAddPhoto,
        data: formData, options: _opt);
    return businessInfoImage.fromJson(convert.json.decode(response.toString()));
  }

  // infoDeletePhote
  static Future<BaseResponseModel> funCatalogDeletePhoto(Map _map) async {
    String token = await Prefs.token;
    Options _opt =
        Options(contentType: Headers.formUrlEncodedContentType, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });
    String url = serviceFunction.funCatalogDeletePhoto;
    print("_map:$url");
    response = await dio.post(url, data: _map, options: _opt);
    return BaseResponseModel.fromJson(convert.json.decode(response.toString()));
  }

  static Future<BusinessProfileModel> funGetBusinessProfileData() async {
    if (!await utilProvider.checkInternet())
      return BusinessProfileModel(
          status: 'fail', message: 'Please check internet connections');
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    BusinessProfileModel _returnData = BusinessProfileModel();
    print(
        "BusinessProfile request url: ${serviceFunction.funGetBusinessProfileData}");
    print("token: $token");
    response = await dio.post(serviceFunction.funGetBusinessProfileData,
        data: null, options: _opt);
    _returnData =
        BusinessProfileModel.fromJson(convert.json.decode(response.toString()));
    return _returnData;
  }

  static Future<HoursModel> funGetBusinessWorkingHours() async {
    String token = await Prefs.token;
    String url = serviceFunction.funGetBusinessWorkingHours;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    print("BusinessProfile request url: $url");
    print("token: $token");
    response = await dio.post(url, data: null, options: _opt);
    return HoursModel.fromJson(convert.json.decode(response.toString()));
  }

  static Future<HoursModel> funSetBusinessWorkingHours(_map) async {
    String token = await Prefs.token;
    String url = serviceFunction.funSetBusinessWorkingHours;
    Options _opt =
        Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    print("BusinessProfile request url: $url");
    print("token: $token");
    response = await dio.post(url, data: _map, options: _opt);
    return HoursModel.fromJson(convert.json.decode(response.toString()));
  }

  static Future<OfferListDataModel> funGetOfferData(
      BuildContext context) async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    OfferListDataModel _returnData = OfferListDataModel();
    response = await dio.post(serviceFunction.funGetOfferData,
        data: null, options: _opt);
    _returnData =
        OfferListDataModel.fromJson(convert.json.decode(response.toString()));
    return _returnData;
  }

  static Future<BaseResponseModel> funEditOffer(
      var requestData, BuildContext context) async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    BaseResponseModel _returnData = BaseResponseModel();
    Map<String, dynamic> _map = {
      "offer_id": requestData.id,
      "offer_title": requestData.title,
      "offer_description": requestData.description,
      "offer_status": requestData.selectedOfferState,
      "offer_type": requestData.selectedOfferType
    };
    response =
        await dio.post(serviceFunction.funEditOffer, data: _map, options: _opt);
    _returnData =
        BaseResponseModel.fromJson(convert.json.decode(response.toString()));
    print("responseData10:${_returnData.status}");
    return _returnData;
  }

  static Future<EditJobDataModel> funGetEditJobData(
      var _jobId, BuildContext context) async {
    if (!await utilProvider.checkInternet())
      return EditJobDataModel(
          status: 'fail', message: 'Please check internet connections');

    final ProgressDialog pr = ProgressDialog(context,
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
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    Map<String, dynamic> _map = {"job_id": _jobId};
    try {
      response = await dio.post(serviceFunction.funGetEditJobData,
          data: _map, options: _opt);
      pr.hide();
    } on DioError catch (e) {
      pr.hide();
      if (e.error is SocketException) {
        BotToast.showText(text: "Server not responding");
        return EditJobDataModel(
            status: 'fail', message: "Server not responding");
      }
    } finally {
      if (pr.isShowing()) pr.hide();
    }

    return EditJobDataModel.fromJson(convert.json.decode(response.toString()));
  }

  static Future<BaseResponseModel> funEditJob(
      RequestModel requestModel, BuildContext context) async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    BaseResponseModel _returnData = BaseResponseModel();

    response = await dio.post(requestModel.url,
        data: requestModel.data, options: _opt);
    _returnData =
        BaseResponseModel.fromJson(convert.json.decode(response.toString()));
    print("responseData3:${_returnData.status}");
    return _returnData;
  }

  //this service is used for business profile
  static Future<BaseResponseModel> funUserProfileUpdate(Map _map) async {
    if (!await utilProvider.checkInternet())
      return BaseResponseModel(
          status: 'fail', message: 'Please check internet connections');
    String token = await Prefs.token;
    Options _opt = Options(contentType: Headers.jsonContentType, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    BaseResponseModel _returnData = BaseResponseModel();
    print("Request URL:${serviceFunction.funUserProfileUpdate}");
    print("RequestData URL:${_map.toString()}");
    response = await dio.post(serviceFunction.funUserProfileUpdate,
        data: _map, options: _opt);
    // .catchError((onError) => onErrorCall(onError));
    _returnData =
        BaseResponseModel.fromJson(convert.json.decode(response.toString()));
    print("responseData1:${_returnData.status}");
    return _returnData;
  }

  //*********************************************** Business information data  **********************/
  static Future<BusinessInfoModel> getBusinessInfoData(
      BuildContext context) async {
    String token = await Prefs.token;
    String url = serviceFunction.funUserInformation;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, options: opt);
    if (response.statusCode == HttpStatus.ok) print("Request URL:$url");
    print("Response is :${response.toString()}");
    return BusinessInfoModel.fromJson(convert.json.decode(response.toString()));
  }

  static Future<businessInfoImage> profileInfoImageUpdate(
      List files, BuildContext context) async {
    String token = await Prefs.token;
    Options _opt =
        Options(contentType: Headers.formUrlEncodedContentType, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });

    List va = [];
    for (var v in files)
      va.add(await MultipartFile.fromFile(v.path,
          filename: v.path.split('/').last));
    Map<String, dynamic> _map = {"photo": va};
    FormData formData = FormData.fromMap(_map);
    response = await dio.post(serviceFunction.funUserInformationAddPhoto,
        data: formData, options: _opt);
    return businessInfoImage.fromJson(convert.json.decode(response.toString()));
  }

  static Future<BaseResponseModel> setBusinessInfoData(
      Map<String, dynamic> _map, BuildContext context) async {
    BaseResponseModel _returnData = BaseResponseModel();
    String token = await Prefs.token;
    String url = serviceFunction.funUserInformationUpdate;
    Options op = Options();
    op = Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    op.headers["content-type"] = "multipart/form-data";
    FormData formData = FormData.fromMap(_map);
    response = await dio.post(url, data: formData, options: op);
    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("RequestData URL:${_map.toString()}");
      print("Response is :${response.toString()}");
      _returnData =
          BaseResponseModel.fromJson(convert.json.decode(response.toString()));
    } else {
      print("responseData4:${response.statusCode}");
    }
    return _returnData;
  }

  static Future<SubCategoryModel> getSubCat(
      Map _map, BuildContext context) async {
    String token = await Prefs.token;
    String url = serviceFunction.funSubCatList;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    SubCategoryModel _returnData = SubCategoryModel();
    response =
        await dio.post(serviceFunction.funSubCatList, data: _map, options: opt);

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      _returnData =
          SubCategoryModel.fromJson(convert.json.decode(response.toString()));
    } else {
      print("responseData4:${response.statusCode}");
    }
    return _returnData;
  }

  //*********************************************** Highlight ******************************/
  static Future<businessInfoImage> highlightImageUpdate(
      List files, BuildContext context) async {
    String token = await Prefs.token;
    Options _opt =
        Options(contentType: Headers.formUrlEncodedContentType, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });

    List va = [];
    for (var v in files)
      va.add(await MultipartFile.fromFile(v.path,
          filename: v.path.split('/').last));
    Map<String, dynamic> _map = {
      "photo": va,
    };
    print("_map:${_map.toString()}");
    FormData formData = FormData.fromMap(_map);
    response = await dio.post(serviceFunction.funUserHighlightAddPhoto,
        data: formData, options: _opt);
    return businessInfoImage.fromJson(convert.json.decode(response.toString()));
  }

  static Future<BaseResponseModel> setHighlightData(
      Map _map, BuildContext context) async {
    String token = await Prefs.token;
    String url = serviceFunction.funSubCatList;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(serviceFunction.funUserHighlightSave,
        data: _map, options: opt);

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return BaseResponseModel.fromJson(
          convert.json.decode(response.toString()));
    }
  }

  static Future<highLightesData> getHighlightData(BuildContext context) async {
    String token = await Prefs.token;
    String url = serviceFunction.funUserHighlightDetails;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, options: opt);

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return highLightesData.fromJson(convert.json.decode(response.toString()));
    }
  }

  //*********************************************** adSpent ******************************/
  static Future<AdSpentModels> getAdSpentPageData() async {
    String token = await Prefs.token;
    String url = serviceFunction.funAdSpentList;
    opt = Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, options: opt);

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return AdSpentModels.fromJson(convert.json.decode(response.toString()));
    }
  }

  static Future<TagModel> getTagList(BuildContext context) async {
    String token = await Prefs.token;
    String url = serviceFunction.funTagList;
    opt = Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, options: opt);

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return TagModel.fromJson(convert.json.decode(response.toString()));
    }
  }

  static Future<campainVerbose> getCampainVerbose(BuildContext context) async {
    String token = await Prefs.token;
    String url = serviceFunction.funCampainVerbose;
    opt = Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, options: opt);
    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return campainVerbose.fromJson(convert.json.decode(response.toString()));
    }
  }

  static Future<campainVerbose> createCampain(
      Map _map, bool edit, BuildContext context) async {
    String token = await Prefs.token;
    String url = edit
        ? serviceFunction.funCreateCampainEdit
        : serviceFunction.funCreateCampain;
    opt = Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, data: _map, options: opt);
    ;
    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return campainVerbose.fromJson(convert.json.decode(response.toString()));
    }
  }

  static Future<OrderListModel> orderList(
      Map _map, BuildContext context) async {
    String token = await Prefs.token;
    String url = serviceFunction.funOrderList;
    opt = Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, data: _map, options: opt);

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return OrderListModel.fromJson(convert.json.decode(response.toString()));
    }
  }

  //***********************************************appointment*****************************/

  static Future<appointmentSettingModel> funAppoinmentSetting() async {
    String token = await Prefs.token;
    String url = serviceFunction.funAppoinmentSetting;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, options: opt);

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return appointmentSettingModel
          .fromJson(convert.json.decode(response.toString()));
    }
  }

  static Future<RestrictionModel> funAppoinmentRestriction() async {
    String token = await Prefs.token;
    String url = serviceFunction.funAppoinmentRestriction;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, options: opt);

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return RestrictionModel.fromJson(
          convert.json.decode(response.toString()));
    }
  }

  static Future<BaseResponseModel> funAppoinmentSaveRestriction(
      Map _map, bool isNew, BuildContext context) async {
    String token = await Prefs.token;
    String url = isNew
        ? serviceFunction.funAppoinmentSaveRestriction
        : serviceFunction.funAppoinmentEditRestriction;
    opt = Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, data: _map, options: opt);

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return BaseResponseModel.fromJson(
          convert.json.decode(response.toString()));
    }
    return BaseResponseModel.fromJson(convert.json.decode(response.toString()));
  }

  static Future<BaseResponseModel> funAppoinmentServicePersonOnOff(
      //true for services false for person
      Map _map,
      bool isService) async {
    String token = await Prefs.token;
    String url = isService
        ? serviceFunction.funAppoinmentServiceOnOff
        : serviceFunction.funAppoinmentPersonOnOff;
   var  _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, data: _map, options: _opt);

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return BaseResponseModel.fromJson(
          convert.json.decode(response.toString()));
    }
  }

  static Future<BaseResponseModel> funAppoinmentSaveService(Map _map) async {
    String token = await Prefs.token;
    String url = serviceFunction.funAppoinmentSaveService;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, data: _map, options: opt);

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return BaseResponseModel.fromJson(
          convert.json.decode(response.toString()));
    }
  }

  //to save person
  static Future<BaseResponseModel> funAppoinmentSavePerson(
      Map _map, BuildContext context) async {
    String token = await Prefs.token;
    String url = serviceFunction.funAppoinmentSavePerson;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, data: _map, options: opt);

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return BaseResponseModel.fromJson(
          convert.json.decode(response.toString()));
    }
  }

  //to save person
  static Future<BaseResponseModel> funAppoinmentDeleteRestriction(
      Map _map, BuildContext context) async {
    String token = await Prefs.token;
    String url = serviceFunction.funAppoinmentDeleteRestriction;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, data: _map, options: opt);

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return BaseResponseModel.fromJson(
          convert.json.decode(response.toString()));
    }
  }

  //to get person
  static Future<PersonModel> funAppoinmentPerson() async {
    String token = await Prefs.token;
    String url = serviceFunction.funAppoinmentPerson;
    opt = Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, options: opt);

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return PersonModel.fromJson(convert.json.decode(response.toString()));
    }
  }

  //to get all services
  static Future<appointmentServiceOnlyModel> funAppoinmentService() async {
    String token = await Prefs.token;
    String url = serviceFunction.funAppoinmentService;
    opt = Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, options: opt);

    try {
      if (response.statusCode == HttpStatus.ok) {
        print("Request URL:$url");
        print("Response is :${response.toString()}");
        return appointmentServiceOnlyModel
            .fromJson(convert.json.decode(response.toString()));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<BaseResponseModel> funAppoinmentSaveSetting(Map _map) async {
    String token = await Prefs.token;
    String url = serviceFunction.funAppoinmentSaveSetting;
    opt = Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, data: _map, options: opt);

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return BaseResponseModel.fromJson(
          convert.json.decode(response.toString()));
    }
  }

  static Future<BaseResponseModel> funAppoinmentCreate(Map _map, isnew) async {
    String token = await Prefs.token;
    String url = isnew
        ? serviceFunction.funAppoinmentCreate
        : serviceFunction.funAppoinmentEdit;
    opt = Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, data: _map, options: opt);

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return BaseResponseModel.fromJson(
          convert.json.decode(response.toString()));
    }
  }

  static Future<appointmentModel> funAppoinmentDetail(Map _map) async {
    String token = await Prefs.token;
    String url = serviceFunction.funAppoinmentDetail;
    opt = Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, data: _map, options: opt);

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return appointmentModel
          .fromJson(convert.json.decode(response.toString()));
    }
  }

  static Future<appoinmentSeviceModel> funAppoinmentVerbose(
      BuildContext context) async {
    String token = await Prefs.token;
    String url = serviceFunction.funAppoinmentVerbose;
    opt = Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, options: opt);

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return appoinmentSeviceModel
          .fromJson(convert.json.decode(response.toString()));
    }
  }

  static Future<bookingListModel> funAppoinmentList(Map _map) async {
    String token = await Prefs.token;
    print("tiken:${token}");
    String url = serviceFunction.funAppoinmentList;
    opt = Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, data: _map, options: opt);

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return bookingListModel
          .fromJson(convert.json.decode(response.toString()));
    }
  }

  //*************************************/Checkins/*********************************/
  //this is used to get checkinslist
  static Future<checkinsModel> funCheckinslist(BuildContext context) async {
    String token = await Prefs.token;
    print("tiken:${token}");
    String url = serviceFunction.funCheckinslist;
    opt = Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, options: opt);

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return checkinsModel.fromJson(convert.json.decode(response.toString()));
    }
  }

  //*************************************/Claims/*********************************/

  static Future<ClaimInfo> funClaimInfo(BuildContext context) async {
    String token = await Prefs.token;
    String url = serviceFunction.funClaimInfo;
    opt = Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    print("Request URL:$url");
    response = await dio.post(url, options: opt);
    // .catchError((onError) => onErrorCall(onError, context));

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return ClaimInfo.fromJson(convert.json.decode(response.toString()));
    }
  }

  static Future<BaseResponseModel> funSendOtpSms(Map _map) async {
    String token = await Prefs.token;
    print("tiken:${token}");
    String url = serviceFunction.funSendOtpSms;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    print("mobile is :${_map.toString()}");
    response = await dio.post(url, data: _map, options: opt);
    // .catchError((onError) => onErrorCall(onError, context));

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return BaseResponseModel.fromJson(
          convert.json.decode(response.toString()));
    }
  }

  static Future<verifyOtpModel> funForgetPass(Map _map) async {
    String token = await Prefs.token;
    print("tiken:${token}");
    String url = serviceFunction.funForgetPass;
    response = await dio.post(url, data: _map);
    return verifyOtpModel.fromJson(convert.json.decode(response.toString()));
  }

  //forgetPassword
  static Future<verifyOtpModel> funVerifyOtp(Map _map) async {
    String url = serviceFunction.funVerifyOtp;
    response = await dio.post(url, data: _map);
    if (response.statusCode == 400) {
      BotToast.showText(
          text: response.statusMessage, duration: Duration(seconds: 5));
    }
    return verifyOtpModel.fromJson(convert.json.decode(response.toString()));
  }

  //Chat
  static Future<UserModel> getChatList(Key key) async {
    String url = serviceFunction.getChatList;
    String token = await Prefs.token;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, options: opt);
    return UserModel.fromJson(convert.json.decode(response.toString()));
  }


  //getFirebaseConnectedList
  static Future<ConnectionListModel> getFirebaseConnectedList() async {
    String url = serviceFunction.getFirebaseConnectedList;
    String token = await Prefs.token;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, options: opt);
    return ConnectionListModel.fromJson(convert.json.decode(response.toString()));
  }

  //getChat
  static Future<ChatModel> getChat(Map _map, Key key) async {
    String url = serviceFunction.getChat;
    String token = await Prefs.token;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, data: _map, options: opt);
    return ChatModel.fromJson(convert.json.decode(response.toString()));
  }

//setChat
  static Future<BaseResponseModel> setChat(
      String userId, String roomId, List files, String message) async {
    String token = await Prefs.token;
    print("tiken:${token}");
    String url = serviceFunction.setChat;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    List va = [];
    for (var v in files)
      va.add(await MultipartFile.fromFile(v.path,
          filename: v.path.split('/').last));
    Map<String, dynamic> _map = {
      "file": va,
      "user_id": userId,
      "room_id": roomId,
      "message": message
    };
    print("_map:${_map.toString()}");
    FormData formData = FormData.fromMap(_map);
    response = await dio.post(url, data: formData, options: opt);

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return BaseResponseModel.fromJson(
          convert.json.decode(response.toString()));
    }
  }

  //resetPassword
  static Future<verifyOtpModel> funChangePassword(
      Map _map, BuildContext _context) async {
    if (!await utilProvider.checkInternet())
      return verifyOtpModel(
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

    print("map:${_map}");
    String token = await Prefs.token;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    String url = serviceFunction.funChangePassword;
    try {
      response = await dio.post(url, data: _map, options: opt);
    } on DioError catch (e) {
      pr.hide();
      if (e.error is SocketException) {
        BotToast.showText(text: "Server not responding");
        return verifyOtpModel(status: 'fail', message: "Server not responding");
      }
    } finally {
      if (pr.isShowing()) pr.hide();
    }
    return verifyOtpModel.fromJson(convert.json.decode(response.toString()));
  }

  //resetPassword
  static Future<BaseResponseModel> deleteBooking(Map _map) async {
    if (!await utilProvider.checkInternet())
      return BaseResponseModel(
          status: 'fail', message: 'Please check internet connections');

    print("map:${_map}");
    String token = await Prefs.token;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    String url = serviceFunction.deleteBooking;
    try {
      response = await dio.post(url, data: _map, options: opt);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        BotToast.showText(text: "Server not responding");
        return BaseResponseModel(
            status: 'fail', message: "Server not responding");
      }
    }
    return BaseResponseModel.fromJson(convert.json.decode(response.toString()));
  }

  static Future<BaseResponseModel> funClaimVerifyOtp() async {
    String token = await Prefs.token;
    print("tiken:${token}");
    String url = serviceFunction.funClaimVerifyOtp;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url,options: opt);

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return BaseResponseModel.fromJson(
          convert.json.decode(response.toString()));
    }
  }

  static Future<BaseResponseModel> funSendEmailVerifyLink(
      BuildContext context) async {
    String token = await Prefs.token;
    print("tiken:${token}");
    String url = serviceFunction.funSendEmailVerifyLink;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, options: opt);

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return BaseResponseModel.fromJson(
          convert.json.decode(response.toString()));
    }
  }

  static Future<BaseResponseModel> funClaimAdd(
      String mono, String mail, List files, BuildContext context) async {
    String token = await Prefs.token;
    print("tiken:${token}");
    String url = serviceFunction.funClaimAdd;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    List va = [];
    for (var v in files)
      va.add(await MultipartFile.fromFile(v.path,
          filename: v.path.split('/').last));
    Map<String, dynamic> _map = {"photo": va, "phone": mono, "email": mail};
    print("_map:${_map.toString()}");
    FormData formData = FormData.fromMap(_map);
    response = await dio.post(url, data: formData, options: opt);

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return BaseResponseModel.fromJson(
          convert.json.decode(response.toString()));
    }
  }

  static Future<ReviewintroModel> funReviewIntro(BuildContext context) async {
    String token = await Prefs.token;
    print("tiken:${token}");
    String url = serviceFunction.funReviewIntro;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, options: opt);

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return ReviewintroModel.fromJson(
          convert.json.decode(response.toString()));
    }
  }

  static Future<ReviewListModel> funReviewList(page) async {
    String token = await Prefs.token;
    print("tiken:${token}");
    String url = serviceFunction.funReviewList;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, data: page, options: opt);

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return ReviewListModel.fromJson(convert.json.decode(response.toString()));
    }
  }

  static Future<ReviewModel> funReviewgetReviewReplies(page) async {
    String token = await Prefs.token;
    print("tiken:${token}");
    String url = serviceFunction.funReviewgetReviewReplies;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, data: page, options: opt);

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return ReviewModel.fromJson(convert.json.decode(response.toString()));
    }
  }

  static Future<ReviewModel> funReviewReply(Map _map) async {
    String token = await Prefs.token;
    print("tiken:${token}");
    String url = serviceFunction.funReviewReply;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, data: _map, options: opt);

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return ReviewModel.fromJson(convert.json.decode(response.toString()));
    }
  }

  static Future<ReviewModel> funCategoryList(Map _map) async {
    String token = await Prefs.token;
    print("tiken:${token}");
    String url = serviceFunction.funCategoryList;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, data: _map, options: opt);

    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return ReviewModel.fromJson(convert.json.decode(response.toString()));
    }
  }

  static Future<dynamic> funMenuStatusChange(Map _map) async {
    String token = await Prefs.token;
    print("tiken:${token}");
    String url = serviceFunction.funMenuStatusChange;

    print("data:${_map.toString()}");
    print("url:${url}");
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, data: _map, options: opt);
    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return _map['api_type'] == 'get'
          ? MenuItemOnlyModel.fromJson(convert.json.decode(response.toString()))
          : BaseResponseModel.fromJson(
              convert.json.decode(response.toString()));
    }
  }

  static Future<MenuBaseModel> funMenuList() async {
    String token = await Prefs.token;
    print("token:${token}");
    String url = serviceFunction.funMenuList;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, options: opt);
    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      return MenuBaseModel.fromJson(convert.json.decode(response.toString()));
    }
  }

  static Future<MenuBaseModel> funMenuCatList(Map _map) async {
    String token = await Prefs.token;
    print("tiken:${token}");
    String url = serviceFunction.funMenuCatList;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, data: _map, options: opt);
    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return MenuBaseModel.fromJson(convert.json.decode(response.toString()));
    }
  }

  static Future<BaseResponseModel> funMenuCatEdit(Map _map) async {
    String token = await Prefs.token;
    print("tiken:${token}");
    String url = serviceFunction.funMenuCatEdit;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, data: _map, options: opt);
    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return BaseResponseModel.fromJson(
          convert.json.decode(response.toString()));
    }
  }

  static Future<getFBIdModel> setGetFirebaseId(Map _map) async {
    String token = await Prefs.token;
    print("tiken:${token}");
    String url = serviceFunction.setGetFirebaseId;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, data: _map, options: opt);
    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return getFBIdModel.fromJson(
          convert.json.decode(response.toString()));
    }
  }

  static Future<MenuVerbose> funMenuVerbose() async {
    String token = await Prefs.token;
    print("tiken:${token}");
    String url = serviceFunction.funMenuVerbose;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, options: opt);
    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return MenuVerbose.fromJson(convert.json.decode(response.toString()));
    }
  }

  static Future<BaseResponseModel> funMenuCreate(
      FormData _map, context, bool edit) async {
    String token = await Prefs.token;
    String url =
        edit ? serviceFunction.funMenuEdit : serviceFunction.funMenuCreate;
    Options _opt =
        Options(contentType: Headers.formUrlEncodedContentType, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });
    print("funMenuCreate:${url}");
    response = await dio
        .post(url, data: _map, options: _opt)
        .timeout(Duration(minutes: 1));
    print("profileImageUpdate:${response.toString()}");

    if (response.statusCode == HttpStatus.ok)
      return BaseResponseModel.fromJson(
          convert.json.decode(response.toString()));
  }

  static Future<MenuSettingModel> funMenuSetting() async {
    String token = await Prefs.token;
    print("tiken:${token}");
    String url = serviceFunction.funMenuSetting;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, options: opt);
    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return MenuSettingModel.fromJson(
          convert.json.decode(response.toString()));
    }
  }

  static Future<BaseResponseModel> funMenuSettingUpdate(Map _map) async {
    String token = await Prefs.token;
    print("tiken:${token}");
    String url = serviceFunction.funMenuSettingUpdate;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, data: _map, options: opt);
    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return BaseResponseModel.fromJson(
          convert.json.decode(response.toString()));
    }
  }

  static Future<MenuItemModel> funMenuItemDetail(Map _map) async {
    String token = await Prefs.token;
    print("tiken:${token}");
    String url = serviceFunction.funMenuItemDetail;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, data: _map, options: opt);
    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return MenuItemModel.fromJson(convert.json.decode(response.toString()));
    }
  }

  static Future<BaseResponseModel> funMenuItemDelete(Map _map) async {
    String token = await Prefs.token;
    print("tiken:${token}");
    String url = serviceFunction.funMenuItemDelete;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, data: _map, options: opt);
    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return BaseResponseModel.fromJson(
          convert.json.decode(response.toString()));
    }
  }

  static Future<ProfileImage> funUserPhoto() async {
    String token = await Prefs.token;
    print("tiken:${token}");
    String url = serviceFunction.funUserPhoto;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, options: opt);
    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return ProfileImage.fromJson(convert.json.decode(response.toString()));
    }
  }

  static Future<websiteModel> websitesList() async {
    String token = await Prefs.token;
    print("tiken:${token}");
    String url = serviceFunction.websitesList;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, options: opt);
    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return websiteModel.fromJson(convert.json.decode(response.toString()));
    }
  }

  static void hideit(ProgressDialog pr) {
    pr.hide();
    if (pr.isShowing()) hideit(pr);
  }
}
