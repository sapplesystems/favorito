import 'package:Favorito/Provider/BaseProvider.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/RIKeys.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ResetPassProvider extends BaseProvider {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  IconData iconData = Icons.visibility;
  IconData iconData2 = Icons.visibility_off;
  List<String> passError = [null, null, null];
  bool buttonVisible = false;
  bool autovalidate = false;
  bool showNote = false;
  ProgressDialog pr;
  List<IconData> security = [
    Icons.visibility,
    Icons.visibility,
    Icons.visibility
  ];
  List<String> title = ['Old password', 'New password', 'Confirm password'];

  List<TextEditingController> controller = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  showNoteSet(_val) {
    showNote = _val;
    notifyListeners();
  }

  passwordSame() {
    if ((controller[1].text.isNotEmpty && controller[2].text.isNotEmpty) &&
        (controller[1].text != controller[2].text)) {
      passError[2] = 'Password mismatch!!';
    } else {
      passError[2] = null;
    }
    if (controller[0].text.isNotEmpty &&
        controller[1].text.isNotEmpty &&
        controller[2].text.isNotEmpty &&
        (controller[1].text == controller[2].text)) {
      buttonVisible = true;
    } else {
      buttonVisible = false;
    }
    notifyListeners();
  }

  sufixClick(int i) {
    security[i] = security[i] == Icons.visibility
        ? Icons.visibility_off
        : Icons.visibility;

    notifyListeners();
  }

  clear() {
    print("aaaaaaaaa");
    for (var v in controller) {
      v.text = "";
    }
    buttonVisible = false;
    notifyListeners();
  }

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

  funSubmit(context) async {
    await WebService.funChangePassword({
      "old_password": controller[0].text,
      "new_password": controller[1].text,
      "confirm_password": controller[2].text
    }, context)
        .then((value) {
      if (value.status == 'success') {
        this.snackBar(value.message, RIKeys.josKeys1, myGreen);
        clear();
        Navigator.pop(context);
      } else if (value.status == 'error') {
        this.snackBar(value.message, RIKeys.josKeys1, myRed);
      }
    });
  }
}
