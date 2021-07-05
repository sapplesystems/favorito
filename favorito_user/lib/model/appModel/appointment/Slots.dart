class Slots {
  String startTime;
  String endTime;

  Slots({this.startTime, this.endTime});

  Slots.fromJson(Map json) {
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map toJson() {
    final Map data = new Map();
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    return data;
  }
}