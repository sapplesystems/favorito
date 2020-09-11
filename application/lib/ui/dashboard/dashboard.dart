import 'dart:ui';

import 'package:application/component/card1.dart';
import 'package:application/component/card2.dart';
import 'package:application/component/cart3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:velocity_x/velocity_x.dart';

class dashboard extends StatefulWidget {
  @override
  _dashboardState createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            title: Padding(
              padding: EdgeInsets.only(
                top: context.percentWidth * 10,
              ),
              child: Text(
                "DASHBOARD",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
            ),
            centerTitle: true,
            backgroundColor: Color(0xfffff4f4),
            elevation: 0,
            leading: IconButton(
              icon: Icon(null, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
          ),
        ),
        body: Container(
            color: Color(0xfffff4f4),
            padding: EdgeInsets.symmetric(horizontal: context.percentWidth * 4),
            child: SingleChildScrollView(
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Status : ", style: TextStyle(fontSize: 16)),
                    Text("Live",
                        style: TextStyle(fontSize: 16, color: Colors.green)),
                    SizedBox(
                      width: 20,
                    )
                  ],
                ),
                rowWithTextNButton("Conplete Your Profile", "Fill"),
                rowWithTextNButton("Complete your information", "Now"),
                rowWithTextNButton("Send for verification", "Verify"),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: context.percentHeight * 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [card1(), card2()],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: context.percentHeight * 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      card3(txt1: "Catalogoues", txt2: "71"),
                      card3(
                        txt1: "Orders",
                        txt2: "642",
                      )
                    ],
                  ),
                ),
                Row(children: [
                  Text(
                    "Grow your Business",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  )
                ]),
                Row(children: [
                  credit("Free Credit", "200", "assets/icon/warning.svg"),
                  credit("Paid Credit", "400", "null")
                ]),
                for (int i = 0; i < 2; i++)
                  rowCard("Advertise",
                      "Reach new audience searching for related services"),
              ]),
            )));
  }

  Widget rowWithTextNButton(String txt1, String txt2) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      padding: EdgeInsets.symmetric(
          vertical: context.percentHeight * 2,
          horizontal: context.percentWidth * 2),
      margin: EdgeInsets.symmetric(
        vertical: context.percentHeight * 1,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(txt1),
          InkWell(
            onTap: () {},
            child: Container(
              width: 54,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Color(0xffdd2626),
                  width: 1,
                ),
              ),
              child: Text(
                txt2,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget rowCard(String title, String subtitle) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6),
      margin: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(subtitle),
        // trailing: ,
      ),
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
          height: context.percentHeight * 1.4,
        )
      ]),
    );
  }
}
