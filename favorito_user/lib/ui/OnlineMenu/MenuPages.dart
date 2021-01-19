import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/Menu/MenuItemBaseModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/OnlineMenu/MenuItem.dart';
import 'package:favorito_user/ui/OnlineMenu/RequestData.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:favorito_user/utils/MyString.dart';

class MenuPage extends StatefulWidget {
  CatItem catItem;
  MenuPage({this.catItem});
  @override
  _MenuPagesState createState() => _MenuPagesState();
}

class _MenuPagesState extends State<MenuPage> {
  SizeManager sm;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);

    return FutureBuilder<MenuItemBaseModel>(
        future: APIManager.menuTabItemGet({
          "business_id": widget.catItem.buId,
          "category_id": widget.catItem.cat.toString(),
          "keyword": widget.catItem.txt,
          "filter": {"only_veg": "${widget.catItem.isVeg ? 1 : 0}"}
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
                      return MenuItem(data: snapshot.data.data[index]);
                    });
          }
        });
  }
}

// ListView(
//       children: [for (int i = 0; i < 100; i++) ],
//     )
