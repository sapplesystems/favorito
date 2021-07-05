import 'package:favorito_user/model/appModel/appointment/Slots.dart';

class SlotModel {
  String status;
  String message;
  Data data;

  SlotModel({this.status, this.message, this.data});

  SlotModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    
     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String date;
  List<Slots> slots;

  Data({this.date, this.slots});

  Data.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['slots'] != null) {
      slots = [];
      json['slots'].forEach((v) {
        slots.add(new Slots.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.slots != null) {
      data['slots'] = this.slots.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


