import 'package:favorito_user/model/appModel/Menu/MenuItemModel.dart';

class Basket {
  static List<MenuItemModel> list = List<MenuItemModel>();
  // static FabState fabState = FabState();
  // static MenuPagesState menuPagesState = MenuPagesState();
  // static FloatingActionButtonsState floatingActionButtonsState =
  //     FloatingActionButtonsState();
  void addDataToList(MenuItemModel data) {
    list.add(data);
  }

  // void fabStateRefresh() {
  //   fabState.refresh();
  // }

  // FabState getFabState() {
  //   return fabState;
  // }

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

  // FloatingActionButtonsState getFloatingActionButtonsState() {
  //   return floatingActionButtonsState;
  // }

  // void floatingActionButtonsRefresh() {
  //   floatingActionButtonsState.refresh();
  // }

  // MenuPagesState getMenuPagesState() {
  //   return menuPagesState;
  // }

  // void menuPagesRefresh() {
  //   menuPagesState.refresh();
  // }
}
