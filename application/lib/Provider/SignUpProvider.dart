import 'package:Favorito/model/CatListModel.dart';
import 'package:Favorito/model/busyListModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/bottomNavigation/bottomNavigation.dart';
import 'package:Favorito/ui/login/login.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SignUpProvider extends ChangeNotifier {
  SignUpProvider() {
    getCategory();
    getBusiness();
    for (int _i = 0; _i < 8; _i++) controller.add(TextEditingController());
  }
  BuildContext context;
  ProgressDialog pr;
  List<TextEditingController> controller = [];
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
    pr = ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please wait');
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
    pr.show();
    await WebService.funGetCatList({"business_type_id": _typeId}).then((value) {
      pr.hide();
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
      "business_name": _businessName,
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
      // pr.hide();
      if (value.status == 'success') {
        BotToast.showText(text: "Registration SuccessFull!!");
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      } else {
        BotToast.showText(text: value.message.toString());
      }
    });
  }
}
