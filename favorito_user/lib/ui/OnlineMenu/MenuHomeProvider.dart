import 'package:favorito_user/Providers/BaseProvider.dart';
import 'package:favorito_user/model/appModel/Business/Category.dart';
import 'package:favorito_user/model/appModel/Menu/Customization.dart/CustomizationModel.dart';
import 'package:favorito_user/model/appModel/Menu/MenuItemBaseModel.dart';
import 'package:favorito_user/model/appModel/Menu/MenuItemModel.dart';
import 'package:favorito_user/model/appModel/Menu/MenuTabModel.dart';
import 'package:favorito_user/model/appModel/Menu/order/ModelOption.dart';
import 'package:favorito_user/model/appModel/Menu/order/OptionsModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/OnlineMenu/Paydata.dart';
import 'package:favorito_user/ui/OnlineMenu/RequestData.dart';
import 'package:favorito_user/utils/RIKeys.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class MenuHomeProvider extends BaseProvider {
  static List<MenuItemModel> _listItem = [];
  static List<OptionsModel> _listOpt = [];
  List<MenuItemModel> bucket = [];
  double customizationPrice = 0.0;
  ModelOption modelOption = ModelOption();
  MenuTabModel menuTabModel = MenuTabModel();
  CatItem catItems = CatItem();
  String _businessId;
  String _businessName;
  // Widget pages;
  List<Category> cat = [];
  bool isVegFilter = false;
  String txt = '';
  bool _getisFoody = false;
  Map<int, List<int>> selectedCustomizetionId = Map();
  MenuItemBaseModel menuItemBaseModel = MenuItemBaseModel();
  // CustomizationItemModel customizationItemModel = CustomizationItemModel();

  List<PayData> payDataList = [];
  List<OrderType> orderType = [];
  PayData selectedPayData;
  OrderType selectedOrderType;

  MenuHomeProvider() {
    // _businessId = 'KIR4WQ4N7KF697HRQ';
    catItems.isVeg = catItems.isVeg ?? false;
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

  setBusinessIdName(String id, String name) {
    _businessId = id;
    _businessName = name;
  }

  setSearchText(String _txt) {
    txt = _txt;
    getMenuItem();
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
    getMenuItem();
    // pages = MenuPage();
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

  menuTabGet() async {
    print("businessId1:${_businessId}");
    await APIManager.menuTabGet({'business_id': _businessId}).then((value) {
      menuTabModel = value;
      setCategories(value.data);
    });
  }

  Future<MenuItemBaseModel> getMenuItem() async {
    Map _map = {
      "business_id": _businessId,
      "category_id": '${catItems?.cat ?? 3}',
      "keyword": txt,
      "filter": {"sd": "${getBusinessDetail().isVeg ? 1 : 0}"}
    };
    print('_map${_map.toString()}');
    await APIManager.menuTabItemGet(_map).then((value) {
      if (value.status == 'success') {
        print(value.data.length);
        setMenuItemBaseModel(value);
        notifyListeners();
      }
    });
  }

  setMenuItemBaseModel(MenuItemBaseModel _val) {
    menuItemBaseModel = _val;
    notifyListeners();
  }

  // getMenuItemBaseModel() {
  //   print('_menuItemBaseModelq:${menuItemBaseModel.data.length}');
  //   return menuItemBaseModel;
  // }

  userOrderCreateVerbose() async {
    print("businessId2:$_businessId");
    await APIManager.userOrderCreateVerbose({'business_id': _businessId})
        .then((value) {
      if (value.status == 'success') {
        modelOption = value;
        orderType.clear();
        setPayData(value.data.paymentType);
        orderType.addAll(value.data.orderType);
        // print('eee${value.data.paymentType.length}');
      }
    });
  }

  getModelOption() => modelOption;
  checkisFoody() async {
    await APIManager.menusIsFoodItem({'business_id': _businessId})
        .then((value) {
      if (value.status == 'success') {
        setisFoody(value?.data[0]?.isFood == 1);
      }
    });
  }

  getisFoody() => _getisFoody;
  setisFoody(bool _val) {
    _getisFoody = _val;
    notifyListeners();
  }

  void addOptionsToList(OptionsModel _data, bool _val) {
    (_val ?? false) ? _listOpt.add(_data) : _listOpt.remove(_data);
    notifyListeners();
  }

  List getMyObjectsList() => _listItem;

  removeMyObjectsList(int _id) {
    _listItem.removeAt(_id);
    notifyListeners();
  }

  updateMyObjectsList(int _id) {
    int _i = _listItem.indexWhere((element) => element.id == _id);

    double _localprice = 0.0;
    for (var _v in _listItem[_i].customizationItemModel.data) {
      for (var _b in _v.customizationOption) {
        if (_b.isSelected) {
          _localprice =
              _localprice + double.parse(_v.attributePrice.toString());
          if (_v.multiSelection == 0) break;
        }
      }
    }
    _listItem[_i].itenCustomizationSum = _localprice.toString();
    print("sdsd${_listItem[_i].itenCustomizationSum}");
    // _listItem = customizationItemModel.data;

    allPrice();
    // customizationItemModel.data = [];
    notifyListeners();
  }

// 7533998990
// 8991
  double allPrice() {
    var totel = allItemPrices();
    // + allOptionsPrice();
    print('totel:${totel}');
    return totel;
  }

  double allItemPrices() {
    double groundTotel = 0.0;
    for (var _v in _listItem) {
      double _temp = 0;
      if (_v.customizationItemModel.data != null) {
        _v.itenCustomizationSum = '0.0';
        for (var _a in _v.customizationItemModel.data) {
          for (var _b in _a.customizationOption) {
            if (_b.isSelected == true) {
              _v.itenCustomizationSum =
                  '${double.parse(_v.itenCustomizationSum.toString()) + double.parse(_a.attributePrice.toString())}';
              if (_a.multiSelection == 0) break;
            }
          }
        }
        _temp =
            _v.quantity * (_v.price + double.parse(_v.itenCustomizationSum));
      }
      groundTotel = groundTotel + _temp;
    }
    print(groundTotel);
    return groundTotel;
  }

  void addItemToList(MenuItemModel _data) {
    _listItem.add(_data);
  }

  List getOptionsList() => _listOpt;

  menuItemCust(int _id) async {
    print('item id:$_id');
    Map _map = {'item_id': _id};
    await APIManager.menuItemCust(_map).then((value) {
      if (value.status == 'success')
        _listItem[_listItem.indexWhere((element) => element.id == _id)]
            .customizationItemModel = value;
      notifyListeners();
    });
  }

  CustomizationItemModel getCustomizationItemModel(_id) =>
      _listItem[_listItem.indexWhere((element) => element.id == _id)]
          .customizationItemModel;

  setSelectedPay(PayData payData) {
    selectedPayData = payData;
    notifyListeners();
  }

  setSelectedOrderType(OrderType orderType) {
    selectedOrderType = orderType;
    notifyListeners();
  }

  List<PayData> getPayData() => payDataList;

  void setPayData(List<String> _data) {
    print("ddd${_data.length}");
    payDataList.clear();

    for (int _i = 0; _i < _data.length; _i++) {
      payDataList.add(PayData(
        id: _i,
        selected: false,
        title: "${_data[_i]}",
      ));
    }
    setSelectedPay(payDataList[0]);
  }

  // userOrderCreate
  //
  callCustomizetion() async {
    Map _map = {
      "business_id": _businessId,
      "notes": "",
      "order_type": "3",
      "payment_type": selectedPayData.title,
      "category": [
        for (var _v in _listItem)
          {
            "category_id": _v.menuCategoryId.toString(),
            "category_item": [
              {
                "item_id": _v.id,
                "price": _v.price,
                "qty": _v.quantity,
                "tax": _v.tax,
                "attributes": [
                  for (var _vv in _v?.customizationItemModel?.data)
                    {
                      "attribute_id": _vv?.attributeId,
                      "option_id": _vv?.getSelectedOptions(),
                      "price": _vv.attributePrice
                    }
                ]
              }
            ]
          }
      ]
    };
    print('_map:${_map.toString()}');
    await APIManager.userOrderCreate(_map).then((value) {
      this.snackBar(value.message, RIKeys.josKeys25);
      if (value.status == 'success') {
        Navigator.pop(RIKeys.josKeys25.currentContext);
        Navigator.pop(RIKeys.josKeys25.currentContext);
        Navigator.of(RIKeys.josKeys25.currentContext).pushNamed('/orderHome');
        // print("success Done");
      }
    });
  }

  clearAll() {
    _listItem.clear();
  }
}
