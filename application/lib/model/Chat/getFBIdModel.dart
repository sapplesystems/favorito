class getFBIdModel {
  String status;
  String message;
  List<Data> data;

  getFBIdModel({this.status, this.message, this.data});

  getFBIdModel.fromJson(Map<String, dynamic> json) {
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
  String firebaseChatId;

  Data({this.firebaseChatId});

  Data.fromJson(Map<String, dynamic> json) {
    firebaseChatId = json['firebase_chat_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firebase_chat_id'] = this.firebaseChatId;
    return data;
  }
}

