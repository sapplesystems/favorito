import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class BaseProvider extends ChangeNotifier {
  String _businessId;
  String _userEmail;

  String getUserEmail() => _userEmail;

  setUserEmail(String value) {
    print("ddfff$value");
    _userEmail = value;
  }

  setBusinessId(String _val) {
    _businessId = _val;
  }

// await Prefs.token
  String getBusinessId() => _businessId;

  List<String> menuTitleList = [
    "Edit profile",
    "Reviews",
    "Photos added with reviews",
    "Check-ins",
    "Favourites",
    "Refer friend/place",
    'Saved Addresses',
    "Orders",
    "Friends",
    "Followers",
    "Following",
    "Following Business",
    "Find friend by name",
    "Liked posts",
    "Blocked users",
    "Terms of services",
    "Privacy policy",
    "Licenses",
    'Change login details',
    "Delete Account",
    'Logout'
  ];
  List menuIconList = [
    'edit',
    'star',
    'camera',
    'check',
    'favorite',
    'refer',
    'location',
    'bucket',
    'friend',
    'follow',
    'following',
    'shirt',
    'find',
    'heart',
    'block',
    'term',
    'privacy',
    'license',
    'changePass',
    'delete',
    'logout'
  ];
  snackBar(String message, GlobalKey key) {
    return ScaffoldMessenger.of(key.currentContext).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 2)),
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
