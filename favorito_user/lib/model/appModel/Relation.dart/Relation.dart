class Relation {
  int isRelation;
  int relationId;

  Relation({this.isRelation, this.relationId});

  Relation.fromJson(Map<String, dynamic> json) {
    isRelation = json['is_relation'];
    relationId = json['relation_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> Relation = new Map<String, dynamic>();
    Relation['is_relation'] = this.isRelation;
    Relation['relation_id'] = this.relationId;
    return Relation;
  }
}
