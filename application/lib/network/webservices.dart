import 'dart:io';
import 'package:Favorito/model/BaseResponse/BaseResponseModel.dart';
import 'package:Favorito/model/CatListModel.dart';
import 'package:Favorito/model/StateListModel.dart';
import 'package:Favorito/model/SubCategoryModel.dart';
import 'package:Favorito/model/adSpentModel.dart';
import 'package:Favorito/model/booking/CreateBookingModel.dart';
import 'package:Favorito/model/business/BusinessProfileModel.dart';
import 'package:Favorito/model/businessInfoImage.dart';
import 'package:Favorito/model/businessInfoModel.dart';
import 'package:Favorito/model/catalog/CatalogListRequestModel.dart';
import 'package:Favorito/model/contactPerson/BranchDetailsModel.dart';
import 'package:Favorito/model/contactPerson/ContactPersonRequiredDataModel.dart';
import 'package:Favorito/model/contactPerson/SearchBranchResonseModel.dart';
import 'package:Favorito/model/contactPerson/UpdateContactPerson.dart';
import 'package:Favorito/model/highLightesData.dart';
import 'package:Favorito/model/job/CityModelResponse.dart';
import 'package:Favorito/model/job/CreateJobRequestModel.dart';
import 'package:Favorito/model/job/CreateJobRequiredDataModel.dart';
import 'package:Favorito/model/job/EditJobDataModel.dart';
import 'package:Favorito/model/job/JobListRequestModel.dart';
import 'package:Favorito/model/job/PincodeListModel.dart';
import 'package:Favorito/model/job/SkillListRequiredDataModel.dart';
import 'package:Favorito/model/dashModel.dart';
import 'package:Favorito/model/loginModel.dart';
import 'package:Favorito/model/notification/CityListModel.dart';
import 'package:Favorito/model/notification/CreateNotificationRequestModel.dart';
import 'package:Favorito/model/notification/CreateNotificationRequiredDataModel.dart';
import 'package:Favorito/model/notification/NotificationListRequestModel.dart';
import 'package:Favorito/model/busyListModel.dart';
import 'package:Favorito/model/offer/CreateOfferRequestModel.dart';
import 'package:Favorito/model/offer/CreateOfferRequiredDataModel.dart';
import 'package:Favorito/model/offer/OfferListDataModel.dart';
import 'package:Favorito/model/profileDataModel.dart';
import 'package:Favorito/model/registerModel.dart';
import 'package:Favorito/model/waitlist/WaitlistListModel.dart';
import 'package:Favorito/network/serviceFunction.dart';
import 'package:Favorito/utils/Prefs.dart';
import 'package:dio/dio.dart';
import 'dart:convert' as convert;

class WebService {
  static Response response;
  static Dio dio = new Dio();
  static Options opt = Options(contentType: Headers.formUrlEncodedContentType);

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

