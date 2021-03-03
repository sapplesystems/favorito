class loginModel {
  String status;
  String message;
  Data data;
  String token;

  loginModel({this.status, this.message, this.data, this.token});

  loginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : [];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class Data {
  int id;
  String businessId;
  String email;
  String phone;

  Data({this.id, this.businessId, this.email, this.phone});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessId = json['business_id'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['business_id'] = this.businessId;
    data['email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }
}
