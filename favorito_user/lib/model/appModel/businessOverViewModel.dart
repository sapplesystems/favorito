import 'package:favorito_user/model/appModel/search/BusinessProfileData.dart';

class businessOverViewModel {
  String status;
  String message;
  List<BusinessProfileData> data;

  businessOverViewModel({this.status, this.message, this.data});

  businessOverViewModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<BusinessProfileData>();
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
