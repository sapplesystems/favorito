import 'package:Favorito/ui/appoinment/appoinment.dart';
import 'package:Favorito/ui/appoinment/appoinmentSetting.dart';
import 'package:Favorito/ui/booking/Bookings.dart';
import 'package:Favorito/ui/checkins/checkins.dart';
import 'package:Favorito/ui/dashboard/dashboard.dart';
import 'package:Favorito/ui/login/login.dart';
import 'package:Favorito/ui/menu/Menu.dart';
import 'package:Favorito/ui/menu/item/MenuItem.dart';
import 'package:Favorito/ui/setting/setting.dart';
import 'package:Favorito/utils/Prefs.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class bottomNavigation extends StatefulWidget {
  @override
  _bottomNavigationState createState() => _bottomNavigationState();
}

class _bottomNavigationState extends State<bottomNavigation> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    dashboard(),
    Bookings(),
    setting(),
    // checkins(),
    Menu(),
    // MenuItem(),
    // Appoinment(),
    setting()
  ];

  @override
  void initState() {
    decide();
    super.initState();
  }

  void _onItemTapped(int index) {
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
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("")),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), title: Text("")),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.comment), title: Text("")),
          BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted), title: Text("")),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.cog), title: Text("")),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  void decide() async {
    var token = await Prefs.token;
    if (token == null || token == "") {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    } else
      print("Token:$token");
  }
}
