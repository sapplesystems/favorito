import 'package:Favorito/model/appoinment/PersonList.dart';

class PersonModel {
  String status;
  String message;
  List<PersonList> data;

  PersonModel({this.status, this.message, this.data});

  PersonModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<PersonList>();
      json['data'].forEach((v) {
        data.add(new PersonList.fromJson(v));
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
