class busyListModel {
  String status;
  String message;
  List<busData> data;

  busyListModel({this.status, this.message, this.data});

  busyListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<busData>();
      json['data'].forEach((v) {
        data.add(new busData.fromJson(v));
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

class busData {
  int id;
  String typeName;

  busData({this.id, this.typeName});

  busData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeName = json['type_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type_name'] = this.typeName;
    return data;
  }
}
