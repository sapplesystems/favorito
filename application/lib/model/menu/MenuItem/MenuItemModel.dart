class MenuItemOnlyModel {
  String status;
  String message;
  List<Data> data;

  MenuItemOnlyModel({this.status, this.message, this.data});

  MenuItemOnlyModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
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
  int isActivated;

  Data({this.isActivated});

  Data.fromJson(Map<String, dynamic> json) {
    isActivated = json['is_activated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_activated'] = this.isActivated;
    return data;
  }
}
