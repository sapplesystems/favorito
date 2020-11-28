class AddressListModel {
  String status;
  String message;
  Data data;

  AddressListModel({this.status, this.message, this.data});

  AddressListModel.fromJson(Map<String, dynamic> json) {
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
  String userName;
  List<Addresses> addresses;

  Data({this.userName, this.addresses});

  Data.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    if (json['addresses'] != null) {
      addresses = new List<Addresses>();
      json['addresses'].forEach((v) {
        addresses.add(new Addresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    if (this.addresses != null) {
      data['addresses'] = this.addresses.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Addresses {
  int id;
  int userId;
  String city;
  String state;
  int pincode;
  String country;
  String landmark;
  String address;
  Null defaultAddress;
  String createdAt;
  Null updatedAt;
  Null deletedAt;

  Addresses(
      {this.id,
      this.userId,
      this.city,
      this.state,
      this.pincode,
      this.country,
      this.landmark,
      this.address,
      this.defaultAddress,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Addresses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    country = json['country'];
    landmark = json['landmark'];
    address = json['address'];
    defaultAddress = json['default_address'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['city'] = this.city;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    data['country'] = this.country;
    data['landmark'] = this.landmark;
    data['address'] = this.address;
    data['default_address'] = this.defaultAddress;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
