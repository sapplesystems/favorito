class appointListModel {
  String status;
  String message;
  int countPerSlot;
  int slotLenght;
  String starttime;
  String endtime;
  List<Slots> slots;

  appointListModel(
      {this.status,
        this.message,
        this.countPerSlot,
        this.slotLenght,
        this.starttime,
        this.endtime,
        this.slots});

  appointListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    countPerSlot = json['count_per_slot'];
    slotLenght = json['slot_lenght'];
    starttime = json['starttime'];
    endtime = json['endtime'];
    if (json['slots'] != null) {
      slots = new List<Slots>();
      json['slots'].forEach((v) {
        slots.add(new Slots.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['count_per_slot'] = this.countPerSlot;
    data['slot_lenght'] = this.slotLenght;
    data['starttime'] = this.starttime;
    data['endtime'] = this.endtime;
    if (this.slots != null) {
      data['slots'] = this.slots.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Slots {
  String slotStart;
  String slotEnd;
  List<SlotData> slotData;

  Slots({this.slotStart, this.slotEnd, this.slotData});

  Slots.fromJson(Map<String, dynamic> json) {
    slotStart = json['slot_start'];
    slotEnd = json['slot_end'];
    if (json['slot_data'] != null) {
      slotData = new List<SlotData>();
      json['slot_data'].forEach((v) {
        slotData.add(new SlotData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slot_start'] = this.slotStart;
    data['slot_end'] = this.slotEnd;
    if (this.slotData != null) {
      data['slot_data'] = this.slotData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SlotData {
  int id;
  String name;
  String contact;
  String personName;
  String serviceName;
  String specialNotes;
  String createdDate;
  String createdTime;

  SlotData(
      {this.id,
        this.name,
        this.contact,
        this.personName,
        this.serviceName,
        this.specialNotes,
        this.createdDate,
        this.createdTime});

  SlotData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    contact = json['contact'];
    personName = json['person_name'];
    serviceName = json['service_name'];
    specialNotes = json['special_notes'];
    createdDate = json['created_date'];
    createdTime = json['created_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['contact'] = this.contact;
    data['person_name'] = this.personName;
    data['service_name'] = this.serviceName;
    data['special_notes'] = this.specialNotes;
    data['created_date'] = this.createdDate;
    data['created_time'] = this.createdTime;
    return data;
  }
}

