import 'package:application/myCss.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/velocity_x.dart';

class setting extends StatefulWidget {
  @override
  _settingState createState() => _settingState();
}

class _settingState extends State<setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Color(0xfffff4f4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Settings",style: TextStyle(color: Colors.black,fontSize: 24,fontWeight: FontWeight.bold,letterSpacing: 1),),   leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),  elevation: 0,),

      body: Container(child:  Image.asset('assets/icon/foo.png',

          height: context.percentHeight * 20),),
    );
  }
}
