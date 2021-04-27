class SettingModel {
  int bookingPerSlot;
  int advanceBookingStartDays;
  int advanceBookingHours;

  SettingModel(
      {this.bookingPerSlot,
      this.advanceBookingStartDays,
      this.advanceBookingHours});

  SettingModel.fromJson(Map<String, dynamic> json) {
    bookingPerSlot = json['booking_per_slot'];
    advanceBookingStartDays = json['advance_booking_start_days'];
    advanceBookingHours = json['advance_booking_hours'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_per_slot'] = this.bookingPerSlot;
    data['advance_booking_start_days'] = this.advanceBookingStartDays;
    data['advance_booking_hours'] = this.advanceBookingHours;
    return data;
  }
}

