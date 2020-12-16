import 'package:favorito_user/model/appModel/search/BusinessProfileData.dart';

class BaseResponse {
  String status;
  String message;

  BaseResponse({this.status, this.message});

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    // status = json['status'];
    // message = json['message'];
    // if (json['data'] != null) {
    //   data = new List<T>();
    //   json['data'].forEach((v) {
    //     data.add(new T.fromJson(v));
    //   });
    // }
    return BaseResponse(
      status: json["status"],
      message: (json["msg"] ?? "").toString(),
    );
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['status'] = this.status;
  //   data['message'] = this.message;
  //   if (this.data != null) {
  //     data['data'] = this.data.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}
