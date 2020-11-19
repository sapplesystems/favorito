class ServiceList {
  int id;
  String serviceName;
  int isActive;

  ServiceList({this.id, this.serviceName, this.isActive});

  ServiceList.fromJson(Map<String, dynamic> json) {
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
