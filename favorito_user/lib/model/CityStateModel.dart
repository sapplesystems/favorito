class CityStateModel {
  String status;
  String message;
  List<CityStateData> data;

  CityStateModel({this.status, this.message, this.data});

  CityStateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<CityStateData>();
      json['data'].forEach((v) {
        data.add(new CityStateData.fromJson(v));
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

class CityStateData {
  int id;
  String state;

  CityStateData({this.id, this.state});

  CityStateData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['state'] = this.state;
    return data;
  }
}
