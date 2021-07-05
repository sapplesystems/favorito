import 'package:Favorito/ui/Chat/HomeScreen.dart';
import 'package:Favorito/ui/appoinment/appoinment.dart';
import 'package:Favorito/ui/booking/BookingProvider.dart';
import 'package:Favorito/ui/booking/Bookings.dart';
import 'package:Favorito/ui/dashboard/dashboard.dart';
import 'package:Favorito/ui/login/login.dart';
import 'package:Favorito/ui/menu/MenuHome.dart';
import 'package:Favorito/ui/setting/setting/setting.dart';
import 'package:Favorito/utils/Prefs.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class bottomNavigation extends StatefulWidget {
  @override
  _bottomNavigationState createState() => _bottomNavigationState();
}

SharedPreferences preferences;

class _bottomNavigationState extends State<bottomNavigation> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = [
    dashboard(),
    CircularProgressIndicator(),
    HomeScreen(),
    MenuHome(),
    Setting()
  ];

  @override
  initState() {
    decide();
    super.initState();
  }

  void _onItemTapped(int index) async {
    var _va = await Prefs.isAppointment;

    if (index == 1) {
      _widgetOptions[1] = _va ? Appoinment() : Bookings();
      print('ddddd$_va');
      if (_va) {
      } else {
        Provider.of<BookingProvider>(context, listen: false).getBookingData();
      }
    }
    // else if(index==2){
    //   Provider.of<AppoinmentProvider>(context, listen: false).getAppointmentCall();
    // }
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ""),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.comment), label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted), label: ""),
          BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.cog), label: ""),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  void decide() async {
    preferences = await SharedPreferences.getInstance();
    print("isAppointment:${preferences.getBool('isAppointment')}");

    // _widgetOptions[1] =
    //     preferences.getBool('isAppointment') ? Appoinment() : Bookings();
    var token = await Prefs.token;
    if (token == null || token == "") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Login()),
          (Route<dynamic> route) => false);
    } else
      print("Token:$token");
  }
}
