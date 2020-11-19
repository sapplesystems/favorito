class PincodeListModel {
  String status;
  String message;
  List<PincodeModel> pincodeModel;

  PincodeListModel({this.status, this.message, this.pincodeModel});

  PincodeListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      pincodeModel = new List<PincodeModel>();
      json['data'].forEach((v) {
        pincodeModel.add(new PincodeModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.pincodeModel != null) {
      data['data'] = this.pincodeModel.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PincodeModel {
  int id;
  String pincode;

  PincodeModel({this.id, this.pincode});

  PincodeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pincode = json['pincode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pincode'] = this.pincode;
    return data;
  }
}
