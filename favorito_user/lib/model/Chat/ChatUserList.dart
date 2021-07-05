
class ChatUser {
  int id;
  String sourceId;
  String targetId;

  ChatUser({this.id, this.sourceId, this.targetId});

  ChatUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sourceId = json['source_id'];
    targetId = json['target_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['source_id'] = this.sourceId;
    data['target_id'] = this.targetId;
    return data;
  }
}

