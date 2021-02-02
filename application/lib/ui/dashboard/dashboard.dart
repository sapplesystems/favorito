import 'dart:ui';
import 'package:Favorito/component/card1.dart';
import 'package:Favorito/component/card2.dart';
import 'package:Favorito/component/cart3.dart';
import 'package:Favorito/component/rowWithTextNButton.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/catalog/Catalogs.dart';
import 'package:Favorito/ui/checkins/checkins.dart';
import 'package:Favorito/ui/claim/buisnessClaim.dart';
import 'package:Favorito/ui/order/Orders.dart';
import 'package:Favorito/ui/review/reviewList.dart';
import 'package:Favorito/ui/setting/businessInfo/businessInfo.dart';
import 'package:Favorito/ui/setting/BusinessProfile/businessProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/utils/myString.Dart';
import 'package:Favorito/utils/myColors.dart';

class dashboard extends StatefulWidget {
  @override
  _dashboardState createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  SizeManager sm;
  @override
  void initState() {
    super.initState();
    calldashBoard();
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
                "Dashboard",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.title,
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
        body: RefreshIndicator(
          onRefresh: () => calldashBoard(),
          backgroundColor: Colors.amber,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: sm.w(4)),
              child: ListView(children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: sm.h(2)),
                  child: Row(
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
                ),
                rowWithTextNButton(
                    txt1: "Complete Your Profile",
                    txt2: "Fill",
                    check: is_profile_completed,
                    function: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BusinessProfile()));
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
                Visibility(
                  visible: is_verified == "0" ? true : false,
                  child: rowWithTextNButton(
                      txt1: "Send for verification",
                      txt2: "Verify",
                      check: is_verified,
                      function: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BusinessClaim()));
                      }),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: sm.h(2)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      card1(
                          checkins: check_ins,
                          function: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => checkins()));
                          }),
                      card2(
                        ratings: ratings,
                        function: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => reviewList()));
                        },
                      )
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: sm.h(2)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Catalogs()));
                              },
                              child: card3(
                                  txt1: "Catalogoues", title: catalogoues)),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Orders()));
                              },
                              child: card3(txt1: "Orders", title: orders))
                        ])),
                Row(children: [
                  Text(
                    "Grow your Business",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  )
                ]),
                Row(children: [
                  credit("Free Credit", free_credit, "assets/icon/warning.svg"),
                  credit("Paid Credit", paid_credit, "assets/icon/warning.svg")
                ]),
                rowCard("Advertise",
                    "Reach new audience searching for related services", () {}),
                rowCard(
                    "Notifications", "Send Direct Update to Customer", () {}),
              ])),
        ));
  }

  Widget rowCard(String title, String subtitle, Function function) => InkWell(
        onTap: function,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 6),
            margin: EdgeInsets.symmetric(vertical: 12),
            decoration: bd3,
            child: ListTile(
                title: Text(title,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                subtitle: Text(subtitle))),
      );

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

  calldashBoard() async {
    await WebService.funGetDashBoard(context).then((value) {
      business_id = value.businessId;
      business_name = value.businessName;
      business_status = value.businessStatus;
      photoUrl = value.photo;
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
