import 'package:application/ui/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class bottomNavigation extends StatefulWidget {
  bottomNavigation({Key key}) : super(key: key);

  @override
  _bottomNavigationState createState() => _bottomNavigationState();
}

class _bottomNavigationState extends State<bottomNavigation> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    dashboard(),
    dashboard(),
    dashboard()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.listUl),
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
