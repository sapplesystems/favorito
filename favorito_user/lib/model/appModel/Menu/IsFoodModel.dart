class IsFoodModel {
  String status;
  String message;
  List<Data> data;

  IsFoodModel({this.status, this.message, this.data});

  IsFoodModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
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

class Data {
  int isFood;

  Data({this.isFood});

  Data.fromJson(Map<String, dynamic> json) {
    isFood = json['is_food'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_food'] = this.isFood;
    return data;
  }
}
