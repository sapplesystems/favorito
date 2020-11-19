import 'package:Favorito/model/booking/BookingSettingData.dart';

class bookingSettingModel {
  String status;
  String message;
  List<BookingSettingData> data;

  bookingSettingModel({this.status, this.message, this.data});

  bookingSettingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<BookingSettingData>();
      json['data'].forEach((v) {
        data.add(new BookingSettingData.fromJson(v));
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

