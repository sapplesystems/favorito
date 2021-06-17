import 'package:Favorito/model/Restriction/RestrictionData.dart';

class BookingRestrictionModel {
  String status;
  String message;
  List<RestrictionData> date;

  BookingRestrictionModel({this.status, this.message, this.date});

  BookingRestrictionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['date'] != null) {
      date = new List<RestrictionData>();
      json['date'].forEach((v) {
        date.add(new RestrictionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.date != null) {
      data['date'] = this.date.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
