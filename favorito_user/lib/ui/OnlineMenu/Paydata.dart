import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter/material.dart';

class PayData {
  int id;
  String title;
  bool selected;
  Color colors;

  PayData({this.id, this.selected, this.title, this.colors});
  static List<PayData> getPayData() {
    return [
      PayData(id: 0, selected: false, title: "Cash"),
      PayData(id: 1, selected: false, title: "Card"),
      PayData(id: 2, selected: false, title: "online")
    ];
  }
}
