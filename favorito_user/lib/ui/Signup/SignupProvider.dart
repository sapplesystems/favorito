import 'package:bot_toast/bot_toast.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/Prefs.dart';
import 'package:favorito_user/utils/Regexer.dart';
import 'package:favorito_user/utils/Validator.dart';
import 'package:favorito_user/utils/acces.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SignupProvider extends ChangeNotifier {
  Validator validator = Validator();

  List<Acces> acces = [for (int i = 0; i < 8; i++) Acces()];
  ProgressDialog pr;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String _checkId = 'verify';
  String _checkIdMessage = null;
  bool uniqueId = false;
  bool uniqueMobile = false;
  bool uniqueEmail = false;
  bool newValue = false;
  bool newValue1 = false;
  GlobalKey key = GlobalKey();

  List<String> title = [
    'Full Name',
    'Phone',
    'Email',
    'Password',
    'Postal',
    'Short description',
    'Unique Id',
  ];

  List<String> prefix = [
    'name',
    'phone',
    'mail',
    'password',
    'postal',
    'name',
    'name'
  ];
  List<Color> errorColor = [null, null, null, null, null, null, null];

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

  funSubmit() async {
    print("$newValue");
    acces[0].error = validator.validateFullName(acces[0].controller.text);
    acces[1].error = validator.validateMobile(acces[1].controller.text);
    acces[2].error = validator.validateEmail(acces[2].controller.text);
    acces[3].error = validator.validatePassword(acces[3].controller.text);
    acces[4].error = validator.validatePin(acces[4].controller.text);
    acces[6].error = validator.validateId(acces[6].controller.text);

    notifyListeners();
    if (acces[0].error == null &&
        acces[1].error == null &&
        acces[2].error == null &&
        acces[3].error == null &&
        acces[4].error == null &&
        acces[5].error == null &&
        uniqueId &&
        uniqueMobile &&
        uniqueEmail) {
      if (newValue) {
        Map _map = {
          "full_name": acces[0].controller.text,
          "phone": acces[1].controller.text,
          "email": acces[2].controller.text,
          "password": acces[3].controller.text,
          "postal_code": acces[4].controller.text,
          "profile_id": acces[6].controller.text,
          "reach_whatsapp": newValue1 ? 1 : 0,
          "short_description": acces[6].controller.text
        };
        print("map:${_map.toString()}");
        await APIManager.register(_map, scaffoldKey).then((value) {
          if (value.status == "success") {
            BotToast.showText(text: value.message);
            Navigator.pop(context);
            Navigator.of(context).pushNamed('/login');
          }
        });
      } else {
        BotToast.showText(text: "Please check T&C.");
      }
    } else {
      print("uniqueId:$uniqueId");
    }
  }

  checkIdClicked(int _index) async {
    print("dddddprofile_id: ${acces[_index].controller.text}");
    await APIManager.checkId({"profile_id": acces[_index].controller.text})
        .then((value) {
      if (value.status == 'success') {
        if (value.data[0].isExist != 0) {
          acces[_index].error = value.message;
          uniqueId = false;

          errorColor[_index] = null;
        } else {
          _checkId = 'verified';
          uniqueId = true;
          acces[_index].error = null;
          errorColor[_index] = myGreenDark;
        }
        acces[_index].error = value.message;
      }
      notifyListeners();
    });
  }

  onChange(int _index) async {
    print(_index);
    switch (_index) {
      case 0:
        {
          if ((acces[_index].controller.text.isEmpty))
            acces[_index].error = 'Field required';
          else {
            acces[_index].error = null;
          }
          notifyListeners();
        }
        break;

      case 1:
        {
          if (mobileRegex.hasMatch(acces[_index].controller.text))
            CheckMobileNiumber(_index);
          else {
            // acces[_index].error = null;

          }
          notifyListeners();
        }
        break;

      case 2:
        {
          if (emailRegex.hasMatch(acces[_index].controller.text))
            CheckEmail(_index);
          else {
            acces[_index].error = null;
            notifyListeners();
          }
        }
        break;

      case 3:
        {
          if (passwordRegex.hasMatch(acces[_index].controller.text))
            acces[3].error = null;
          else {
            acces[_index].error =
                validator.validatePassword(acces[_index].controller.text);
          }
          notifyListeners();
        }
        break;

      case 4:
        {
          if ((acces[_index].controller.text.isEmpty))
            acces[_index].error = 'Field required';
          else {
            if (acces[_index].controller.text.length == 6) {
              await APIManager.checkPostalCode(
                      {"pincode": acces[_index].controller.text}, scaffoldKey)
                  .then((value) {
                if (value.data.stateName == null)
                  acces[_index].error = value.message;
                else {
                  Prefs.setPOSTEL(int.parse(acces[_index].controller.text));
                  acces[_index].error = null;
                }
              });
            }
          }
          notifyListeners();
        }
        break;

      case 6:
        {
          if (!acces[_index].controller.text.toString().contains('@')) {
            acces[_index].error =
                Validator().validateId(acces[_index].controller.text);
            acces[_index].controller.text = '';
          } else
            setCheckId('verify');
          if (acces[_index].controller.text.length > 2)
            acces[_index].error = 'Please check availability';
          errorColor[_index] = null;
          notifyListeners();
        }
        break;
    }
  }

  void CheckMobileNiumber(int _index) async {
    String _text = acces[_index].controller.text;
    await APIManager.checkMobileOrEmail({'api_type': 'mobile', 'mobile': _text})
        .then((value) {
      if (value.status == 'success') {
        print(value.message);
        uniqueMobile = true;
        acces[_index].error = value.data[0].isExist == 1 ? value.message : null;
        notifyListeners();
      } else
        uniqueMobile = false;
    });
  }

  void CheckEmail(int _index) async {
    String _text = acces[_index].controller.text;
    await APIManager.checkMobileOrEmail({'api_type': 'email', 'email': _text})
        .then((value) {
      if (value.status == 'success') {
        uniqueEmail = true;
        print(value.message);
        acces[_index].error = value.data[0].isExist == 1 ? value.message : null;
        notifyListeners();
      } else
        uniqueEmail = false;
    });
  }

  allClear() {
    for (int i = 0; i < acces.length; i++) acces[i] = Acces();

    uniqueId = false;
    uniqueMobile = false;
    uniqueEmail = false;
    newValue = false;
    newValue1 = false;
    _checkId = 'verify';
    notifyListeners();
  }

  String getCheckId() => _checkId;
  void setCheckId(String _val) {
    _checkId = _val;
    notifyListeners();
  }

  String get checkIdMessage => _checkIdMessage ?? '';
}
