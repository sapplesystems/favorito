class OtpData {
  int userId;
  String responseStatus;

  OtpData({this.userId, this.responseStatus});

  OtpData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    responseStatus = json['response_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['response_status'] = this.responseStatus;
    return data;
  }
}
