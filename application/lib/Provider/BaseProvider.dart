import 'package:Favorito/ui/appoinment/AppoinmentProvider.dart';
import 'package:Favorito/ui/setting/BusinessProfile/BusinessHoursProvider.dart';
import 'package:Favorito/ui/setting/BusinessProfile/BusinessProfileProvider.dart';
import 'package:Favorito/utils/Prefs.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseProvider extends ChangeNotifier {
  String businessId;
  String _userEmail;
  SharedPreferences preferences;

  BaseProvider() {
    _initCall();
  }

  _initCall() async {
    preferences = await SharedPreferences.getInstance();
  }

  String getUserEmail() => _userEmail;

  setUserEmail(String value) {
    print("ddfff$value");
    _userEmail = value;
  }

  snackBar(String message, GlobalKey key, Color color) {
    return ScaffoldMessenger.of(key.currentContext).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: color ?? myRed,
      ),
    );
  }

  logoutApp(context) {
    Prefs().clear();
    preferences.clear();

    // Provider.of<BusinessProfileProvider>(context, listen: false).allClear();
    // Provider.of<BusinessHoursProvider>(context, listen: false).allClear();
    // Provider.of<AppoinmentProvider>(context, listen: false).logout();
  }

  static Future<void> onWillPop(context) async {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              // ignore: deprecated_member_use
              new FlatButton(
                onPressed: () => SystemNavigator.pop(),
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
