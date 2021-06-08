import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:Favorito/utils/Regexer.dart';

class ForgetPassProvider extends ChangeNotifier {
  String ctrlUserError = '';
  String ctrlPassError = '';
  bool sentOtp = false;
  bool submitStatus = false;
  String businesId = '';
  String sendOtptxt = "Send Otp";
  String didNotReceive = '';
  String actualOtp = '';
  IconData iconData = Icons.visibility_off;
  IconData iconData2 = Icons.visibility_off;
  TextEditingController userCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  TextEditingController cPassCtrl = TextEditingController();
  TextEditingController ctrlUser = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController errorController = TextEditingController();
  BuildContext context;
  ProgressDialog pr;
  setContext(BuildContext context) {
    context = context;
    pr = ProgressDialog(context, type: ProgressDialogType.Normal)
      ..style(
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

  void funSendOtpSms() async {
    //for send otp on main or phone
    if (!emailAndMobileRegex.hasMatch(ctrlUser.text)) {
      ctrlUserError = "Invalid input";
      notifyListeners();
    } else {
      ctrlUserError = null;
      this.pr?.show();
      Map _map = {"email_or_phone": ctrlUser.text};

      await WebService.funForgetPass(_map).then((value) {
        pr.hide();
        if (value.data[0].responseStatus == 'success') {
          sentOtp = true;
          businesId = value.data[0].businesId;
          sendOtptxt = "Send Again";
          didNotReceive = "Did not receive OTP, ";
        } else
          ctrlUserError = value.message;
      });
    }
  }

  verifyOtp() async {
    pr.show();
    Map map = {
      "otp": actualOtp,
      "business_id": businesId,
      "password": passCtrl.text
    };
    await WebService.funVerifyOtp(map).then((value) {
      pr.hide();
      if (value.status == 'success') {
        BotToast.showText(text: value.message, duration: Duration(seconds: 4));
        clearall();
      } else if (value.status == 'fail') {
        textEditingController.text = "";
      }
      notifyListeners();
    });
  }

  // bool caoparePassword() {
  //   if (passCtrl.text.isNotEmpty && cPassCtrl.text.isNotEmpty) {
  //     ctrlPassError =
  //         passCtrl.text != cPassCtrl.text ? "Password mismatch.." : null;
  //     notifyListeners();
  //   }
  // }

  clearall() {
    ctrlUser.text = '';
    passCtrl.text = '';
    cPassCtrl.text = '';
    passCtrl.text = '';
    sentOtp = false;
    submitStatus = false;
  }
}
