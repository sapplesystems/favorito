import 'package:bot_toast/bot_toast.dart';
import 'package:favorito_user/model/otp/SendOtpModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/utils/Validator.dart';
import 'package:favorito_user/utils/acces.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ForgetPasswordProvider extends ChangeNotifier {
  String didNotReceive = '';
  BuildContext context;
  Validator validator = Validator();
  String sendOtptxt = "Send Otp";
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<Acces> acces = [];
  List<String> title = [
    'Email/Phone',
    'Enter Otp',
    'New password',
    'Confirm password'
  ];
  SendOtpModel sendOtpModel = SendOtpModel();
  List<String> prefix = ['name', '', 'password', 'password'];
  String actualOtp = null;
  bool otpForworded = false;
  bool otpVerified = false;
  ProgressDialog pr;
  ForgetPasswordProvider() {
    for (int i = 0; i < 4; i++) acces.add(Acces());
  }
  setContext(context) {
    this.context = context;
    pr = ProgressDialog(context,
        isDismissible: true, type: ProgressDialogType.Normal)
      ..style(message: 'PLease wait..');
  }

  funSendOtpSms() async {
    acces[0].error = validator.validateUserName(acces[0].controller.text);
    notifyListeners();

    if (acces[0].error == null) {
      pr.show();
      Map _map = {"email_or_phone": acces[0].controller.text};

      await APIManager.sendOtp(_map).then((value) {
        pr.hide();
        if (value.status == 'success' &&
            value.data[0].responseStatus == 'success') {
          otpForworded = true;
          sendOtpModel = value;

          didNotReceive = 'Did not recieved Otp.';
          sendOtptxt = 'Send Again';
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
      pr.show();
      Map _map = {
        "user_id": sendOtpModel.data[0].userId,
        "otp": acces[1].controller.text,
        "password": acces[2].controller.text
      };
      print("data:${_map.toString()}");
      await APIManager.verifyOtp(_map).then((value) {
        pr.hide();
        if (value.status == 'success') {
          clear();
        } else {
          print("value.message${value.message}");
          BotToast.showText(text: value.message);
        }
      });
    }
    notifyListeners();
  }

  clear() {
    for (int i = 0; i < 4; i++) {
      acces[i].error = '';
      acces[i].controller.text = '';
    }
    otpForworded = false;
    didNotReceive = '';
    sendOtptxt = 'Send Otp';
    Navigator.of(context).pushNamed('/');
  }
}
