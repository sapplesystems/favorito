class ChatModelData {
  int id;
  String sourceId;
  String targetId;
  String message;
  String createdAt;

  ChatModelData(
      {this.id, this.sourceId, this.targetId, this.message, this.createdAt});

  ChatModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sourceId = json['source_id'];
    targetId = json['target_id'];
    message = json['message'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['source_id'] = this.sourceId;
    data['target_id'] = this.targetId;
    data['message'] = this.message;
    data['created_at'] = this.createdAt;
    return data;
  }
}