  static Future<dashData> funGetDashBoard() async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    dashModel _data = dashModel();
    print("Request URL:${serviceFunction.funDash}");
    response = await dio.post(serviceFunction.funDash, options: _opt);
    print("Response:${response.toString()}");
    if (response.statusCode == 200) {
      _data = dashModel.fromJson(convert.json.decode(response.toString()));
      print("DashBoard Data is:${_data.toString()}");
    } else if (response.statusCode != 200) {
      Prefs().clear();
    }
    print("responseData3:${_data.status}");
    return _data.data;
  }

  static Future<NotificationListRequestModel> funGetNotifications() async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    NotificationListRequestModel _returnData = NotificationListRequestModel();
    response =
        await dio.post(serviceFunction.funGetNotifications, options: _opt);
    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:${serviceFunction.funGetNotifications}");
      _returnData = NotificationListRequestModel.fromJson(
          convert.json.decode(response.toString()));
    } else {
      print("responseData4:${response.statusCode}");
    }
    return _returnData;
  }

  static Future<BaseResponseModel> profileImageUpdate(File file) async {
    String token = await Prefs.token;
    Options _opt =
        Options(contentType: Headers.formUrlEncodedContentType, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "photo": await MultipartFile.fromFile(file.path, filename: fileName),
    });

    BaseResponseModel _returnData = BaseResponseModel();
    response = await dio.post(serviceFunction.funProfileUpdatephoto,
        data: formData, options: _opt);
    print("profileImageUpdate:${response.toString()}");

    if (response.statusCode == HttpStatus.ok) {
      _returnData =
          BaseResponseModel.fromJson(convert.json.decode(response.toString()));
    } else {
      print("responseData4:${response.statusCode}");
    }

    return response.data;
  }

  static Future<profileDataModel> getProfileData() async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(serviceFunction.funUserProfile, options: _opt);
    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:${serviceFunction.funUserProfile}");
      print("Response is :${response.toString()}");

      return profileDataModel
          .fromJson(convert.json.decode(response.toString()));
    }
  }

  static Future<CreateNotificationRequiredDataModel>
      funGetCreateNotificationDefaultData() async {
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

  static Future<BaseResponseModel> funCreateNotification(
      CreateNotificationRequestModel requestData) async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    BaseResponseModel _returnData = BaseResponseModel();
    Map<String, dynamic> _map = {
      "title": requestData.title,
      "description": requestData.description,
      "action": requestData.selectedAction,
      "contact": requestData.contact,
      "audience": requestData.selectedAudience,
      "area": requestData.selectedArea,
      "area_detail": requestData.areaDetail,
      "quantity": requestData.selectedQuantity
    };
    response = await dio.post(serviceFunction.funCreateNotification,
        data: _map, options: _opt);
    print("Request URL:${serviceFunction.funCreateNotification}");
    _returnData =
        BaseResponseModel.fromJson(convert.json.decode(response.toString()));
    print("responseData6:${_returnData.status}");
    return _returnData;
  }

  static Future<registerModel> funRegister(Map _map) async {
    registerModel _data = registerModel();
    response = await dio.post(serviceFunction.funBusyRegister,
        data: _map, options: opt);
    _data = registerModel.fromJson(convert.json.decode(response.toString()));
    Prefs.setToken(_data.token.toString().trim());
    print("responseData7:${_data.toString().trim()}");
    print("token:${_data.token.toString().trim()}");
    return _data;
  }

  static Future<loginModel> funGetLogin(Map _map) async {
    loginModel _data = loginModel();
    response =
        await dio.post(serviceFunction.funLogin, data: _map, options: opt);
    _data = loginModel.fromJson(convert.json.decode(response.toString()));
    Prefs.setToken(_data.token.toString().trim());
    return _data.status == "success" ? _data : _data;
  }

  static Future<CityListModel> funGetCities() async {
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

  static Future<BaseResponseModel> funValidPincode(String pincode) async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    BaseResponseModel _returnData = BaseResponseModel();
    Map<String, dynamic> _map = {"pincode": pincode};
    response = await dio.post(serviceFunction.funValidPincode,
        data: _map, options: _opt);
    _returnData =
        BaseResponseModel.fromJson(convert.json.decode(response.toString()));
    print("responseData8:${_returnData.status}");
    return _returnData;
  }

  static Future<JobListRequestModel> funGetJobs() async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    JobListRequestModel _returnData = JobListRequestModel();

    print("Request URL:${serviceFunction.funGetJobs}");
    response =
        await dio.post(serviceFunction.funGetJobs, data: null, options: _opt);
    _returnData =
        JobListRequestModel.fromJson(convert.json.decode(response.toString()));
    print("responseData5:${_returnData.status}");
    return _returnData;
  }

  static Future<CreateJobRequiredDataModel> funGetCreteJobDefaultData() async {
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

  static Future<List<SkillListRequiredDataModel>> funGetSkillList() async {
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

  static Future<CreateOfferRequiredDataModel>
      funGetCreateOfferDefaultData() async {
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
      CreateOfferRequestModel requestData) async {
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
      CreateJobRequestModel requestData) async {
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
      "pincode": requestData.pincode
    };
    response =
        await dio.post(serviceFunction.funCreateJob, data: _map, options: _opt);
    _returnData =
        BaseResponseModel.fromJson(convert.json.decode(response.toString()));
    print("responseData3:${_returnData.status}");
    return _returnData;
  }

  static Future<ContactPersonRequiredDataModel>
      funContactPersonRequiredData() async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    ContactPersonRequiredDataModel _returnData =
        ContactPersonRequiredDataModel();

    response = await dio.post(serviceFunction.funContactPersonRequiredData,
        data: null, options: _opt);
    _returnData = ContactPersonRequiredDataModel.fromJson(
        convert.json.decode(response.toString()));
    print("responseData5:${_returnData.status}");
    return _returnData;
  }

  static Future<BaseResponseModel> funUpdateContactPerson(
      UpdateContactPerson requestData,
      List<BranchDetailsModel> branchList) async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    BaseResponseModel _returnData = BaseResponseModel();
    Map<String, dynamic> _map = {
      "first_name": requestData.firtName,
      "last_name": requestData.lastName,
      "role": requestData.role,
      "bank_ac_holder_name": requestData.name,
      "account_number": requestData.accNo,
      "ifsc_code": requestData.ifsc,
      "upi": requestData.upi
    };

    response = await dio.post(serviceFunction.funUpdateContactPerson,
        data: _map, options: _opt);
    _returnData =
        BaseResponseModel.fromJson(convert.json.decode(response.toString()));
    return _returnData;
  }

  static Future<CityModelResponse> funGetCityByPincode(String pincode) async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    Map<String, dynamic> _map = {"pincode": pincode};
    CityModelResponse _returnData = CityModelResponse();
    print("Request URL:${serviceFunction.funGetCityByPincode}");
    response = await dio.post(serviceFunction.funGetCityByPincode,
        data: _map, options: _opt);
    _returnData =
        CityModelResponse.fromJson(convert.json.decode(response.toString()));
    print("responseData5:${_returnData.toString()}");
    return _returnData;
  }

  static Future<PincodeListModel> funGetPicodesForCity(int cityId) async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    Map<String, dynamic> _map = {"city_id": cityId};
    PincodeListModel _returnData = PincodeListModel();
    response = await dio.post(serviceFunction.funGetPincodesForCity,
        data: _map, options: _opt);
    _returnData =
        PincodeListModel.fromJson(convert.json.decode(response.toString()));
    return _returnData;
  }

  static Future<CatalogListRequestModel> funGetCatalogs() async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    CatalogListRequestModel _returnData = CatalogListRequestModel();

    response = await dio.post(serviceFunction.funGetCatalogs,
        data: null, options: _opt);
    _returnData = CatalogListRequestModel.fromJson(
        convert.json.decode(response.toString()));
    return _returnData;
  }

  static Future<WaitlistListModel> funGetWaitlist() async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    WaitlistListModel _returnData = WaitlistListModel();

    response = await dio.post(serviceFunction.funGetWaitlist,
        data: null, options: _opt);
    _returnData =
        WaitlistListModel.fromJson(convert.json.decode(response.toString()));
    return _returnData;
  }

  static Future<BaseResponseModel> funCreateManualBooking(
      CreateBookingModel requestData) async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    BaseResponseModel _returnData = BaseResponseModel();
    Map<String, dynamic> _map = {
      "name": requestData.name,
      "contact": requestData.mobileNo,
      "no_of_person": requestData.noOfPerson,
      "special_notes": requestData.notes,
      "created_date": requestData.createdDate,
      "created_time": requestData.createdTime
    };

    response = await dio.post(serviceFunction.funCreateManualBooking,
        data: _map, options: _opt);
    _returnData =
        BaseResponseModel.fromJson(convert.json.decode(response.toString()));
    return _returnData;
  }

  static Future<SearchBranchResponseModel> funSearchBranches(
      String searchText) async {
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

  static Future<BusinessProfileModel> funGetBusinessProfileData() async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    BusinessProfileModel _returnData = BusinessProfileModel();
    response = await dio.post(serviceFunction.funGetBusinessProfileData,
        data: null, options: _opt);
    _returnData =
        BusinessProfileModel.fromJson(convert.json.decode(response.toString()));
    return _returnData;
  }

  static Future<OfferListDataModel> funGetOfferData() async {
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

  static Future<BaseResponseModel> funEditOffer(var requestData) async {
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

  static Future<EditJobDataModel> funGetEditJobData(var _jobId) async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    Map<String, dynamic> _map = {"job_id": _jobId};
    EditJobDataModel _returnData = EditJobDataModel();
    response = await dio.post(serviceFunction.funGetEditJobData,
        data: _map, options: _opt);
    _returnData =
        EditJobDataModel.fromJson(convert.json.decode(response.toString()));
    return _returnData;
  }

  static Future<BaseResponseModel> funEditJob(
      CreateJobRequestModel requestData) async {
    String token = await Prefs.token;
    Options _opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    BaseResponseModel _returnData = BaseResponseModel();
    Map<String, dynamic> _map = {
      "id": requestData.id,
      "title": requestData.title,
      "description": requestData.description,
      "skills": requestData.skills,
      "contact_via": requestData.contact_via,
      "contact_value": requestData.contact_value,
      "city": requestData.city,
      "pincode": requestData.pincode
    };
    response =
        await dio.post(serviceFunction.funCreateJob, data: _map, options: _opt);
    _returnData =
        BaseResponseModel.fromJson(convert.json.decode(response.toString()));
    print("responseData3:${_returnData.status}");
    return _returnData;
  }

//this service is used for business profile
  static Future<BaseResponseModel> funUserProfileUpdate(Map _map) async {
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
    _returnData =
        BaseResponseModel.fromJson(convert.json.decode(response.toString()));
    print("responseData1:${_returnData.status}");
    return _returnData;
  }

//*********************************************** Business information data  **********************/
  static Future<businessInfoModel> getBusinessInfoData() async {
    String token = await Prefs.token;
    String url = serviceFunction.funUserInformation;
    opt = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    businessInfoModel _returnData = businessInfoModel();
    response = await dio.post(url, options: opt);
    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      _returnData =
          businessInfoModel.fromJson(convert.json.decode(response.toString()));
    } else {
      print("responseData4:${response.statusCode}");
    }
    return _returnData;
  }

  static Future<businessInfoImage> profileInfoImageUpdate(List files) async {
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
    response = await dio.post(serviceFunction.funUserInformationAddPhoto,
        data: formData, options: _opt);
    return businessInfoImage.fromJson(convert.json.decode(response.toString()));
  }

  static Future<BaseResponseModel> setBusinessInfoData(
      Map<String, dynamic> _map) async {
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

  static Future<SubCategoryModel> getSubCat(Map _map) async {
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
  static Future<businessInfoImage> highlightImageUpdate(List files) async {
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

  static Future<BaseResponseModel> setHighlightData(Map _map) async {
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

  static Future<highLightesData> getHighlightData() async {
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

//*********************************************** Highlight ******************************/
  static Future<adSpentModel> getAdSpentPageData() async {
    String token = await Prefs.token;
    String url = serviceFunction.funAdSpentList;
    opt = Options(headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    response = await dio.post(url, options: opt);
    if (response.statusCode == HttpStatus.ok) {
      print("Request URL:$url");
      print("Response is :${response.toString()}");
      return adSpentModel.fromJson(convert.json.decode(response.toString()));
    }
  }
}
