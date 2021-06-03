class ClaimInfo {
  String status;
  String message;
  List<Result> result;

  ClaimInfo({this.status, this.message, this.result});

  ClaimInfo.fromJson(Map<String, dynamic> json) {
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
  String businessEmail;
  String businessPhone;
  int isEmailVerified;
  int isPhoneVerified;

  Result(
      {this.businessEmail,
      this.businessPhone,
      this.isEmailVerified,
      this.isPhoneVerified});

  Result.fromJson(Map<String, dynamic> json) {
    businessEmail = json['business_email'];
    businessPhone = json['business_phone'];
    isEmailVerified = json['is_email_verified'];
    isPhoneVerified = json['is_phone_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_email'] = this.businessEmail;
    data['business_phone'] = this.businessPhone;
    data['is_email_verified'] = this.isEmailVerified;
    data['is_phone_verified'] = this.isPhoneVerified;
    return data;
  }
}
