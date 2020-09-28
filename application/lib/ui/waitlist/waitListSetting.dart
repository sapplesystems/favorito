import 'package:Favorito/myCss.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/utils/myString.Dart';

class WaitListSetting extends StatefulWidget {
  @override
  _WaitListSettingState createState() => _WaitListSettingState();
}

class _WaitListSettingState extends State<WaitListSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myBackGround,
      appBar: AppBar(
        backgroundColor: myBackGround,
        elevation: 0,
        title: Text(waitlistSetting, style: barTitleStyle),
      ),
    );
  }
}
