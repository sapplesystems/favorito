import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/ui/Booking/BookingOrAppointmentList.dart';
import 'package:favorito_user/ui/Home.dart';
import 'package:favorito_user/ui/search/Search.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    Search(),
    BookingOrAppointmentList(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
          barBackgroundColor: Colors.white,
          selectedItemBorderColor: myBackGround,
          selectedItemBackgroundColor: myBackGround,
          selectedItemIconColor: Colors.black,
          selectedItemLabelColor: Colors.red,
        ),
        selectedIndex: _selectedIndex,
        onSelectTab: (index) {
          setState(() {
            _selectedIndex = index < 3 ? index : 0;
          });
        },
        items: [
          FFNavigationBarItem(
            iconData: Icons.home,
            label: 'Home',
          ),
          FFNavigationBarItem(
            iconData: Icons.search,
            label: 'Search',
          ),
          FFNavigationBarItem(
            iconData: Icons.list,
            label: 'Bookings',
          ),
          FFNavigationBarItem(
            iconData: Icons.chat,
            label: 'Chat',
          ),
          FFNavigationBarItem(
            iconData: Icons.person,
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
