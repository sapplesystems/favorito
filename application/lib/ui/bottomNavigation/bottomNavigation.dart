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

class bottomNavigation extends StatefulWidget {
  @override
  _bottomNavigationState createState() => _bottomNavigationState();
}

class _bottomNavigationState extends State<bottomNavigation> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    dashboard(),
    Bookings(),
    Appoinment(),
    // Bookings(),
    MenuHome(),
    Setting()
  ];

  @override
  void initState() {
    decide();
    super.initState();
  }

  void _onItemTapped(int index) {
    if(index==1){
Provider.of<BookingProvider>(context, listen: false).getBookingData();
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
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: ""),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.comment), label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted), label: ""),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.cog), label: ""),
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
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Login()),
          (Route<dynamic> route) => false);
    } else
      print("Token:$token");
  }
}
