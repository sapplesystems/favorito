class MenuSettingModel {
  String status;
  String message;
  Data data;

  MenuSettingModel({this.status, this.message, this.data});

  MenuSettingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int acceptingOrder;
  String takeAwayStartTime;
  String takeAwayEndTime;
  int takeAwayMinimumBill;
  int takeAwayPackagingCharge;
  String dineInStartTime;
  String dineInEndTime;
  String deliveryStartTime;
  String deliveryEndTime;
  int deliveryMiniumBill;
  int deliveryPackagingCharge;
  int takeAway;
  int dineIn;
  int delivery;

  Data(
      {this.acceptingOrder,
      this.takeAwayStartTime,
      this.takeAwayEndTime,
      this.takeAwayMinimumBill,
      this.takeAwayPackagingCharge,
      this.dineInStartTime,
      this.dineInEndTime,
      this.deliveryStartTime,
      this.deliveryEndTime,
      this.deliveryMiniumBill,
      this.deliveryPackagingCharge,
      this.takeAway,
      this.dineIn,
      this.delivery});

  Data.fromJson(Map<String, dynamic> json) {
    acceptingOrder = json['accepting_order'];
    takeAwayStartTime = json['take_away_start_time'];
    takeAwayEndTime = json['take_away_end_time'];
    takeAwayMinimumBill = json['take_away_minimum_bill'];
    takeAwayPackagingCharge = json['take_away_packaging_charge'];
    dineInStartTime = json['dine_in_start_time'];
    dineInEndTime = json['dine_in_end_time'];
    deliveryStartTime = json['delivery_start_time'];
    deliveryEndTime = json['delivery_end_time'];
    deliveryMiniumBill = json['delivery_minium_bill'];
    deliveryPackagingCharge = json['delivery_packaging_charge'];
    takeAway = json['take_away'];
    dineIn = json['dine_in'];
    delivery = json['delivery'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accepting_order'] = this.acceptingOrder;
    data['take_away_start_time'] = this.takeAwayStartTime;
    data['take_away_end_time'] = this.takeAwayEndTime;
    data['take_away_minimum_bill'] = this.takeAwayMinimumBill;
    data['take_away_packaging_charge'] = this.takeAwayPackagingCharge;
    data['dine_in_start_time'] = this.dineInStartTime;
    data['dine_in_end_time'] = this.dineInEndTime;
    data['delivery_start_time'] = this.deliveryStartTime;
    data['delivery_end_time'] = this.deliveryEndTime;
    data['delivery_minium_bill'] = this.deliveryMiniumBill;
    data['delivery_packaging_charge'] = this.deliveryPackagingCharge;
    data['take_away'] = this.takeAway ?? false;
    data['dine_in'] = this.dineIn;
    data['delivery'] = this.delivery;
    return data;
  }
}
