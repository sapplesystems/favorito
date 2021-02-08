import 'package:Favorito/model/business/BusinessProfileModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:flutter/material.dart';

class BusinessHoursProvider extends ChangeNotifier {
  TextEditingController controller = TextEditingController();
  BusinessHoursProvider() {
    // dd1.currentState.changeSelectedItem("Select Hours");
  }
  Map<String, String> selecteddayList = {};

  Map<String, String> temp = {};
  Future<void> getData() async {
    await WebService.funGetBusinessWorkingHours().then((value) {
      if (value.status == 'success') {
        selecteddayList.clear();
        for (int _i = 0; _i < value.data.length; _i++)
          selecteddayList[(value.data.toList())[_i].day] =
              "${(value.data.toList())[_i].startHours}-${(value.data.toList())[_i].endHours}";
      }
    });
  }

  Future<void> setData() async {
    List<Map<String, String>> h = [];
    for (int i = 0; i < selecteddayList.keys.toList().length; i++) {
      Map<String, String> m = Map<String, String>();

      m['business_days'] = selecteddayList.keys.toList()[i];
      m['business_start_hours'] =
          (selecteddayList[selecteddayList.keys.toList()[i]].split('-')[0])
              .substring(0, 5);
      m['business_end_hours'] =
          (selecteddayList[selecteddayList.keys.toList()[i]].split('-')[1])
              .substring(0, 5);
      h.add(m);
    }
    print("hhhhl:${h.toString()}");
    Map map = {"business_hours": h};
    await WebService.funSetBusinessWorkingHours(map).then((value) {
      if (value.status == 'success') {
        selecteddayList.clear();
        for (int _i = 0; _i < value.data.length; _i++)
          selecteddayList[(value.data.toList())[_i].day] =
              "${(value.data.toList())[_i].startHours}-${(value.data.toList())[_i].endHours}";
      }
      notifyListeners();
    });
  }

  void refresh() {
    notifyListeners();
  }
}
