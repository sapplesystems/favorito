import 'package:Favorito/model/booking/SlotData.dart';

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
