
class Occasion {
  int id;
  String occasion;

  Occasion({this.id, this.occasion});

  Occasion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    occasion = json['occasion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['occasion'] = this.occasion;
    return data;
  }
}