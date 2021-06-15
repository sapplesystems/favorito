import 'package:favorito_user/model/appModel/Menu/MenuItemModel.dart';
import 'package:favorito_user/ui/OnlineMenu/MenuHomeProvider.dart';
import 'package:favorito_user/ui/OnlineMenu/MenuItem.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import '../../utils/myString.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MenuHomeProvider>(
      builder: (context, data, child) {
        // List value = data.getMenuItemBaseModel()?.data;
        return (data.menuItemBaseModel.data.length == 0)
            ? Center(
                child: Text(menuItemNotAvailable,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontWeight: FontWeight.w300, fontSize: 12)))
            : ListView.builder(
                itemCount: data.menuItemBaseModel.data.length,
                itemBuilder: (BuildContext context, int index) {
                  MenuItemModel _v = data.menuItemBaseModel.data[index];
                  print(
                      '_menuItemBaseModel:${data.menuItemBaseModel.data.length}');
                  return MenuItems(
                    data: _v,
                    isRefresh: false,
                    callBack: () {
                      data.notifyListeners();
                    },
                  );
                });
      },
    );
  }
}
