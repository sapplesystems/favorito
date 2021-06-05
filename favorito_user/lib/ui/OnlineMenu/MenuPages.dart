import 'package:favorito_user/model/appModel/Menu/MenuItemModel.dart';
import 'package:favorito_user/ui/OnlineMenu/MenuHomeProvider.dart';
import 'package:favorito_user/ui/OnlineMenu/MenuItem.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import '../../utils/myString.dart';

class MenuPage extends StatelessWidget {
  bool isFirst = true;
  @override
  Widget build(BuildContext context) {
    var vaTrue = Provider.of<MenuHomeProvider>(context, listen: true);
    List value = vaTrue.getMenuItemBaseModel()?.data;
    return (value.length == 0)
        ? Center(
            child: Text(menuItemNotAvailable,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.w300, fontSize: 12)))
        : ListView.builder(
            itemCount: value.length,
            itemBuilder: (BuildContext context, int index) {
              MenuItemModel _v = value[index];
              print('_menuItemBaseModel:${value.length}');
              return MenuItems(
                data: _v,
                isRefresh: false,
                callBack: () {
                  vaTrue.notifyListeners();
                },
              );
            });
  }
}
