import 'package:favorito_user/model/appModel/appointment/Occasion.dart';
import 'package:favorito_user/model/appModel/appointment/Slots.dart';

class BookTableVerbose {
  String status;
  String message;
  Data data;

  BookTableVerbose({this.status, this.message, this.data});

  BookTableVerbose.fromJson(Map<String, dynamic> json) {
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
  String businessName;
  List<AvailableDates> availableDates;
  String date;
  List<Slots> slots;
  List<Occasion> occasion;

  Data(
      {this.businessName,
      this.availableDates,
      this.date,
      this.slots,
      this.occasion});

  Data.fromJson(Map<String, dynamic> json) {
    businessName = json['business_name'];
    if (json['available_dates'] != null) {
      availableDates =[];
      json['available_dates'].forEach((v) {
        availableDates.add(new AvailableDates.fromJson(v));
      });
    }
    date = json['date'];
    if (json['slots'] != null) {
      slots = [];
      json['slots'].forEach((v) {
        slots.add(new Slots.fromJson(v));
      });
    }
    if (json['occasion'] != null) {
      occasion = [];
      json['occasion'].forEach((v) {
        occasion.add(new Occasion.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_name'] = this.businessName;
    if (this.availableDates != null) {
      data['available_dates'] =
          this.availableDates.map((v) => v.toJson()).toList();
    }
    data['date'] = this.date;
    if (this.slots != null) {
      data['slots'] = this.slots.map((v) => v.toJson()).toList();
    }
    if (this.occasion != null) {
      data['occasion'] = this.occasion.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AvailableDates {
  String date;
  String day;

  AvailableDates({this.date, this.day});

  AvailableDates.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    day = json['day'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['day'] = this.day;
    return data;
  }
}



