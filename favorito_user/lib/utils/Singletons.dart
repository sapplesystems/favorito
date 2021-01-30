import 'package:favorito_user/model/appModel/Menu/MenuItemModel.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class BasketControllers extends ChangeNotifier {
  static List<MenuItemModel> list = List<MenuItemModel>();

  void addDataToList(MenuItemModel data) {
    list.add(data);
  }

  String getTotelPrice() {
    double totel = 0.0;
    for (var v in getMyObjectsList()) {
      totel = totel + (v.quantity * v.price);
    }
    return totel.toString();
  }

  List getMyObjectsList() {
    return list;
  }
}
