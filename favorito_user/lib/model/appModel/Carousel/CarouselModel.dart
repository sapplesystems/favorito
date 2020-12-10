import 'package:favorito_user/model/appModel/Carousel/CarouselData.dart';

class CarouselModel {
  String status;
  String message;
  List<CarouselData> data;

  CarouselModel({this.status, this.message, this.data});

  CarouselModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<CarouselData>();
      json['data'].forEach((v) {
        data.add(new CarouselData.fromJson(v));
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
