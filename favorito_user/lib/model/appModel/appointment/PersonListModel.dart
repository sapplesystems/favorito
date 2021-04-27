import 'package:favorito_user/model/appModel/appointment/Person.dart';

class PersonListModel {
  String status;
  String message;
  List<Person> data;

  PersonListModel({this.status, this.message, this.data});

  PersonListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data =[];
      json['data'].forEach((v) {
        data.add(new Person.fromJson(v));
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