import 'package:favorito_user/model/appModel/Menu/MenuItemModel.dart';
import 'package:favorito_user/model/appModel/Menu/order/OptionsModel.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class BasketControllers extends ChangeNotifier {
  static List<MenuItemModel> _listItem = List<MenuItemModel>();
  static List<OptionsModel> _listOpt = List<OptionsModel>();
  void addItemToList(MenuItemModel _data) {
    _listItem.add(_data);
  }

  void addOptionsToList(OptionsModel _data, bool _val) {
    (_val ?? false) ? _listOpt.add(_data) : _listOpt.remove(_data);
    notifyListeners();
  }

  double allItemPrices() {
    double _temp = 0;
    for (var _v in getMyObjectsList()) {
      _temp = _temp + (_v.quantity * _v.price);
    }
    notifyListeners();
    return _temp;
  }

  double allOptionsPrice() {
    double _temp = 0.0;
    for (var _v in getOptionsList()) {
      _temp = _temp + double.parse(_v.price);
    }
    notifyListeners();
    return _temp;
  }

  List getMyObjectsList() => _listItem;
  List getOptionsList() => _listOpt;
  double allPrice() => allItemPrices() + allOptionsPrice();
}
