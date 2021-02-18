import 'package:bot_toast/bot_toast.dart';
import 'package:favorito_user/services/APIManager.dart';
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
  String checkId = 'verify';
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
    'UniquiId',
    'Short discription'
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
    acces[5].error = validator.validateId(acces[5].controller.text);

    notifyListeners();
    print("ffff$uniqueId:$uniqueMobile:$uniqueEmail");
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
        pr.show();
        Map _map = {
          "full_name": acces[0].controller.text,
          "phone": acces[1].controller.text,
          "email": acces[2].controller.text,
          "password": acces[3].controller.text,
          "postal_code": acces[4].controller.text,
          "profile_id": acces[5].controller.text,
          "reach_whatsapp": newValue1 ? 1 : 0,
          "short_description": acces[6].controller.text,
        };
        print("map:${_map.toString()}");
        await APIManager.register(_map).then((value) {
          pr.hide();
          if (value.status == "success") {
            allClear();
            Prefs.setPOSTEL(int.parse(acces[4].controller.text));
            BotToast.showText(text: value.message);
            Navigator.pop(context);
          }
        });
      } else {
        BotToast.showText(text: "Please check T&C.");
      }
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
        } else {
          uniqueId = true;
          acces[_index].error = null;
        }
      }
      notifyListeners();
    });
  }

  onChange(int _index) {
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
            acces[_index].error = null;
          else {
            acces[_index].error =
                validator.validatePassword(acces[_index].controller.text);

            notifyListeners();
          }
        }
        break;

      case 4:
        {
          if ((acces[_index].controller.text.isEmpty))
            acces[_index].error = 'Field required';
          else {
            acces[_index].error = null;
          }
          notifyListeners();
        }
        break;

      case 5:
        {
          acces[_index].error = 'Please check availability';

          notifyListeners();
        }
        break;

      default:
        {
          //statements;
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
    for (int i = 0; i < acces.length; i++) {
      Acces a = Acces();
      acces[i] = a;
    }
    uniqueId = false;
    uniqueMobile = false;
    uniqueEmail = false;
    newValue = false;
    newValue1 = false;
    checkId = 'verify';
    notifyListeners();
  }
}
