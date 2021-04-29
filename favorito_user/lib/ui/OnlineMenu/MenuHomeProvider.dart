import 'package:favorito_user/model/appModel/Business/Category.dart';
import 'package:favorito_user/model/appModel/Menu/CustomizationModel.dart';
import 'package:favorito_user/model/appModel/Menu/MenuItemBaseModel.dart';
import 'package:favorito_user/model/appModel/Menu/MenuItemModel.dart';
import 'package:favorito_user/model/appModel/Menu/MenuTabModel.dart';
import 'package:favorito_user/model/appModel/Menu/order/ModelOption.dart';
import 'package:favorito_user/model/appModel/Menu/order/OptionsModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/OnlineMenu/MenuPages.dart';
import 'package:favorito_user/ui/OnlineMenu/RequestData.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class MenuHomeProvider extends ChangeNotifier {
  static List<MenuItemModel> _listItem = [];
  static List<OptionsModel> _listOpt = [];
  List<MenuItemModel> bucket = [];
  ModelOption modelOption = ModelOption();
  MenuTabModel menuTabModel = MenuTabModel();
  CatItem catItems = CatItem();
  String _businessId;
  String _businessName;
  Widget pages;
  List<Category> cat = [];
  bool isVegFilter = false;
  String txt = '';
  bool _getisFoody = false;
  Map<int, List<int>> selectedCustomizetionId = Map();
  MenuHomeProvider() {
    catItems.isVeg = catItems.isVeg ?? false;
  }
  CustomizationItemModel customizationItemModel = CustomizationItemModel();

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

  setBusinessDetail(String id, String name) {
    catItems.buId = id;
    catItems.cat = name;
    print("fdd");
    pages = MenuPage();
  }

  setBusinessIdName(String id, String name) {
    _businessId = id;
    _businessName = name;
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

  getBusinessId() => _businessId;
  getBusinessName() => _businessName;

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

// Provider.of<BusinessProfileProvider>(context, listen: true);
  menuTabGet() async {
    print("businessId:${_businessId}");
    await APIManager.menuTabGet({'business_id': _businessId}).then((value) {
      menuTabModel = value;
      setCategories(value.data);
    });
  }

  Future<MenuItemBaseModel> getMenuItem() async {
    print(" getBusinessDetail().cat:${getBusinessDetail().cat}");
    return await APIManager.menuTabItemGet({
      "business_id": _businessId,
      "category_id": getBusinessDetail().cat ?? 0,
      "keyword": getSearchText(),
      "filter": {"sd": "${getBusinessDetail().isVeg ? 1 : 0}"}
    });
  }

  //options this will provide payoptions as well
  userOrderCreateVerbose() async {
    print("businessId:$_businessId");
    await APIManager.userOrderCreateVerbose({'business_id': _businessId})
        .then((value) {
      if (value.status == 'success') {
        modelOption = value;
        print('eee${value.data.paymentType.length}');
      }
    });
    // notifyListeners();
  }

  getModelOption() => modelOption;
  checkisFoody() async {
    await APIManager.menusIsFoodItem({'business_id': _businessId})
        .then((value) {
      if (value.status == 'success') {
        setisFoody(value.data[0].isFood == 1);
        notifyListeners();
      }
    });
  }

  getisFoody() => _getisFoody;
  setisFoody(bool _val) {
    _getisFoody = _val;
    notifyListeners();
  }

  menuTabItemGetCustomization(String _itenId) async {
    // await APIManager.menuTabItemGetCustomization({'item_id': _itenId})
    //     .then((value) {
    //   if (value.status == 'success') {
    //     customizationItemModel = value;
    //   }
    // });
  }

  getCustomizations() => customizationItemModel.data;

  cutiomizationSelection(int _index, int _a) {
    // Map<int, List<int>> _map = Map();
    if (selectedCustomizetionId.keys
        .contains(customizationItemModel.data[_index].attributeId))
      // _map[customizationItemModel.data[_index].attributeId] = _map[customizationItemModel.data[_index].attributeId].contains(customizationItemModel.data[_index].customizationOption[_a].optionId)
      //   customizationItemModel.data[_index].customizationOption[_a].optionId
      // ];
      // if (selectedCustomizetionId.contains(
      //     customizationItemModel.data[_index].customizationOption[_a].optionId))
      //   selectedCustomizetionId.remove(
      //       customizationItemModel.data[_index].customizationOption[_a].optionId);
      // else
      //   selectedCustomizetionId.add(
      //       customizationItemModel.data[_index].customizationOption[_a].optionId);
      notifyListeners();
  }

  void addItemToList(MenuItemModel _data) {
    _listItem.add(_data);
  }

  void addOptionsToList(OptionsModel _data, bool _val) {
    (_val ?? false) ? _listOpt.add(_data) : _listOpt.remove(_data);
    notifyListeners();
  }

  double allItemPrices() {
    double _temp = 0;
    for (var _v in getMyObjectsList()) {
      _temp = _temp + (_v.quantity * _v.price);
    }
    notifyListeners();
    return _temp;
  }

  double allOptionsPrice() {
    double _temp = 0.0;
    for (var _v in getOptionsList()) {
      _temp = _temp + double.parse(_v.price);
    }
    notifyListeners();
    return _temp;
  }

  List getMyObjectsList() => _listItem;
  List getOptionsList() => _listOpt;
  double allPrice() => allItemPrices() + allOptionsPrice();
}
