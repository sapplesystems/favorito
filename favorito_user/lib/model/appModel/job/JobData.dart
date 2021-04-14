class JobData {
  int id;
  String title;
  String description;
  int noOfPosition;

  JobData({this.id, this.title, this.description, this.noOfPosition});

  JobData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    noOfPosition = json['no_of_position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['no_of_position'] = this.noOfPosition;
    return data;
  }
}
