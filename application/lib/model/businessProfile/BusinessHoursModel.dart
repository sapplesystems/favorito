class BusinessHoursModel {
  String businessDays;
  String businessStartHours;
  String businessEndHours;

  BusinessHoursModel(
      {this.businessDays, this.businessStartHours, this.businessEndHours});

  BusinessHoursModel.fromJson(Map<String, dynamic> json) {
    businessDays = json['business_days'];
    businessStartHours = json['business_start_hours'];
    businessEndHours = json['business_end_hours'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_days'] = this.businessDays;
    data['business_start_hours'] = this.businessStartHours;
    data['business_end_hours'] = this.businessEndHours;
    return data;
  }
}
