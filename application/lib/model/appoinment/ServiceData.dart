class ServiceData {
  int id;
  String serviceName;
  int isActive;

  ServiceData({this.id, this.serviceName, this.isActive});

  ServiceData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceName = json['service_name'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['service_name'] = this.serviceName;
    data['is_active'] = this.isActive;
    return data;
  }
}
