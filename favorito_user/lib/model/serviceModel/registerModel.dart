class registerModel {
  String status;
  String message;
  int id;
  String phone;
  String token;

  registerModel({this.status, this.message, this.id, this.phone, this.token});

  registerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    id = json['id'];
    phone = json['phone'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['id'] = this.id;
    data['phone'] = this.phone;
    data['token'] = this.token;
    return data;
  }
}
