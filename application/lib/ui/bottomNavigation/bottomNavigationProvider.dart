import 'package:Favorito/Provider/BaseProvider.dart';
import 'package:Favorito/ui/Chat/LoginPage.dart';
import 'package:Favorito/ui/appoinment/AppoinmentProvider.dart';
import 'package:Favorito/ui/appoinment/appoinment.dart';
import 'package:Favorito/ui/booking/BookingProvider.dart';
import 'package:Favorito/ui/booking/Bookings.dart';
import 'package:Favorito/ui/dashboard/dashboard.dart';
import 'package:Favorito/ui/login/login.dart';
import 'package:Favorito/ui/menu/MenuHome.dart';
import 'package:Favorito/ui/setting/setting/setting.dart';
import 'package:Favorito/utils/Prefs.dart';
import 'package:Favorito/utils/RIKeys.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class bottomNavigationProvider extends BaseProvider {
  int _selectedIndex = 0;
  List<Widget> widgetOptions = [
    dashboard(),
    Bookings(),
    ChatLogin(),
    MenuHome(),
    Setting()
  ];
  bottomNavigationProvider() {
    _selectedIndex = 0;
    decide();
  }
  void onItemTapped(int index) {
    if (index == 1) {
      Provider.of<BookingProvider>(RIKeys.josKeys27.currentContext,
              listen: false)
          .getBookingData();
    } else if (index == 2) {
      Provider.of<AppoinmentProvider>(RIKeys.josKeys27.currentContext,
              listen: false)
          .getAppointmentCall();
    }
    setSelectedIndex(index);
    notifyListeners();
  }

  setSelectedIndex(int _i) {
    _selectedIndex = _i;
    notifyListeners();
  }

  getSelectedIndex() => _selectedIndex;

  void decide() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("isAppointment:${preferences.getBool('isAppointment')}");
    widgetOptions[1] = await Prefs.isAppointment ? Appoinment() : Bookings();
    // preferences.getBool('isAppointment') ? Appoinment() : Bookings();
    var token = await Prefs.token;
    if (token == null || token == "") {
      Navigator.of(RIKeys.josKeys27.currentContext).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Login()),
          (Route<dynamic> route) => false);
    } else
      print("Token:$token");
  }
}
