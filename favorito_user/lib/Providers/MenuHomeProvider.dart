import 'package:favorito_user/model/appModel/Business/Category.dart';
import 'package:favorito_user/model/appModel/Menu/MenuItemBaseModel.dart';
import 'package:favorito_user/model/appModel/Menu/MenuTabModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/OnlineMenu/MenuPages.dart';
import 'package:favorito_user/ui/OnlineMenu/RequestData.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class MenuHomeProvider extends ChangeNotifier {
  MenuTabModel menuTabModel = MenuTabModel();
  CatItem catItems = CatItem();
  String businessId;
  String businessName;
  Widget pages;
  List<Category> cat = [];
  Category ca = Category();
  bool isVegFilter = false;
  String txt = '';
  MenuHomeProvider() {
    catItems.isVeg = catItems.isVeg ?? false;
  }

  setBusinessDetail(String id, String name) {
    print("aaaa1:${catItems.buId}:bbb:${catItems.cat}");
    catItems.buId = id;
    catItems.cat = name;
    pages = MenuPage();

    print("aaaa2:${catItems.buId}:bbb:${catItems.cat}");
    notifyListeners();
  }

  setIsVeg(bool _val) {
    isVegFilter = _val;
  }

  bool getIsVeg() => isVegFilter;

  CatItem getBusinessDetail() {
    return catItems;
  }

  setBusinessIdName(String id, String name) {
    businessId = id;
    businessName = name;
  }

  categorySelector(int index) {
    catItems.selectedCatId = index;
    catItems.cat = cat[index].id.toString();
    pages = MenuPage();
  }

  List<Category> getCategories() => cat;
  void setCategories(List<Category> list) {
    cat.clear();
    cat.addAll(list);
    notifyListeners();
  }

  CatItem getCatItems() => catItems;

  Future<MenuTabModel> getMenuData() async {
    print("businessId:$businessId");
    await APIManager.menuTabGet({'business_id': businessId}).then((value) {
      menuTabModel = value;
      setCategories(value.data);
    });
    return menuTabModel;
  }

  Future<MenuItemBaseModel> getMenuItem() async {
    return await APIManager.menuTabItemGet({
      "business_id": businessId,
      "category_id": getBusinessDetail().cat ?? 0,
      "keyword": getBusinessDetail().txt,
      "filter": {"only_veg": "${getBusinessDetail().isVeg ? 1 : 0}"}
    });
  }
}
