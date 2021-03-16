class CityListModel {
  String status;
  String message;
  List<CityModel> data;

  CityListModel({this.status, this.message, this.data});

  CityListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<CityModel>();
      json['data'].forEach((v) {
        data.add(new CityModel.fromJson(v));
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

  getCityIdByName(String _name) {
    var _va;
    for (int i = 0; i < data.length; i++) {
      if (data[i].city == _name) {
        _va = data[i].id;
      }
    }
    return _va;
  }
}

class CityModel {
  int id;
  String city;

  CityModel({this.id, this.city});

  CityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['city'] = this.city;
    return data;
  }

  bool isEqual(CityModel model) {
    return this?.id == model?.id;
  }

  String userAsString() {
    return '${this.city}';
  }
}
