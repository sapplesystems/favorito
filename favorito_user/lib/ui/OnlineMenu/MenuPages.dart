import 'package:favorito_user/Providers/MenuHomeProvider.dart';
import 'package:favorito_user/model/appModel/Menu/MenuItemBaseModel.dart';
import 'package:favorito_user/ui/OnlineMenu/MenuItem.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import '../../utils/myString.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var bcTrue = Provider.of<BasketControllers>(context, listen: true);
    var vaTrue = Provider.of<MenuHomeProvider>(context, listen: true);

    return FutureBuilder<MenuItemBaseModel>(
        future: vaTrue.getMenuItem(),
        builder:
            (BuildContext context, AsyncSnapshot<MenuItemBaseModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: Text(loading));
          else if (snapshot.hasError)
            return Center(child: Text(wentWrong));
          else {
            return snapshot?.data?.data?.length == 0
                ? Center(
                    child: Text(dataNotAvailable),
                  )
                : ListView.builder(
                    itemCount: snapshot.data.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return MenuItems(
                        data: snapshot.data.data[index],
                        isRefresh: false,
                        callBack: () {},
                      );
                    });
          }
        });
  }
}
