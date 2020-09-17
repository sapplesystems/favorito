import 'dart:ui';

import 'package:application/component/card1.dart';
import 'package:application/component/card2.dart';
import 'package:application/component/cart3.dart';
import 'package:application/network/webservices.dart';
import 'package:application/ui/setting/businessSetting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:application/utils/myString.Dart';

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
                    Text(
                        is_verified == "0"
                            ? "Offline"
                            : is_verified == "1" ? "Live" : "Blocked",
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
                    "Conplete Your Profile", "Fill", is_profile_completed, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BusinessSetting()));
                }),
                rowWithTextNButton("Complete your information", "Now",
                    is_information_completed, () {}),
                rowWithTextNButton(
                    "Send for verification", "Verify", is_verified, () {}),
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

  Widget rowWithTextNButton(
      String txt1, String txt2, String check, Function function) {
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
            onTap: function,
            child: Visibility(
              visible: check == "0" ? true : false,
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
