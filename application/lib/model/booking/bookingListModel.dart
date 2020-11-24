import 'package:Favorito/model/booking/Slots.dart';

class bookingListModel {
  String status;
  String message;
  int slotLenght;
  String starttime;
  String endtime;
  List<Slots> slots;
  int count_per_slot;

  bookingListModel(
      {this.status,
      this.message,
      this.slotLenght,
      this.starttime,
      this.endtime,
      this.slots,
      this.count_per_slot});

  bookingListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    slotLenght = json['slot_lenght'];
    starttime = json['starttime'];
    endtime = json['endtime'];
    if (json['slots'] != null) {
      slots = new List<Slots>();
      json['slots'].forEach((v) {
        slots.add(new Slots.fromJson(v));
      });
    }
    count_per_slot = json['count_per_slot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['slot_lenght'] = this.slotLenght;
    data['starttime'] = this.starttime;
    data['endtime'] = this.endtime;
    if (this.slots != null) {
      data['slots'] = this.slots.map((v) => v.toJson()).toList();
    }
    data['count_per_slot'] = this.count_per_slot;
    return data;
  }
}
