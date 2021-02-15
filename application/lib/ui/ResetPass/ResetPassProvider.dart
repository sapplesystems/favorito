import 'package:Favorito/network/webservices.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'dart:io';

class ResetPassProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  IconData iconData = Icons.visibility;
  IconData iconData2 = Icons.visibility_off;
  List<String> passError = [null, null, null];
  bool buttonVisible = false;
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
      ..style(message: 'Please wait');
  }

  funSubmit(context) async {
    pr.show().timeout(Duration(seconds: 10));
    await WebService.funChangePassword({
      "old_password": controller[0].text,
      "new_password": controller[1].text,
      "confirm_password": controller[2].text
    }).then((value) {
      pr.hide();
      if (value.status == 'success') {
        BotToast.showText(text: value.message);
        clear();
        sleep(Duration(seconds: 5));
        Navigator.pop(context);
      } else
        BotToast.showText(text: value.message);
    });
  }
}
