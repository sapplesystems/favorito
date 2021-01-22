import 'dart:ui';
import 'package:Favorito/model/checkinsModel.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/dateformate.dart';
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
  List<checkinsModel> dataList = [];
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
                top: sm.w(10),
              ),
              child: Text(
                "Checkins",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
            ),
            centerTitle: true,
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
        body: FutureBuilder<checkinsModel>(
          future: WebService.funCheckinslist(context),
          builder:
              (BuildContext context, AsyncSnapshot<checkinsModel> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                  color: myBackGround,
                  child:
                      Center(child: Text('Please wait its loading data.....')));
            } else {
              if (snapshot.hasError)
                return Center(child: Text('Error: ${snapshot.error}'));
              else {
                print("snapshot:${snapshot.data.toString()}");
                return Container(
                  height: sm.h(100),
                  color: myBackGround,
                  padding: EdgeInsets.symmetric(horizontal: sm.w(4)),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      Row(
                        children: [
                          Text("   New"),
                        ],
                      ),
                      for (int i = 0; i < snapshot.data.data.length; i++)
                        if (snapshot.data.data[i].isNew?.toString() != '0')
                          rowCard(
                              snapshot.data.data[i].name,
                              "Review: ${snapshot.data.data[i].reviews}\nCreated At: ${snapshot.data.data[i].reviewAt} , ${dateFormat5.format(DateTime.parse(snapshot.data.data[i].reviewDate))}",
                              () {},
                              snapshot.data.data[i].rating?.toString()),
                      Divider(height: sm.h(4)),
                      Row(
                        children: [
                          Text("   All"),
                        ],
                      ),
                      for (int i = 0; i < snapshot.data.data.length; i++)
                        if (snapshot.data.data[i].isNew?.toString() != '1')
                          rowCard(
                              snapshot.data.data[i].name,
                              "Review: ${snapshot.data.data[i].reviews}\nCreated At: ${snapshot.data.data[i].reviewAt} , ${dateFormat5.format(DateTime.parse(snapshot.data.data[i].reviewDate))}",
                              () {},
                              snapshot.data.data[i].rating?.toString()),
                    ]),
                  ),
                );
              }
            }
          },
        ));
  }

  Widget rowCard(
      String title, String subtitle, Function function, String rating) {
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
              trailing: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      "Rating",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Text(rating, style: TextStyle(fontSize: 12)),
                    maxRadius: 12,
                  ),
                ],
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
          height: sm.h(1.4),
        )
      ]),
    );
  }
}
