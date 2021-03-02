import 'package:Favorito/model/CatListModel.dart';
import 'package:Favorito/model/busyListModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SignUpProvider extends ChangeNotifier {
  static final categoryKey = GlobalKey<DropdownSearchState<String>>();
  static final categoryKey1 = GlobalKey<DropdownSearchState<String>>();
  static final categoryKey2 = GlobalKey<DropdownSearchState<String>>();
  static bool signCler = true;
  SignUpProvider() {
    getCategory();
    getBusiness();
    for (int _i = 0; _i < 8; _i++) {
      controller.add(TextEditingController());
      error.add(null);
    }
  }
  BuildContext context;
  ProgressDialog pr;
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
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(
        message: 'Please wait...',
        borderRadius: 8.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 8.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: myRed, fontSize: 19.0, fontWeight: FontWeight.w600));
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
    pr.show().timeout(Duration(seconds: 5));
    WebService.funRegister(_map, context).then((value) {
      pr.hide();
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
    pr.show();
    await WebService.funGetCityByPincode({"pincode": _val}).then((value) {
      pr.hide();
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
}
