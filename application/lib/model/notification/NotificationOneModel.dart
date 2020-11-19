class NotificationOneModel {
  String status;
  String message;
  List<Data> data;

  NotificationOneModel({this.status, this.message, this.data});

  NotificationOneModel.fromJson(Map<String, dynamic> json) {
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
  String title;
  String description;
  String action;
  String contact;
  String audience;
  String area;
  String areaDetail;
  String quantity;
  String businessId;
  int businessUserId;

  Data(
      {this.title,
      this.description,
      this.action,
      this.contact,
      this.audience,
      this.area,
      this.areaDetail,
      this.quantity,
      this.businessId,
      this.businessUserId});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    action = json['action'];
    contact = json['contact'];
    audience = json['audience'];
    area = json['area'];
    areaDetail = json['area_detail'];
    quantity = json['quantity'];
    businessId = json['business_id'];
    businessUserId = json['business_user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['action'] = this.action;
    data['contact'] = this.contact;
    data['audience'] = this.audience;
    data['area'] = this.area;
    data['area_detail'] = this.areaDetail;
    data['quantity'] = this.quantity;
    data['business_id'] = this.businessId;
    data['business_user_id'] = this.businessUserId;
    return data;
  }
}
