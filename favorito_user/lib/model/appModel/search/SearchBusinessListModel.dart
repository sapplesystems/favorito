import 'package:favorito_user/model/appModel/search/BusinessProfileData.dart';

class SearchBusinessListModel {
  String status;
  String message;
  List<BusinessProfileData> data;

  SearchBusinessListModel({this.status, this.message, this.data});

  SearchBusinessListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != String) {
      data = [];
      json['data'].forEach((v) {
        data.add(new BusinessProfileData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
//
// class SearchResultModel {
//   var id;
//   String businessId;
//   int businessTypeId;
//   int businessCategoryId;
//   String avgRating;
//   String distance;
//   String businessName;
//   String postalCode;
//   String businessPhone;
//   String landline;
//   int reachWhatsapp;
//   String businessEmail;
//   String photo;
//   String address1;
//   String address2;
//   String address3;
//   String pincode;
//   String townCity;
//   int stateId;
//   int countryId;
//   String location;
//   int byAppointmentOnly;
//   String workingHours;
//   String website;
//   String shortDescription;
//   String businessStatus;
//   int isProfileCompleted;
//   int isInformationCompleted;
//   String phoneOtp;
//   String emailOtp;
//   int isPhoneVerified;
//   int isEmailVerified;
//   int isVerified;
//   int isActivated;
//   int createdBy;
//   int updatedBy;
//   String createdAt;
//   String updatedAt;
//   String deletedAt;
//
//   SearchResultModel(
//       {this.id,
//       this.businessId,
//       this.businessTypeId,
//       this.businessCategoryId,
//       this.avgRating,
//       this.distance,
//       this.businessName,
//       this.postalCode,
//       this.businessPhone,
//       this.landline,
//       this.reachWhatsapp,
//       this.businessEmail,
//       this.photo,
//       this.address1,
//       this.address2,
//       this.address3,
//       this.pincode,
//       this.townCity,
//       this.stateId,
//       this.countryId,
//       this.location,
//       this.byAppointmentOnly,
//       this.workingHours,
//       this.website,
//       this.shortDescription,
//       this.businessStatus,
//       this.isProfileCompleted,
//       this.isInformationCompleted,
//       this.phoneOtp,
//       this.emailOtp,
//       this.isPhoneVerified,
//       this.isEmailVerified,
//       this.isVerified,
//       this.isActivated,
//       this.createdBy,
//       this.updatedBy,
//       this.createdAt,
//       this.updatedAt,
//       this.deletedAt});
//
//   SearchResultModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     businessId = json['business_id'];
//     businessTypeId = json['business_type_id'];
//     avgRating = json['avg_rating'].toString();
//     businessCategoryId = json['business_category_id'];
//     distance = json['distance'].toString();
//     businessName = json['business_name'];
//     postalCode = json['postal_code'];
//     businessPhone = json['business_phone'];
//     landline = json['landline'];
//     reachWhatsapp = json['reach_whatsapp'];
//     businessEmail = json['business_email'];
//     photo = json['photo'];
//     address1 = json['address1'];
//     address2 = json['address2'];
//     address3 = json['address3'];
//     pincode = json['pincode'];
//     townCity = json['town_city'];
//     stateId = json['state_id'];
//     countryId = json['country_id'];
//     location = json['location'];
//     byAppointmentOnly = json['by_appointment_only'];
//     workingHours = json['working_hours'];
//     website = json['website'];
//     shortDescription = json['short_description'];
//     businessStatus = json['business_status'];
//     isProfileCompleted = json['is_profile_completed'];
//     isInformationCompleted = json['is_information_completed'];
//     phoneOtp = json['phone_otp'];
//     emailOtp = json['email_otp'];
//     isPhoneVerified = json['is_phone_verified'];
//     isEmailVerified = json['is_email_verified'];
//     isVerified = json['is_verified'];
//     isActivated = json['is_activated'];
//     createdBy = json['created_by'];
//     updatedBy = json['updated_by'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     deletedAt = json['deleted_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['business_id'] = this.businessId;
//     data['business_type_id'] = this.businessTypeId;
//     data['business_category_id'] = this.businessCategoryId;
//     data['avg_rating'] = this.avgRating;
//     data['distance'] = this.distance;
//     data['business_name'] = this.businessName;
//     data['postal_code'] = this.postalCode;
//     data['business_phone'] = this.businessPhone;
//     data['landline'] = this.landline;
//     data['reach_whatsapp'] = this.reachWhatsapp;
//     data['business_email'] = this.businessEmail;
//     data['photo'] = this.photo;
//     data['address1'] = this.address1;
//     data['address2'] = this.address2;
//     data['address3'] = this.address3;
//     data['pincode'] = this.pincode;
//     data['town_city'] = this.townCity;
//     data['state_id'] = this.stateId;
//     data['country_id'] = this.countryId;
//     data['location'] = this.location;
//     data['by_appointment_only'] = this.byAppointmentOnly;
//     data['working_hours'] = this.workingHours;
//     data['website'] = this.website;
//     data['short_description'] = this.shortDescription;
//     data['business_status'] = this.businessStatus;
//     data['is_profile_completed'] = this.isProfileCompleted;
//     data['is_information_completed'] = this.isInformationCompleted;
//     data['phone_otp'] = this.phoneOtp;
//     data['email_otp'] = this.emailOtp;
//     data['is_phone_verified'] = this.isPhoneVerified;
//     data['is_email_verified'] = this.isEmailVerified;
//     data['is_verified'] = this.isVerified;
//     data['is_activated'] = this.isActivated;
//     data['created_by'] = this.createdBy;
//     data['updated_by'] = this.updatedBy;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['deleted_at'] = this.deletedAt;
//     return data;
//   }
// }
