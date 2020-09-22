import 'dart:ui';

import 'package:application/component/listItem.dart';
import 'package:application/myCss.dart';
import 'package:application/ui/catalog/Catalogs.dart';
import 'package:application/ui/jobs/JobList.dart';
import 'package:application/ui/businessInfo/businessInfo.dart';
import 'package:application/ui/notification/Notifications.dart';
import 'package:application/ui/offer/CreateOffer.dart';
import 'package:application/ui/setting/businessSetting.dart';
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
        title: Text(
          "Settings",
          style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: bd1,
              margin: EdgeInsets.symmetric(horizontal: 14),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Image.asset(
                    'assets/icon/foodcircle.png',
                    fit: BoxFit.cover,
                    height: context.percentWidth * 200,
                  ),
                ),
                title: Text(
                  "Avadh Group",
                  style: TextStyle(
                      wordSpacing: 2,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                subtitle: Text(
                  "We are buggest food chain vased is Surat Gujrat",
                  style: TextStyle(wordSpacing: 2, fontSize: 16),
                ),
              ),
            ),
            Container(
              decoration: bd1,
              margin: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  ListTile(
                    leading: SvgPicture.asset('assets/icon/set.svg',
                        alignment: Alignment.center,
                        height: context.percentHeight * 3),
                    title: Text(
                      "Business Settings",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                    trailing: Icon(
                      Icons.arrow_drop_up,
                      size: 28,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: context.percentWidth * 14),
                    child: Column(children: [
                      listItems(
                          title: "Bussiness Profile",
                          ico: "shop",
                          clicker: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BusinessSetting()));
                          }),
                      listItems(
                          title: "Bussiness Information",
                          ico: "circlenotyfy",
                          clicker: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => businessInfo()));
                          }),
                      listItems(
                          title: "Claim Bussiness",
                          ico: "claim",
                          clicker: () {}),
                      listItems(
                          title: "Owner Profile", ico: "owner", clicker: () {}),
                    ]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    leading: SvgPicture.asset('assets/icon/menu.svg',
                        alignment: Alignment.center,
                        height: context.percentHeight * 3),
                    title: Text(
                      "Business Tools",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                    trailing: Icon(
                      Icons.arrow_drop_up,
                      size: 28,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: context.percentWidth * 14),
                    child: Column(children: [
                      listItems(
                          title: "Create Offer",
                          ico: "offer",
                          clicker: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateOffer()));
                          }),
                      listItems(
                          title: "Jobs",
                          ico: "jobs",
                          clicker: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => JobList()));
                          }),
                      listItems(
                          title: "Waitlist", ico: "waiting", clicker: () {}),
                      listItems(
                          title: "catalogs",
                          ico: "catlog",
                          clicker: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Catalogs()));
                          }),
                      listItems(
                          title: "Create Notification",
                          ico: "bell",
                          clicker: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Notifications()));
                          }),
                      listItems(
                          title: "Create Highlights",
                          ico: "highlights",
                          clicker: () {}),
                      listItems(title: "Page View", ico: "eye", clicker: () {}),
                    ]),
                  ),
                  ListTile(
                    leading: SvgPicture.asset('assets/icon/horn.svg',
                        alignment: Alignment.center,
                        height: context.percentHeight * 3),
                    title: Text(
                      "Advertise",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                  ),
                  ListTile(
                    leading: SvgPicture.asset('assets/icon/help.svg',
                        alignment: Alignment.center,
                        height: context.percentHeight * 3),
                    title: Text(
                      "Help",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget listElement(String ico, String title, Function clicker) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: clicker,
        child: Row(
          children: [
            SvgPicture.asset(ico,
                alignment: Alignment.center, height: context.percentHeight * 3),
            SizedBox(
              width: 20,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}
