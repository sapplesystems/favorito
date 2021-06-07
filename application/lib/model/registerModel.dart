class RegisterModel {
  String status;
  String message;
  int id;
  String email;
  String phone;
  String token;

  RegisterModel(
      {this.status, this.message, this.id, this.email, this.phone, this.token});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    id = json['id'];
    email = json['email'];
    phone = json['phone'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['id'] = this.id;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['token'] = this.token;
    return data;
  }
}
