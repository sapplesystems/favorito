import 'dart:ui';
import 'package:Favorito/component/listItem.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/ui/PageViews/PageViews.dart';
import 'package:Favorito/ui/adSpent/adspent.dart';
import 'package:Favorito/ui/appoinment/appoinment.dart';
import 'package:Favorito/ui/catalog/Catalogs.dart';
import 'package:Favorito/ui/claim/buisnessClaim.dart';
import 'package:Favorito/ui/contactPerson/ContactPerson.dart';
import 'package:Favorito/ui/highlights/highlights.dart';
import 'package:Favorito/ui/jobs/JobList.dart';
import 'package:Favorito/ui/login/login.dart';
import 'package:Favorito/ui/offer/Offers.dart';
import 'package:Favorito/ui/setting/businessInfo/businessInfo.dart';
import 'package:Favorito/ui/setting/BusinessProfile/businessProfile.dart';
import 'package:Favorito/ui/waitlist/Waitlist.dart';
import 'package:Favorito/utils/Prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/utils/myString.Dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class setting extends StatefulWidget {
  @override
  _settingState createState() => _settingState();
}

class _settingState extends State<setting> {
  List<String> _title = [
    "Bussiness Profile",
    "Bussiness Information",
    "Claim Bussiness",
    "Owner Profile",
    "Create Offer",
    "Jobs",
    "Waitlist",
    "catalogs",
    "Create Highlights",
    "Page View",
    "Appoinment",
    "Ch"
  ];
  List<String> _icon = [
    "shop",
    "circlenotyfy",
    "claim",
    "owner",
    "offer",
    "jobs",
    "waiting",
    "catlog",
    "highlights",
    "eye",
    "eye"
  ];
  List<Widget> _pages = [
    BusinessProfile(),
    businessInfo(),
    BusinessClaim(),
    ContactPerson(),
    Offers(),
    JobList(),
    Waitlist(),
    Catalogs(),
    highlights(),
    PageViews(),
    Appoinment()
  ];
  double settingHeight = 0.0;
  double settingTool = 0.0;

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Settings", style: titleStyle),
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
                  child: CircleAvatar(
                    radius: sm.w(8),
                    backgroundImage: NetworkImage(photoUrl = photoUrl ?? ''),
                  ),
                ),
                title: Text(
                  business_name,
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
                  InkWell(
                    onTap: () {
                      double _v = settingHeight == 0.0 ? 168.0 : 0.0;
                      setState(() => settingHeight = _v);
                    },
                    child: ListTile(
                      leading: SvgPicture.asset('assets/icon/set.svg',
                          alignment: Alignment.center, height: sm.h(3)),
                      title: Text(
                        "Business Settings",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w500),
                      ),
                      trailing: Icon(
                        settingHeight != 0
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        size: 28,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    height: settingHeight,
                    padding: EdgeInsets.symmetric(horizontal: sm.w(14)),
                    child: Column(children: [
                      for (int i = 0; i < 4; i++)
                        listItems(
                            title: _title[i],
                            ico: _icon[i],
                            clicker: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => _pages[i]));
                            }),
                    ]),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      double _v = settingTool == 0.0 ? 300.0 : 0.0;
                      setState(() => settingTool = _v);
                    },
                    child: ListTile(
                      leading: SvgPicture.asset('assets/icon/menu.svg',
                          alignment: Alignment.center, height: sm.h(3)),
                      title: Text(
                        "Business Tools",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w500),
                      ),
                      trailing: Icon(
                        settingTool != 0
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        size: 28,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    height: settingTool,
                    padding: EdgeInsets.symmetric(horizontal: sm.w(14)),
                    child: Column(children: [
                      for (int _i = 4; _i < 11; _i++)
                        listItems(
                            title: _title[_i],
                            ico: _icon[_i],
                            clicker: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => _pages[_i]));
                            })
                    ]),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => adSpent()));
                    },
                    child: ListTile(
                      leading: SvgPicture.asset('assets/icon/horn.svg',
                          alignment: Alignment.center, height: sm.h(3)),
                      title: Text(
                        "Advertise",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: SvgPicture.asset('assets/icon/help.svg',
                        alignment: Alignment.center, height: sm.h(3)),
                    title: Text(
                      "Help",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Prefs().clear();
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: ListTile(
                      leading: Icon(FontAwesomeIcons.signOutAlt),
                      title: Text(
                        "Logout",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w500),
                      ),
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
    SizeManager sm = SizeManager(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: clicker,
        child: Row(
          children: [
            SvgPicture.asset(ico, alignment: Alignment.center, height: sm.h(3)),
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
