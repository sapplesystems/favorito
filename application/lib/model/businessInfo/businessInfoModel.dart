import 'package:Favorito/model/PhotoData.dart';
import 'package:Favorito/model/SubCategories.dart';
import 'package:Favorito/model/TagList.dart';
import 'package:Favorito/model/businessInfo/BusinessInfoData.dart';
import 'package:Favorito/model/businessInfo/DdVerbose.dart';

class BusinessInfoModel {
  String status;
  String message;
  DdVerbose ddVerbose;
  BusinessInfoData data;

  BusinessInfoModel({this.status, this.message, this.ddVerbose, this.data});

  BusinessInfoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    ddVerbose = json['dd_verbose'] != null
        ? new DdVerbose.fromJson(json['dd_verbose'])
        : null;
    data = json['data'] != null
        ? new BusinessInfoData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.ddVerbose != null) {
      data['dd_verbose'] = this.ddVerbose.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}
