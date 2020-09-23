import 'dart:ui';

import 'package:Favorito/component/card1.dart';
import 'package:Favorito/component/card2.dart';
import 'package:Favorito/component/cart3.dart';
import 'package:Favorito/component/rowWithTextNButton.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/businessInfo/businessInfo.dart';
import 'package:Favorito/ui/login/login.dart';
import 'package:Favorito/ui/setting/businessSetting.dart';
import 'package:Favorito/utils/Prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:Favorito/utils/myString.Dart';

class dashboard extends StatefulWidget {
  @override
  _dashboardState createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  @override
  void initState() {
    super.initState();
    calldashBoard();
  }

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
            actions: [
              IconButton(
                  icon: Icon(Icons.refresh, color: Colors.black),
                  onPressed: () {
                    calldashBoard();
                  }),
              IconButton(
                  icon: Icon(Icons.settings_power, color: Colors.black),
                  onPressed: () {
                    Prefs().clear();
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  })
            ],
            centerTitle: true,
            backgroundColor: Color(0xfffff4f4),
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
            color: Color(0xfffff4f4),
            padding: EdgeInsets.symmetric(horizontal: context.percentWidth * 4),
            child: SingleChildScrollView(
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Status : ", style: TextStyle(fontSize: 16)),
                    Text(
                        is_verified == "0"
                            ? "Offline"
                            : is_verified == "1"
                                ? "Live"
                                : "Blocked",
                        style: TextStyle(
                            fontSize: 16,
                            color: is_verified == "0"
                                ? Colors.grey
                                : is_verified == "1"
                                    ? Colors.green
                                    : Colors.red)),
                    SizedBox(
                      width: 20,
                    )
                  ],
                ),
                rowWithTextNButton(
                    txt1: "Conplete Your Profile",
                    txt2: "Fill",
                    check: is_profile_completed,
                    function: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BusinessSetting()));
                    }),
                rowWithTextNButton(
                    txt1: "Complete your information",
                    txt2: "Now",
                    check: is_information_completed,
                    function: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => businessInfo()));
                    }),
                rowWithTextNButton(
                    txt1: "Send for verification",
                    txt2: "Verify",
                    check: is_verified,
                    function: () {}),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: context.percentHeight * 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      card1(checkins: check_ins),
                      card2(ratings: ratings)
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: context.percentHeight * 2),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          card3(txt1: "Catalogoues", txt2: catalogoues),
                          card3(txt1: "Orders", txt2: orders)
                        ])),
                Row(children: [
                  Text(
                    "Grow your Business",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  )
                ]),
                Row(children: [
                  credit("Free Credit", free_credit, "assets/icon/warning.svg"),
                  credit("Paid Credit", paid_credit, "null")
                ]),
                for (int i = 0; i < 2; i++)
                  rowCard("Advertise",
                      "Reach new audience searching for related services"),
              ]),
            )));
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

  void calldashBoard() {
    WebService.funGetDashBoard().then((value) {
      business_id = value.businessId;
      business_name = value.businessName;
      business_status = value.businessStatus;
      is_profile_completed = value.isProfileCompleted.toString();
      is_information_completed = value.isInformationCompleted.toString();
      is_phone_verified = value.isPhoneVerified.toString();
      is_email_verified = value.isEmailVerified.toString();
      is_verified = value.isVerified.toString();
      check_ins = value.checkIns.toString();
      ratings = value.ratings.toString();
      catalogoues = value.catalogoues.toString();
      orders = value.orders.toString();
      free_credit = value.freeCredit.toString();
      paid_credit = value.paidCredit.toString();
      setState(() {});
    });
  }
}
