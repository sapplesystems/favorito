import 'package:bot_toast/bot_toast.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class UtilProvider extends ChangeNotifier {
  Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      BotToast.showText(text: 'Please check internet connection..');
      return false;
    } else
      return true;
  }
}
