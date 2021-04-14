class BookingOrAppointmentDataModel {
  int id;
  int userId;
  String name;
  String businessId;
  String businessName;
  String businessPhone;
  String status;
  var avgRating;
  int noOfPerson;
  String review;
  String occasion;
  String serviceName;
  String servicePersonName;
  int slotLength;
  int walkIn;
  String specialNotes;
  String createdDatetime;
  int isBooking;

  BookingOrAppointmentDataModel(
      {this.id,
      this.userId,
        this.name,
      this.businessId,
      this.businessName,
      this.businessPhone,
      this.status,
      this.avgRating,
      this.noOfPerson,
      this.review,
      this.occasion,
      this.serviceName,
      this.servicePersonName,
      this.slotLength,
      this.walkIn,
      this.specialNotes,
      this.createdDatetime,
      this.isBooking});

  BookingOrAppointmentDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    businessId = json['business_id'];
    businessName = json['business_name'];
    businessPhone = json['business_phone'];
    status = json['status'];
    avgRating = json['avg_rating'];
    noOfPerson = json['no_of_person'];
    review = json['review'];
    occasion = json['occasion'];
    serviceName = json['serviceName'];
    servicePersonName = json['servicePersonName'];
    slotLength = json['slot_length'];
    walkIn = json['walk_in'];
    specialNotes = json['special_notes'];
    createdDatetime = json['created_datetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['business_id'] = this.businessId;
    data['business_name'] = this.businessName;
    data['business_phone'] = this.businessPhone;
    data['status'] = this.status;
    data['avg_rating'] = this.avgRating;
    data['no_of_person'] = this.noOfPerson;
    data['review'] = this.review;
    data['occasion'] = this.occasion;
    data['serviceName'] = this.serviceName;
    data['servicePersonName'] = this.servicePersonName;
    data['slot_length'] = this.slotLength;
    data['walk_in'] = this.walkIn;
    data['special_notes'] = this.specialNotes;
    data['created_datetime'] = this.createdDatetime;
    return data;
  }
}
