class UserModel {
  String status;
  String message;
  List<UserData> data;

  UserModel({this.status, this.message, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new UserData.fromJson(v));
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

class UserData {
  String targetId;
  String sourceId;
  int roomId;
  String name;
  String photo;
  String shortDescription;
  int unseenCount;

  UserData(
      {this.targetId,
      this.sourceId,
      this.roomId,
      this.name,
      this.photo,
      this.shortDescription,
      this.unseenCount});

  UserData.fromJson(Map<String, dynamic> json) {
    targetId = json['target_id'];
    sourceId = json['source_id'];
    roomId = json['room_id'];
    name = json['name'];
    photo = json['photo'];
    shortDescription = json['short_description'];
    unseenCount = json['unseen_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['target_id'] = this.targetId;
    data['source_id'] = this.sourceId;
    data['room_id'] = this.roomId;
    data['name'] = this.name;
    data['photo'] = this.photo;
    data['short_description'] = this.shortDescription;
    data['unseen_count'] = this.unseenCount;
    return data;
  }

  String toString() {
    return "targetId:$targetId,sourceId:$sourceId,roomId:$roomId,name:$name,photo:$photo,shortDescription:$shortDescription,unseenCount:$unseenCount,";
  }
}
