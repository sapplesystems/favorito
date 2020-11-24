import 'dart:ui';
import 'package:Favorito/myCss.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/utils/myColors.dart';
class checkins extends StatefulWidget {
  @override
  _checkinsState createState() => _checkinsState();
}

class _checkinsState extends State<checkins> {
  SizeManager sm;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            title: Padding(
              padding: EdgeInsets.only(
                top: sm.scaledWidth(10),
              ),
              child: Text(
                "Checkins",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
            ),
            centerTitle: true,
            backgroundColor: myBackGround,
            elevation: 0,
            leading: IconButton(
              icon: Icon(null, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
          ),
        ),
        body: Container(
            height: sm.scaledHeight(100),
            color: myBackGround,
            padding: EdgeInsets.symmetric(horizontal: sm.scaledWidth(4)),
            child: SingleChildScrollView(
              child: Column(children: [
                Row(
                  children: [
                    Text("   New"),
                  ],
                ),
                for (int i = 0; i < 2; i++)
                  rowCard(
                      "Olivia carr",
                      "Reach new audience searching for related services",
                      () {}),
                Row(
                  children: [
                    Text("   All"),
                  ],
                ),
                for (int i = 0; i < 2; i++)
                  rowCard(
                      "Randal charles",
                      "Reach new audience searching for related services",
                      () {}),
              ]),
            )));
  }

  Widget rowCard(String title, String subtitle, Function function) {
    return InkWell(
      onTap: function,
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 6),
          margin: EdgeInsets.symmetric(vertical: 12),
          decoration: bd3,
          child: ListTile(
              title: Text(title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              subtitle: Text(subtitle),
              trailing: CircleAvatar(
                backgroundColor: Colors.red,
                child: Text("4", style: TextStyle(fontSize: 12)),
                maxRadius: 12,
              ))),
    );
  }

  Widget credit(String title, String ammount, String ico) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 16),
      child: Row(children: [
        Text("${title} : "),
        Text("${ammount}  "),
        SvgPicture.asset(
          ico,
          alignment: Alignment.center,
          height: sm.scaledHeight(1.4),
        )
      ]),
    );
  }
}
