import 'package:favorito_user/Providers/BaseProvider.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/utils/Prefs.dart';
import 'package:favorito_user/utils/RIKeys.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class LoginProvider extends BaseProvider {
  List controller = [];

  List<String> title = ['Email/Phone', 'Password'];
  List<String> prefix = ['mail', 'password'];
  LoginProvider() : super() {
    controller = [for (int i = 0; i < 3; i++) TextEditingController()];
  }
  void sendLoginOtp(GlobalKey<ScaffoldState> key) async {
    await APIManager.sendLoginotp({'username': controller[0].text}, key)
        .then((value) {
      this.snackBar(value.message, key);
      if (value.status == 'success') {
        print("good");
      } else {
        Navigator.of(key.currentContext).pop();
      }
    });
  }

  void verifyLogin() async {
    await APIManager.verifyLogin(
            {'username': controller[0].text, 'otp': controller[2].text},
            RIKeys.josKeys13)
        .then((value) {
      snackBar(value.message, RIKeys.josKeys13);
      if (value.status == 'success') {
        Prefs.setToken(value.token);
        Prefs.setPOSTEL(int.parse(value.data.postel ?? "201306"));

        print("token : ${value.token}");
        Navigator.pop(RIKeys.josKeys13.currentContext);
        Navigator.of(RIKeys.josKeys13.currentContext).pushNamed('/navbar');
      }
    });
  }

  onWillPop(context) {
    this.onWillPop(context);
  }
}
