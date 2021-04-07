class BookingSettingData {
  String startTime;
  String endTime;
  int advanceBookingStartDays;
  int advanceBookingEndDays;
  int advanceBookingHours;
  var slotLength;
  int bookingPerSlot;
  int bookingPerDay;
  String announcement;

  BookingSettingData(
      {this.startTime,
      this.endTime,
      this.advanceBookingStartDays,
      this.advanceBookingEndDays,
      this.advanceBookingHours,
      this.slotLength,
      this.bookingPerSlot,
      this.bookingPerDay,
      this.announcement});

  BookingSettingData.fromJson(Map<String, dynamic> json) {
    startTime = json['start_time'];
    endTime = json['end_time'];
    advanceBookingStartDays = json['advance_booking_start_days'];
    advanceBookingEndDays = json['advance_booking_end_days'];
    advanceBookingHours = json['advance_booking_hours'];
    slotLength = json['slot_length'];
    bookingPerSlot = json['booking_per_slot'];
    bookingPerDay = json['booking_per_day'];
    announcement = json['announcement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['advance_booking_start_days'] = this.advanceBookingStartDays;
    data['advance_booking_end_days'] = this.advanceBookingEndDays;
    data['advance_booking_hours'] = this.advanceBookingHours;
    data['slot_length'] = this.slotLength;
    data['booking_per_slot'] = this.bookingPerSlot;
    data['booking_per_day'] = this.bookingPerDay;
    data['announcement'] = this.announcement;
    return data;
  }
}
