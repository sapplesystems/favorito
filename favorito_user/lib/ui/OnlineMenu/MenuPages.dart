import 'package:favorito_user/Providers/MenuHomeProvider.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/Menu/MenuItemBaseModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/OnlineMenu/MenuItem.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import '../../utils/myString.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("page reloaded");
    // SizeManager sm = SizeManager(context);
    var va = Provider.of<MenuHomeProvider>(context, listen: false);

    return FutureBuilder<MenuItemBaseModel>(
        future: APIManager.menuTabItemGet({
          "business_id": va.businessId,
          "category_id": va.getBusinessDetail().cat ?? 0,
          "keyword": va.getBusinessDetail().txt,
          "filter": {"only_veg": "${va.getBusinessDetail().isVeg ? 1 : 0}"}
        }),
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
                      return MenuItem(
                        data: snapshot.data.data[index],
                        isRefresh: false,
                        callBack: () {},
                      );
                    });
          }
        });
  }
}
