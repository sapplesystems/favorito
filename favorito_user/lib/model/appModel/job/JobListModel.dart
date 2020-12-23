import 'package:favorito_user/model/appModel/job/JobData.dart';

class JobListModel {
  String status;
  String message;
  List<String> contactVia;
  List<JobData> data;

  JobListModel({this.status, this.message, this.contactVia, this.data});

  JobListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    contactVia = json['contact_via'].cast<String>();
    if (json['data'] != null) {
      data = new List<JobData>();
      json['data'].forEach((v) {
        data.add(new JobData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['contact_via'] = this.contactVia;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
