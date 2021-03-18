class WaitListDataModel {
  var partiesBeforeYou;
  String businessName;
  String availableTimeSlots;
  String minimumWaitTime;
  var waitlistId;
  String createdAt;
  String updatedAt;
  var userId;
  String waitlistStatus;
  String bookedSlot;
  var noOfPerson;
  String businessId;
  String contact;
  Function fun1;
  WaitListDataModel(
      {this.partiesBeforeYou,
      this.businessName,
      this.availableTimeSlots,
      this.minimumWaitTime,
      this.waitlistId,
      this.createdAt,
      this.updatedAt,
      this.userId,
      this.waitlistStatus,
      this.bookedSlot,
      this.noOfPerson,
      this.businessId,
      this.contact,
      this.fun1});

  WaitListDataModel.fromJson(Map<String, dynamic> json) {
    partiesBeforeYou = json['parties_before_you'];
    businessName = json['business_name'];
    availableTimeSlots = json['available_time_slots'];
    minimumWaitTime = json['minimum_wait_time'];
    waitlistId = json['waitlist_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userId = json['user_id'];
    waitlistStatus = json['waitlist_status'];
    bookedSlot = json['booked_slot'];
    noOfPerson = json['no_of_person'];
    businessId = json['business_id'];
    contact = json['contact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['parties_before_you'] = this.partiesBeforeYou;
    data['business_name'] = this.businessName;
    data['available_time_slots'] = this.availableTimeSlots;
    data['minimum_wait_time'] = this.minimumWaitTime;
    data['waitlist_id'] = this.waitlistId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['user_id'] = this.userId;
    data['waitlist_status'] = this.waitlistStatus;
    data['booked_slot'] = this.bookedSlot;
    data['no_of_person'] = this.noOfPerson;
    data['business_id'] = this.businessId;
    data['contact'] = this.contact;
    return data;
  }
}
