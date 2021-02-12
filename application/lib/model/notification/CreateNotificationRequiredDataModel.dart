class CreateNotificationRequiredDataModel {
  String status;
  String message;
  Data data;

  CreateNotificationRequiredDataModel({this.status, this.message, this.data});

  CreateNotificationRequiredDataModel.fromJson(Map<String, dynamic> json) {
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
  List<String> action;
  List<String> audience;
  List<String> area;
  List<String> status;
  List<StateModel> stateList;

  Data({this.action, this.audience, this.area, this.status, this.stateList});

  Data.fromJson(Map<String, dynamic> json) {
    action = json['action']?.cast<String>();
    audience = json['audience']?.cast<String>();
    area = json['area']?.cast<String>();
    status = json['status']?.cast<String>();
    if (json['state_list'] != null) {
      stateList = new List<StateModel>();
      json['state_list'].forEach((v) {
        stateList.add(new StateModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action'] = this.action;
    data['audience'] = this.audience;
    data['area'] = this.area;
    data['status'] = this.status;
    if (this.stateList != null) {
      data['state_list'] = this.stateList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StateModel {
  int id;
  String state;

  StateModel({this.id, this.state});

  StateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['state'] = this.state;
    return data;
  }

  bool isEqual(StateModel model) {
    return this?.id == model?.id;
  }

  String userAsString() {
    return '${this.state}';
  }
}
