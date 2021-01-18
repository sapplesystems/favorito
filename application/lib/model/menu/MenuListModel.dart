class MenuListModel {
  String status;
  String message;
  List<Data> data;

  MenuListModel({this.status, this.message, this.data});

  MenuListModel.fromJson(Map<String, dynamic> json) {
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
  String categoryName;
  String details;
  var tax;
  String slotStartTime;
  String slotEndTime;
  String availableOn;
  int outOfStock;

  Data(
      {this.id,
      this.categoryName,
      this.details,
      this.tax,
      this.slotStartTime,
      this.slotEndTime,
      this.availableOn,
      this.outOfStock});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    details = json['details'];
    tax = json['tax'];
    slotStartTime = json['slot_start_time'];
    slotEndTime = json['slot_end_time'];
    availableOn = json['available_on'];
    outOfStock = json['out_of_stock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['details'] = this.details;
    data['tax'] = this.tax;
    data['slot_start_time'] = this.slotStartTime;
    data['slot_end_time'] = this.slotEndTime;
    data['available_on'] = this.availableOn;
    data['out_of_stock'] = this.outOfStock;
    return data;
  }
}
