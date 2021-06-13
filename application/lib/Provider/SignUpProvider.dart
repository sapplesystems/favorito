import 'dart:async';

import 'package:Favorito/model/CatListModel.dart';
import 'package:Favorito/model/busyListModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/Regexer.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class SignUpProvider extends ChangeNotifier {
  static final categoryKey = GlobalKey<DropdownSearchState<String>>();
  static final categoryKey1 = GlobalKey<DropdownSearchState<String>>();
  static final categoryKey2 = GlobalKey<DropdownSearchState<String>>();
  static bool signCler = true;
  String mailError;
  String passError;
  String passError1;
  Timer _debounce;
  SignUpProvider() {
    getCategory();
    getBusiness();
    for (int _i = 0; _i < 8; _i++) {
      controller.add(TextEditingController());
      error.add(null);
    }

    controller[5].addListener(_onSearchChanged);
  }
  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(Duration(seconds: 1), () {
      if (controller[5].text != "") {
        validatemail();
      }
    });
  }

  BuildContext context;
  // ProgressDialog pr;
  List<TextEditingController> controller = [];
  List<String> error = [];
  List<catData> _catdata = [];
  List<busData> _busdata = [];
  String _businessName;
  String _categoryName;
  int _typeId = 1;
  int _categoryId = 0;
  bool catvisib = false;
  bool _checked = false;
  bool _tnCchecked = false;
  List<String> busy = ["Owner", "Manager", "Employee"];
  setContext(BuildContext context) {
    this.context = context;
  }

  int getTypeId() => _typeId; //businessTypeId

  setTypeId(int _val) {
    _typeId = _val;
  } //businessTypeId

  String getBusinessName() => _businessName;

  setChecked(bool _val) {
    _checked = _val;
    notifyListeners();
  }

  getChecked() => _checked;

  setTnCChecked(bool _val) {
    _tnCchecked = _val;
    notifyListeners();
  }

  getTnCChecked() => _tnCchecked;

  Future<CatListModel> getCategory() async {
    await WebService.funGetCatList({"business_type_id": _typeId}).then((value) {
      _catdata.clear();
      _catdata.addAll(value.data);
      notifyListeners();
      return value;
    });
  }

  Future<busyListModel> getBusiness() async {
    await WebService.funGetBusyList().then((value) {
      _busdata.clear();
      _busdata.addAll(value.data);
      notifyListeners();
      return value;
    });
  }

  List<String> getBusinessNameAll() {
    List<String> _data = [];
    _data.addAll(_busdata.map((e) => e.typeName));
    return _data;
  }

  List<String> getCategoryAll() {
    List<String> _data = [];
    _data.addAll(_catdata.map((e) => e.categoryName));
    return _data;
  }

  businessIdByName(String _name) {
    for (var _va in _busdata)
      if (_va.typeName == _name) {
        _typeId = _va.id;
        _businessName = _va.typeName;
        catvisib = _typeId == 1 ? true : false;
      }
    notifyListeners();
    getCategory();
  }

  setCategoryIdByName(String _name) {
    for (var _va in _catdata)
      if (_va.categoryName == _name) {
        _categoryId = _va.id;
        _categoryName = _va.categoryName;
      }
    notifyListeners();
  }

  getCategoryName() => _categoryName;
  getCategoryId() => _categoryId;

  Future<CatListModel> funRegister() async {
    // pr.show();
    Map<String, dynamic> _map = {
      "business_type_id": _typeId,
      "business_name": controller[0].text,
      "business_category_id": _categoryId,
      "postal_code": controller[1].text,
      "business_phone": controller[2].text,
      "display_name": controller[3].text,
      "email": controller[5].text,
      "password": controller[6].text,
      "reach_whatsapp": _checked,
      "role": _typeId == 1 ? controller[4].text : "owner"
    };

    print("Request:${_map}");
    WebService.funRegister(_map, context).then((value) {
      if (value.status == 'success') {
        BotToast.showText(text: value.message ?? '');
        allClear();
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        BotToast.showText(text: value.message.toString());
      }
    });
  }

  void pinCaller(String _val) async {
    await WebService.funGetCityByPincode({"pincode": _val}).then((value) {
      if (value.data.city == null) {
        error[1] = value.message;
        controller[1].text = '';
      } else {
        error[1] = null;
      }
      notifyListeners();
    });
  }

  allClear() {
    // try {
    //   categoryKey?.currentState?.changeSelectedItem(null);
    //   categoryKey1?.currentState?.changeSelectedItem(null);
    //   categoryKey2?.currentState?.changeSelectedItem(null);
    // } catch (e) {
    //   print('Error:' + e.toString());
    // }
    for (int _i = 0; _i < 8; _i++) {
      controller[_i].text = '';
      error[_i] = null;
    }
    _businessName = '';
    _checked = false;
    _tnCchecked = false;
    _categoryId = null;
    _categoryName = null;

    error[1] = null;
    // categoryKey.currentState.initState();
  }

  validatemail() async {
    print("fsdfsdfsdf");
    if (emailRegex.hasMatch(controller[5].text)) {
      await WebService.checkEmailAndMobile(
        {"api_type": "email", "email": controller[5].text},
      ).then((value) {
        if (value.status == "success") {
          mailError = value.data[0].isExist == 1
              ? '\t\t\tThis mail arleady registered with us.'
              : null;
        } else {
          mailError = '${value.message}';
        }
      });
    } else {
      mailError = null;
    }
    notifyListeners();
  }

  validatePassword(_val) {
    if (!passwordRegex.hasMatch(_val)) {
      passError =
          'Password should be 8 Character or \n longer. At least a number, a symbol.';
    } else {
      passError = null;
    }
    if (controller[6].text != controller[7].text) {
      passError1 = 'Password mismatch';
    } else {
      passError1 = null;
    }
    notifyListeners();
  }

  validatePassword1(_val) {
    if (!passwordRegex.hasMatch(_val)) {
      passError1 =
          'Password should be 8 Character or \n longer. At least a number, a symbol.';
    } else if (controller[6].text != controller[7].text) {
      passError1 = 'Password mismatch';
    } else {
      passError1 = null;
    }
    notifyListeners();
  }

  refresh() {
    notifyListeners();
  }
}
