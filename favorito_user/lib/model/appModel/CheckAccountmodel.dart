class CheckAccountmodel {
  String status;
  String message;
  List<AcData> data;

  CheckAccountmodel({this.status, this.message, this.data});

  CheckAccountmodel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<AcData>();
      json['data'].forEach((v) {
        data.add(new AcData.fromJson(v));
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

class AcData {
  int isExist;

  AcData({this.isExist});

  AcData.fromJson(Map<String, dynamic> json) {
    isExist = json['is_exist'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_exist'] = this.isExist;
    return data;
  }
}
