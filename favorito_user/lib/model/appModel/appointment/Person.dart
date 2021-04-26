class Person {
  int id;
  String personName;

  Person({this.id, this.personName});

  Person.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    personName = json['person_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['person_name'] = this.personName;
    return data;
  }
}

