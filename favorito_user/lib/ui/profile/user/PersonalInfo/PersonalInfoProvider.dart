import 'package:favorito_user/Providers/BaseProvider.dart';
import 'package:favorito_user/model/appModel/AddressListModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/utils/Prefs.dart';
import 'package:favorito_user/utils/Validator.dart';
import 'package:favorito_user/utils/acces.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../../../utils/RIKeys.dart';

class PersonalInfoProvider extends BaseProvider {
  Validator validator = Validator();
  String _username = '';
  List<Acces> acces = [for (int i = 0; i < 3; i++) Acces()];
  ProgressDialog pr;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String _phone;
  GlobalKey key = GlobalKey();
  bool showSubmit = false;
  List<String> title = ['Full Name', 'Postal', 'Short discription'];
  AddressListModel addressListModel = AddressListModel();
  List<String> prefix = ['name', 'postal', 'name'];
  bool newValue = false;
  PersonalInfoProvider() {
    getPersonalData();
  }
  void onWillPop(context) {
    this.onWillPop(context);
  }

  String get username => _username;
  String get phone {
    return '${_phone?.substring(0, 2) ?? ''}\t${_phone.substring(2, 6)} ${_phone.substring(6, 10)}';
  }

  void decideit() async {
    String token = await Prefs.token;
    print("token : $token");
    if (token.length < 10 || token == null || token.isEmpty || token == "")
      Navigator.of(context).pushNamed('/login');
  }

  BuildContext context;
  setContext(BuildContext context) {
    this.context = context;
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false)
      ..style(message: 'Please wait..');
  }

  getPersonalData() async {
    Map _map = {"api_type": 'get'};
    await APIManager.userdetail(_map, RIKeys.josKeys3).then((value) {
      if (value.status == 'success') {
        var v = value.data.detail;
        print("ffff:${v.fullName}");
        _username = v.fullName;
        acces[0].controller.text = v.fullName;
        acces[1].controller.text = v.postal;
        acces[2].controller.text = v.shortDescription;
        newValue = v.reachWhatsapp == 1 ? true : false;
        _phone = v.phone;
      }
      notifyListeners();
    });
  }

  void checkPin(int _index, GlobalKey key) async {
    await APIManager.checkPostalCode(
            {"pincode": acces[_index].controller.text}, key)
        .then((value) {
      if (value.data.stateName == null)
        acces[_index].error = value.message;
      else {
        Prefs.setPOSTEL(int.parse(acces[_index].controller.text));
        acces[_index].error = null;
      }
    });
    notifyListeners();
  }

  setPersonalData() async {
    if (acces[1].controller.text.length < 6) {
      acces[1].error = 'Invalid postal code';
      notifyListeners();
    } else {
      pr.show().timeout(Duration(seconds: 5));
      Map _map = {
        "api_type": 'set',
        'full_name': acces[0].controller.text,
        'postal_code': acces[1].controller.text,
        'short_description': acces[2].controller.text,
        'reach_whatsapp': newValue ? 1 : 0
      };
      await APIManager.userdetail(_map, RIKeys.josKeys3).then((value) {
        pr.hide();
        if (value.status == 'success') getPersonalData();
      });
    }
  }
}
