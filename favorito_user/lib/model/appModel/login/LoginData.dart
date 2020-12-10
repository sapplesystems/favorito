class LoginData {
  String postel;
  LoginData({this.postel});

  LoginData.fromJson(Map<String, dynamic> json) {
    postel = json['postel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postel'] = this.postel;
    return data;
  }
}
