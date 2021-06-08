class waitListSettingModel {
  String status;
  String message;
  List<WSData> data;

  waitListSettingModel({this.status, this.message, this.data});

  waitListSettingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<WSData>();
      json['data'].forEach((v) {
        data.add(new WSData.fromJson(v));
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

class WSData {
  String startTime;
  String endTime;
  int availableResource;
  String miniumWaitTime;
  int slotLength;
  int bookingPerSlot;
  int bookingPerDay;
  String waitlistManagerName;
  String announcement;
  String exceptDays;

  WSData(
      {this.startTime,
      this.endTime,
      this.availableResource,
      this.miniumWaitTime,
      this.slotLength,
      this.bookingPerSlot,
      this.bookingPerDay,
      this.waitlistManagerName,
      this.announcement,
      this.exceptDays});

  WSData.fromJson(Map<String, dynamic> json) {
    startTime = json['start_time'];
    endTime = json['end_time'];
    availableResource = json['available_resource'];
    miniumWaitTime = json['minium_wait_time'];
    slotLength = json['slot_length'];
    bookingPerSlot = json['booking_per_slot'];
    bookingPerDay = json['booking_per_day'];
    waitlistManagerName = json['waitlist_manager_name'] ?? "";
    announcement = json['announcement'] ?? "";
    exceptDays = json['except_days'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['available_resource'] = this.availableResource;
    data['minium_wait_time'] = this.miniumWaitTime;
    data['slot_length'] = this.slotLength;
    data['booking_per_slot'] = this.bookingPerSlot;
    data['booking_per_day'] = this.bookingPerDay;
    data['waitlist_manager_name'] = this.waitlistManagerName;
    data['announcement'] = this.announcement;
    data['except_days'] = this.exceptDays;
    return data;
  }
}
