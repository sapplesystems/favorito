class appointmentServiceOnlyModel {
  String status;
  String message;
  List<Data> data;

  appointmentServiceOnlyModel({this.status, this.message, this.data});

  appointmentServiceOnlyModel.fromJson(Map<String, dynamic> json) {
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
  int id;
  String serviceName;
  int isActive;
  Data({this.id, this.serviceName, this.isActive});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceName = json['service_name'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['service_name'] = this.serviceName;
    data['is_active'] = this.isActive;
    return data;
  }
}
