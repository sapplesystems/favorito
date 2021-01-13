import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/Menu/MenuItemBaseModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/OnlineMenu/MenuItem.dart';
import 'package:favorito_user/ui/OnlineMenu/RequestData.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:favorito_user/utils/MyString.dart';

class MenuPages extends StatefulWidget {
  CatItemReq catItemReq;
  var isVeg;
  MenuPages({this.catItemReq, this.isVeg});
  @override
  _MenuPagesState createState() => _MenuPagesState();
}

class _MenuPagesState extends State<MenuPages> {
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
          "business_id": widget.catItemReq.id.toString(),
          "category_id": widget.catItemReq.cat.toString(),
          "filter": {"only_veg": widget.isVeg.toString()}
        }),
        builder:
            (BuildContext context, AsyncSnapshot<MenuItemBaseModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: Text(loading));
          else if (snapshot.hasError)
            return Center(child: Text(wentWrong));
          else {
            for (int a = 0; a < snapshot.data.data.length; a++) {
              print("ResponseIs:${snapshot.data.data[a].type}");
            }
            return snapshot?.data?.data?.length == 0
                ? Center(
                    child: Text(foodNotAvailable),
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
