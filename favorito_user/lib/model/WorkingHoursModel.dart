class WorkingHoursModel {
  String status;
  String message;
  List<WorkingHoursData> data;

  WorkingHoursModel({this.status, this.message, this.data});

  WorkingHoursModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new WorkingHoursData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WorkingHoursData {
  String businessId;
  String day;
  String startHours;
  String endHours;

  WorkingHoursData({this.businessId, this.day, this.startHours, this.endHours});

  WorkingHoursData.fromJson(Map<String, dynamic> json) {
    businessId = json['business_id'];
    day = json['day'];
    startHours = json['start_hours'];
    endHours = json['end_hours'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.businessId;
    data['day'] = this.day;
    data['start_hours'] = this.startHours;
    data['end_hours'] = this.endHours;
    return data;
  }
}
