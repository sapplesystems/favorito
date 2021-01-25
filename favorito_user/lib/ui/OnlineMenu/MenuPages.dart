import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/Menu/MenuItemBaseModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/OnlineMenu/MenuItem.dart';
import 'package:favorito_user/ui/OnlineMenu/RequestData.dart';
import 'package:favorito_user/utils/Singletons.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../../utils/myString.dart';

class MenuPage extends StatefulWidget {
  Basket basket = Basket();
  CatItem catItem;

  MenuPage({this.catItem});
  @override
  MenuPagesState createState() => basket.getMenuPagesState();
}

class MenuPagesState extends State<MenuPage> {
  SizeManager sm;
  refresh() {
    setState(() {});
  }

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
