class SettingModel {
  int bookingPerSlot;
  int advanceBookingEndDays;
  int advanceBookingHours;

  SettingModel(
      {this.bookingPerSlot,
      this.advanceBookingEndDays,
      this.advanceBookingHours});

  SettingModel.fromJson(Map<String, dynamic> json) {
    bookingPerSlot = json['booking_per_slot'];
    advanceBookingEndDays = json['advance_booking_end_days'];
    advanceBookingHours = json['advance_booking_hours'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_per_slot'] = this.bookingPerSlot;
    data['advance_booking_end_days'] = this.advanceBookingEndDays;
    data['advance_booking_hours'] = this.advanceBookingHours;
    return data;
  }
}

