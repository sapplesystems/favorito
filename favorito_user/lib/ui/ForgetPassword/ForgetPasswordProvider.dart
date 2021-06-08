import 'package:bot_toast/bot_toast.dart';
import 'package:favorito_user/model/otp/SendOtpModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/utils/Regexer.dart';
import 'package:favorito_user/utils/Validator.dart';
import 'package:favorito_user/utils/acces.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../../utils/RIKeys.dart';

class ForgetPasswordProvider extends ChangeNotifier {
  String didNotReceive = '';
  BuildContext context;
  Validator validator = Validator();
  String sendOtptxt = "Send OTP";
  List<Acces> acces = [];
  List<String> title = [
    'Email/Phone',
    'Enter OTP',
    'New password',
    'Confirm password'
  ];
  SendOtpModel sendOtpModel = SendOtpModel();
  List<String> prefix = ['name', '', 'password', 'password'];
  String actualOtp = null;
  bool otpForworded = false;
  bool otpVerified = false;
  ForgetPasswordProvider() {
    for (int i = 0; i < 4; i++) acces.add(Acces());
  }
  setContext(context) {
    this.context = context;
  }

  funSendOtpSms() async {
    acces[0].error = validator.validateUserName(acces[0].controller.text);
    notifyListeners();

    if (acces[0].error == null) {
      Map _map = {"email_or_phone": acces[0].controller.text};

      await APIManager.sendOtp(_map, RIKeys.josKeys1).then((value) {
        if (value.status == 'success' &&
            value.data[0].responseStatus == 'success') {
          otpForworded = true;
          sendOtpModel = value;
          didNotReceive = 'Did not recieved Otp.';
          sendOtptxt = 'Send Again';
        } else {
          BotToast.showText(text: value.message);
        }
        notifyListeners();
      });
    }
  }

  funVerifyOtp() async {
    acces[1].error = validator.validateOtp(acces[1].controller.text);
    acces[2].error = validator.validatePassword(acces[2].controller.text);
    acces[3].error = validator.validatePassword(acces[3].controller.text);
    acces[3].error = validator.compareTwoPassword(
        acces[2].controller.text, acces[3].controller.text);

    notifyListeners();
    print(
        "data is :${acces[0].toString()}:${acces[1].toString()}:${acces[2].toString()}:${acces[3].toString()}");
    if (acces[1].error == null &&
        acces[2].error == null &&
        acces[3].error == null) {
      Map _map = {
        "user_id": sendOtpModel.data[0].userId,
        "otp": acces[1].controller.text,
        "password": acces[2].controller.text
      };
      print("data:${_map.toString()}");
      await APIManager.verifyOtp(_map, RIKeys.josKeys1).then((value) {
        if (value.status == 'success') {
          allClear();
        }
        BotToast.showText(text: value.message, duration: Duration(seconds: 4));
      });
    }
    notifyListeners();
  }

  onChange(int _index) {
    switch (_index) {
      case 0:
        {
          if (emailRegex.hasMatch(acces[_index].controller.text))
            acces[_index].error = null;
          else
            acces[_index].error = 'Invalid email/phone';
          notifyListeners();
        }
        break;

      case 2:
        {
          if (passwordRegex.hasMatch(acces[_index].controller.text)) {
            acces[_index].error = null;
            if (acces[_index + 1].controller.text != '' &&
                (acces[_index].controller.text !=
                    acces[_index + 1].controller.text)) {
              acces[_index + 1].error = 'Password mismatch';
            } else
              acces[_index + 1].error = null;
          } else {
            acces[_index].error =
                validator.validatePassword(acces[_index].controller.text);
          }
          notifyListeners();
        }
        break;

      case 3:
        {
          if (passwordRegex.hasMatch(acces[_index].controller.text)) {
            acces[_index].error = null;
            if (acces[_index - 1].controller.text != null &&
                (acces[_index].controller.text !=
                    acces[_index - 1].controller.text)) {
              acces[_index].error = 'Password mismatch';
            } else {
              acces[_index].error = null;
            }
          } else {
            acces[_index].error =
                validator.validatePassword(acces[_index].controller.text);
          }
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

  allClear() {
    for (int i = 0; i < 4; i++) {
      Acces a = Acces();
      acces[i] = a;
    }
    otpForworded = false;
    didNotReceive = '';
    sendOtptxt = 'Send OTP';
    Navigator.of(context).pushNamed('/');
  }
}
