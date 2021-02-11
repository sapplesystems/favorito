class verifyOtpModel {
  String status;
  String message;
  List<Data> data;

  verifyOtpModel({this.status, this.message, this.data});

  verifyOtpModel.fromJson(Map<String, dynamic> json) {
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
  String businesId;
  String responseStatus;

  Data({this.businesId, this.responseStatus});

  Data.fromJson(Map<String, dynamic> json) {
    businesId = json['busines_id'];
    responseStatus = json['response_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['busines_id'] = this.businesId;
    data['response_status'] = this.responseStatus;
    return data;
  }
}
