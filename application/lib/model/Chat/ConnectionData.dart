
class ConnectionData {
  int id;
  String targetId;
  String targetRole;
  String name;
  String photo;
  String shortDescription;

  ConnectionData(
      {this.id,
      this.targetId,
      this.targetRole,
      this.name,
      this.photo,
      this.shortDescription});

  ConnectionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    targetId = json['target_id'];
    targetRole = json['target_role'];
    name = json['name'];
    photo = json['photo'];
    shortDescription = json['short_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['target_id'] = this.targetId;
    data['target_role'] = this.targetRole;
    data['name'] = this.name;
    data['photo'] = this.photo;
    data['short_description'] = this.shortDescription;
    return data;
  }
}

