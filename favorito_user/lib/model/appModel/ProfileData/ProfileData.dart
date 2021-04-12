import 'package:favorito_user/model/appModel/ProfileData/Address.dart';
import 'package:favorito_user/model/appModel/ProfileData/Detail.dart';

class ProfileData {
  Detail detail;
  List<Address> address;

  ProfileData({this.detail, this.address});

  ProfileData.fromJson(Map<String, dynamic> json) {
    detail =
        json['detail'] != null ? new Detail.fromJson(json['detail']) : null;
    if (json['address'] != null) {
      address = new List<Address>();
      json['address'].forEach((v) {
        address.add(new Address.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.detail != null) {
      data['detail'] = this.detail.toJson();
    }
    if (this.address != null) {
      data['address'] = this.address.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
