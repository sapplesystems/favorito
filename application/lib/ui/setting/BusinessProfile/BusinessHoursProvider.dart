import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class BusinessHoursProvider extends ChangeNotifier {
  final dd1 = GlobalKey<DropdownSearchState<String>>();
  TextEditingController controller = TextEditingController();
  BusinessHoursProvider() {
    // dd1.currentState.changeSelectedItem("Select Hours");
  }
  Map<String, String> selecteddayList = {};

  void selectWorkingHours(String _val) {
    controller.text = _val;
    dd1.currentState.changeSelectedItem(_val);
    notifyListeners();
  }

  String getSelectWorkingHours() => controller.text ?? "Select Hours";
}
