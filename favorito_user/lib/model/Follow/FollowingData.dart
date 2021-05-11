class FollowingData {
  int relationId;
  String sourceId;
  String targetId;
  String name;
  String websites;
  String shortDescription;
  String status;
  String photo;

  FollowingData(
      {this.relationId,
      this.sourceId,
      this.targetId,
      this.name,
      this.websites,
      this.shortDescription,
      this.status,
      this.photo});

  FollowingData.fromJson(Map<String, dynamic> json) {
    relationId = json['relation_id'];
    sourceId = json['source_id'];
    targetId = json['target_id'];
    name = json['name'];
    websites = json['websites'];
    shortDescription = json['short_description'];
    status = json['status'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['relation_id'] = this.relationId;
    data['source_id'] = this.sourceId;
    data['target_id'] = this.targetId;
    data['name'] = this.name;
    data['websites'] = this.websites;
    data['short_description'] = this.shortDescription;
    data['status'] = this.status;
    data['photo'] = this.photo;
    return data;
  }
}
