class ProfileImage {
  String status;
  String message;
  List<Result> result;

  ProfileImage({this.status, this.message, this.result});

  ProfileImage.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = new List<Result>();
      json['result'].forEach((v) {
        result.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String photo;
  String shortDescription;

  Result({this.photo, this.shortDescription});

  Result.fromJson(Map<String, dynamic> json) {
    photo = json['photo'];
    shortDescription = json['short_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photo'] = this.photo;
    data['short_description'] = this.shortDescription;
    return data;
  }
}
