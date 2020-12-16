class Relation {
  String relation;

  Relation({this.relation});

  Relation.fromJson(Map<String, dynamic> json) {
    relation = json['relation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['relation'] = this.relation;
    return data;
  }
}
