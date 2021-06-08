import 'package:Favorito/utils/SharedPrefUtils.dart';
import 'package:Favorito/utils/myString.Dart';

class Prefs {
  // static Future<String> get mobileNumber => SharedPrefUtils.getString(MONO);
  // static Future setMoileNumber(String value) =>
  //     SharedPrefUtils.setString(MONO, value);

  // static Future<int> get userId => SharedPrefUtils.getInt(USER_ID );
  // static Future setuserId(int value) => SharedPrefUtils.setInt(USER_ID , value);

  // static Future<int> get hostelId => SharedPrefUtils.getInt(HOSTEL_ID);
  // static Future setHostelId(int value) => SharedPrefUtils.setInt(HOSTEL_ID , value);

  static Future<String> get token => SharedPrefUtils.getString(TOKEN);
  static Future setToken(String value) =>
      SharedPrefUtils.setString(TOKEN, value);

  // static Future<String> get name => SharedPrefUtils.getString(NAME);
  // static Future setName(String value) => SharedPrefUtils.setString(NAME , value);

  // static Future<int> get rolenumber => SharedPrefUtils.getInt(ROLENUMBER);
  // static Future setrolenumber(int value) => SharedPrefUtils.setInt(ROLENUMBER, value);

  // static Future<bool> get authenticated => SharedPrefUtils.getBool(AUTHENTICATED);
  // static Future setAuthenticated(bool value) => SharedPrefUtils.setBool(AUTHENTICATED, value);

  // static Future<bool> get isin => SharedPrefUtils.getBool(ISIN);
  // static Future setISIN(bool value) => SharedPrefUtils.setBool(ISIN, value);

  // static Future<String> get passcode => SharedPrefUtils.getString(PASSCODE);
  // static Future setPasscode(String value) => SharedPrefUtils.setString(PASSCODE, value);

  Future<void> clear() async {
    await Future.wait(<Future>[
      setToken(null),
    ]);
  }
}
