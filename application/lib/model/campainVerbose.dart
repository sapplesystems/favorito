class campainVerbose {
  String status;
  String message;
  Data data;

  campainVerbose({this.status, this.message, this.data});

  campainVerbose.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<dynamic> cpc;
  List<String> adStatus;

  Data({this.cpc, this.adStatus});

  Data.fromJson(Map<String, dynamic> json) {
    cpc = json['cpc'].cast<dynamic>();
    adStatus = json['ad_status']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cpc'] = this.cpc;
    data['ad_status'] = this.adStatus;
    return data;
  }
}
