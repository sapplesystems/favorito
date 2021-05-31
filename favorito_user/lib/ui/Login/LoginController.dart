import 'package:favorito_user/Providers/BaseProvider.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/utils/Prefs.dart';
import 'package:favorito_user/utils/RIKeys.dart';
import 'package:favorito_user/utils/Regexer.dart';
import 'package:favorito_user/utils/Validator.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter/foundation.dart';

class LoginProvider extends BaseProvider {
  List controller = [];
  String _errorEmail;
  List _errorPass = [null, null];
  bool _isPass = kReleaseMode ? false : true;
  bool _showSubmit = false;
  List<String> title = ['Email/Phone', 'Password'];
  List<String> prefix = ['mail', 'password'];
  List<String> loginDetailsList = ['Update Email', 'Change Password'];
  List<String> loginDetailsList2 = [
    'Add or update email',
    'Change login password'
  ];
  String getErrorEmail() => _errorEmail;
  bool getIsPass() => _isPass;
  bool setIsPass(bool _val) {
    _isPass = _val;
    notifyListeners();
  }

  String getErrorPass(int i) => _errorPass[i];
  bool getShowSubmit() => _showSubmit;
  String setShowSubmit(bool _va) {
    _showSubmit = _va;
    notifyListeners();
  }

  String clearErrorEmail() {
    _errorEmail = null;
    notifyListeners();
  }

  LoginProvider() : super() {
    controller = [for (int i = 0; i < 3; i++) TextEditingController()];
    if (!kReleaseMode) {
      controller[0].text = '7772022626';
      controller[1].text = 'Sapple@123';
    }
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
        Navigator.of(RIKeys.josKeys13.currentContext).pushNamed('/');
      }
    });
  }

  void getUserDetails(GlobalKey key) async {
    await APIManager.userdetail({"api_type": 'get'}, key).then((value) {
      if (value.status == 'success') {
        this.setUserEmail(value.data.detail.email);
        notifyListeners();
      }
    });
  }

  void saveUserEmail(GlobalKey key) async {
    await APIManager.emailRegister({'email': controller[0].text}).then((value) {
      if (value.status == 'success') getUserDetails(key);
    });
  }

  String getEmail() {
    if (this.getUserEmail()?.trim() == controller[0].text) {
      _errorEmail = null;
      setShowSubmit(false);
      notifyListeners();
    }
    return this.getUserEmail();
  }

  onWillPop(context) {
    this.onWillPop(context);
  }

  emailCheck(String va) async {
    _errorEmail = emailRegex.hasMatch(va) ? null : 'Invalid email address';
    getEmail();
    CheckEmail(va);
  }

  passwordCheck(String va, int i) async {
    _errorPass[i] = Validator().validatePassword(va);

    if ((controller[0].text != controller[1].text) &&
        (Validator().validatePassword(va) == null)) {
      _errorPass[1] = 'Password and confirmPassword need to same';
    }
    notifyListeners();
    // getEmail();
    // CheckEmail(va);
  }

  allClear() {
    controller[0].text = '';
    controller[1].text = '';
    controller[2].text = '';
  }

  void CheckEmail(String va) async {
    await APIManager.checkMobileOrEmail({'api_type': 'email', 'email': va})
        .then((value) {
      print("fg${value.message}");
      if (value.status == 'success') {
        if (emailRegex.hasMatch(va)) {
          if (value.data[0].isExist == 0)
            setShowSubmit(true);
          else
            _errorEmail = value.message;
        } else {
          setShowSubmit(false);
        }
      }
    });

    notifyListeners();
  }

  onSelect(int _index, GlobalKey key) {
    switch (_index) {
      case 0:
        Navigator.of(key.currentContext).pushNamed('/updateEmail');
        notifyListeners();
        break;
      case 1:
        Navigator.of(key.currentContext).pushNamed('/changePass');
        notifyListeners();
        break;
    }
  }

  updatePassword(GlobalKey key) async {
    await APIManager.changePassword({'password': controller[0].text}, key)
        .then((value) {
      this.snackBar(value.message, key);

      if (value.status == 'success') {
        controller[0].text = '';
        controller[1].text = '';
      }
    });
  }

  funSubmit(GlobalKey<FormState> key, GlobalKey<ScaffoldState> _scKey) async {
    if (_isPass) {
      if (key.currentState.validate()) {
        if (controller[0].text.trim().length == 0) {
          BaseProvider().snackBar('Email/Phone required!!', _scKey);
          return;
        }
        if (controller[1].text.trim().length == 0) {
          BaseProvider().snackBar('Password required!!', _scKey);
          return;
        }
        Map _map = {
          "username": controller[0].text,
          "password": controller[1].text
        };
        await APIManager.login(_map, _scKey).then((value) {
          if (value.status == "success") {
            Prefs.setToken(value.token);
            Prefs.setPOSTEL(int.parse(value.data.postel ?? "201306"));

            print("token : ${value.token}");
            Navigator.pop(_scKey.currentContext);
            Navigator.of(_scKey.currentContext).pushNamed('/');
          } else
            this.snackBar(value.message, key);
        });
      }
    } else {
      if (controller[0].text.trim().length == 0) {
        BaseProvider().snackBar('Email/Phone  required!!', _scKey);
        return;
      }
      Navigator.of(_scKey.currentContext)
          .pushNamed('/pinCodeVerificationScreen');
    }
  }
}
