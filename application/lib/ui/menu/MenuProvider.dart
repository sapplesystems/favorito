import 'package:Favorito/Provider/BaseProvider.dart';
import 'package:Favorito/model/menu/Category.dart';
import 'package:Favorito/model/menu/MenuBaseModel.dart';
import 'package:Favorito/model/menu/MenuSettingModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/RIKeys.dart';
import 'package:flutter/material.dart';

class MenuProvider extends BaseProvider {
  final mySearchEditController = TextEditingController();
  int _callSwitcherId = 0;
  Map dataMap = Map();
  List<TextEditingController> controller = [
    for (int _i = 0; _i < 10; _i++) TextEditingController()
  ];
  MenuSettingModel menuSettingModel = MenuSettingModel();
  MenuBaseModel menuBaseModel = MenuBaseModel();
  bool takeAway = false;
  bool dineIn = false;
  bool delivery = false;
  bool acceptingOrder = false;
  bool needSave = false;
  initcall() {
    controller.map((e) => e.text = "00");
  }

  void getMenuList() async {
    await WebService.funMenuList().then((value) {
      menuBaseModel = value;
      dataMap.clear();
      for (var key in value.data) {
        dataMap['${key.categoryName} | ${key.categoryId} | ${key.outOfStock}'] =
            key.items;
        print('title1:${key.items}');
      }

      notifyListeners();
    });
  }

  callerIdSet(int _id) {
    _callSwitcherId = _id;
    notifyListeners();
  }

  callerIdget() => _callSwitcherId;
  Category getCatData() => menuBaseModel.data[menuBaseModel.data
      .indexWhere((element) => element.categoryId == _callSwitcherId)];

  funMenuCatList() async {
    await WebService.funMenuCatList({"category_id": _callSwitcherId})
        .then((value) {
      getMenuList();
    });
  }

  funMenuCatEdit() async {
    Map _map = {
      "id": _callSwitcherId,
      'out_of_stock': getCatData().outOfStock == 1 ? 0 : 1,
    };
    print("Data is :${_map}");
    await WebService.funMenuCatEdit(_map).then((value) {
      if (value.status == 'success') {
        menuBaseModel
            .data[menuBaseModel.data
                .indexWhere((element) => element.categoryId == _callSwitcherId)]
            .outOfStock = (menuBaseModel.data[menuBaseModel.data.indexWhere(
                        (element) => element.categoryId == _callSwitcherId)])
                    .outOfStock ==
                1
            ? 0
            : 1;
        notifyListeners();
      }
    });
  }

  menuSettingsGetServiceCall() async {
    await WebService.funMenuSetting().then((value) {
      if (value.status == 'success') {
        menuSettingModel = value;
        print('ssss${value.data.takeAwayStartTime}');
        controller[0].text = value.data.takeAwayStartTime?.substring(0, 5);
        controller[1].text = value.data.takeAwayEndTime?.substring(0, 5);
        takeAway = value.data.takeAway == 1;
        dineIn = value.data.dineIn == 1;
        delivery = value.data.delivery == 1;
        controller[2].text = value.data.takeAwayMinimumBill.toString();
        controller[3].text = value.data.takeAwayPackagingCharge.toString();
        controller[4].text = value.data.dineInStartTime?.substring(0, 5);
        controller[5].text = value.data.dineInEndTime?.substring(0, 5);
        controller[6].text = value.data.deliveryStartTime?.substring(0, 5);
        controller[7].text = value.data.deliveryEndTime?.substring(0, 5);
        controller[8].text = value.data.deliveryMiniumBill.toString();
        controller[9].text = value.data.deliveryPackagingCharge.toString();
        notifyListeners();
      }
    });
  }

  saveSettingServiceCall() async {
    Map _map = {
      "accepting_order": acceptingOrder ? 1 : 0,
      "take_away": takeAway ? 1 : 0,
      "take_away_start_time": controller[0].text,
      "take_away_end_time": controller[1].text,
      "take_away_minimum_bill": controller[2].text,
      "take_away_packaging_charge": controller[3].text,
      "dine_in": dineIn ? 1 : 0,
      "dine_in_start_time": controller[4].text,
      "dine_in_end_time": controller[5].text,
      "delivery": delivery ? 1 : 0,
      "delivery_start_time": controller[6].text,
      "delivery_end_time": controller[7].text,
      "delivery_minium_bill": controller[8].text,
      "delivery_packaging_charge": controller[9].text
    };
    print("_map:${_map.toString()}");
    await WebService.funMenuSettingUpdate(_map).then((value) {
      this.snackBar(value.message, RIKeys.josKeys17);
      if (value.status == 'success') {
        Navigator.pop(RIKeys.josKeys16.currentContext);
        setNeedSave(false);
      }
    });
  }

  getTimePicker(int _index, context, localizations) {
    TimeOfDay timeOfDay;
    if (controller[_index].text != null) {
      var _s = controller[_index].text;

      timeOfDay = TimeOfDay(
          hour: int.parse(_s.split(":")[0]),
          minute: int.parse(_s.split(":")[1]));
    } else {
      timeOfDay = TimeOfDay.now();
    }
    showTimePicker(
      context: context,
      initialTime: timeOfDay,
      initialEntryMode: TimePickerEntryMode.input,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child);
      },
    ).then((value) {
      controller[_index].text =
          localizations.formatTimeOfDay(value, alwaysUse24HourFormat: true);
      setNeedSave(true);
    });
  }

  takeawayOnOff() {
    takeAway = !takeAway;
    setNeedSave(true);
  }

  dineInOnOff() {
    dineIn = !dineIn;
    setNeedSave(true);
  }

  deliveryOnOff() {
    delivery = !delivery;
    setNeedSave(true);
  }

  acceptingOrderOnOff() {
    acceptingOrder = !acceptingOrder;
    setNeedSave(true);
  }

  setNeedSave(bool _val) {
    needSave = _val;
    notifyListeners();
  }
}
