import 'package:favorito_user/model/appModel/Business/Category.dart';
import 'package:favorito_user/model/appModel/Menu/MenuItemBaseModel.dart';
import 'package:favorito_user/model/appModel/Menu/MenuItemModel.dart';
import 'package:favorito_user/model/appModel/Menu/MenuTabModel.dart';
import 'package:favorito_user/model/appModel/Menu/order/ModelOption.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/OnlineMenu/MenuPages.dart';
import 'package:favorito_user/ui/OnlineMenu/RequestData.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class MenuHomeProvider extends ChangeNotifier {
  List<MenuItemModel> bucket = [];
  ModelOption modelOption = ModelOption();
  MenuTabModel menuTabModel = MenuTabModel();
  CatItem catItems = CatItem();
  String businessId;
  String businessName;
  Widget pages;
  List<Category> cat = [];
  bool isVegFilter = false;
  String txt = '';
  MenuHomeProvider() {
    catItems.isVeg = catItems.isVeg ?? false;
    getMenuData();
  }

  void addbucket(MenuItemModel data) {
    bucket.add(data);
    print("bucket:${bucket.length}");
  }

  String getTotelPrice() {
    double totel = 0.0;
    for (var v in getBucket()) {
      totel = totel + (v.quantity * v.price);
    }
    return totel.toString();
  }

  List getBucket() => bucket;

  setBusinessDetail(String id, String name, String txt) {
    catItems.buId = id;
    catItems.cat = name;
    pages = MenuPage();
  }

  setSearchText(String txt) {
    txt = txt;
  }

  getSearchText() => txt;

  setIsVeg(bool _val) {
    isVegFilter = _val;
    notifyListeners();
  }

  bool getIsVeg() => isVegFilter;

  CatItem getBusinessDetail() => catItems;

  setBusinessIdName(String id, String name) {
    businessId = id;
    businessName = name;
  }

  getBusinessId() => businessId;
  getBusinessName() => businessName;

  categorySelector(int index) {
    catItems.selectedCatId = index;
    catItems.cat = cat[index].id.toString();
    pages = MenuPage();
  }

  List<Category> getCategories() => cat;

  void setCategories(List<Category> list) {
    if (cat.isEmpty) {
      cat.add(Category(id: 0, categoryName: 'All'));
      cat.addAll(list);
      categorySelector(0);
      notifyListeners();
    }
  }

  CatItem getCatItems() => catItems;

  bool categoryIsActive(String catId) {
    bool val = true;
    for (var v in getCategories()) {
      if (v.id.toString() == catId) {
        if (v.outOfStock == 1) val = false;
      }
    }
    return val;
  }

  getMenuData() async {
    print("businessId:$businessId");
    await APIManager.menuTabGet({'business_id': businessId}).then((value) {
      menuTabModel = value;
      setCategories(value.data);
    });
  }

  Future<MenuItemBaseModel> getMenuItem() async {
    print(" getBusinessDetail().cat:${getBusinessDetail().cat}");
    return await APIManager.menuTabItemGet({
      "business_id": businessId,
      "category_id": getBusinessDetail().cat ?? 0,
      "keyword": getSearchText(),
      "filter": {"only_veg": "${getBusinessDetail().isVeg ? 1 : 0}"}
    });
  }

  //options
  userOrderCreateVerbose() async {
    print("businessId:$businessId");
    await APIManager.userOrderCreateVerbose({'business_id': businessId})
        .then((value) {
      if (value.status == 'success') {
        modelOption = value;
      }
    });
    // notifyListeners();
  }

  getModelOption() => modelOption;
}
