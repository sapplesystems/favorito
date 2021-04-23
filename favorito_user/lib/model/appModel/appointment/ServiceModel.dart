
class ServiceModel {
  int id;
  String serviceName;
  int status;

  ServiceModel({this.id, this.serviceName, this.status});

  ServiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceName = json['service_name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['service_name'] = this.serviceName;
    data['status'] = this.status;
    return data;
  }
}
