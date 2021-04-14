import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BaseProvider extends ChangeNotifier {
  String businessId;
  String _userEmail;

  String getUserEmail() => _userEmail;

  setUserEmail(String value) {
    print("ddfff$value");
    _userEmail = value;
  }

  snackBar(String message, GlobalKey key) {
    return ScaffoldMessenger.of(key.currentContext).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: myRed,
      ),
    );
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
