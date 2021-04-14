class Relation {
  var isRelation;
  var relationId;

  Relation({this.isRelation, this.relationId});

  Relation.fromJson(Map<String, dynamic> json) {
    isRelation = json['is_relation'];
    relationId = json['relation_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_relation'] = this.isRelation;
    data['relation_id'] = this.relationId;
    return data;
  }
}
