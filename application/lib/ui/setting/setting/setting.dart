import 'dart:ui';
import 'package:Favorito/component/listItem.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/ui/adSpent/adspent.dart';
import 'package:Favorito/ui/login/login.dart';
import 'package:Favorito/ui/setting/BusinessProfile/BusinessHoursProvider.dart';
import 'package:Favorito/ui/setting/BusinessProfile/BusinessProfileProvider.dart';
import 'package:Favorito/ui/setting/setting/SettingProvider.dart';
import 'package:Favorito/utils/Prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/utils/myString.Dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Setting extends StatelessWidget {
  SettingProvider spTrue;
  SettingProvider spFalse;
  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    spTrue = Provider.of<SettingProvider>(context, listen: true);
    spFalse = Provider.of<SettingProvider>(context, listen: false);
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
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Card(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  leading: Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: CircleAvatar(
                        radius: sm.w(8),
                        backgroundImage: NetworkImage(spTrue?.photo)),
                  ),
                  title: Text(
                    business_name,
                    style: TextStyle(
                        wordSpacing: 2,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  subtitle: Text(
                    spTrue?.shortdescription,
                    style: TextStyle(wordSpacing: 2, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: bd1,
            margin: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              children: [
                InkWell(
                  onTap: () => spTrue.changeSettingHeight(),
                  child: ListTile(
                    leading: SvgPicture.asset('assets/icon/set.svg',
                        alignment: Alignment.center, height: sm.h(3)),
                    title: Text(
                      "Business Settings",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                    trailing: Icon(
                      spFalse.settingHeight
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      size: 28,
                      color: Colors.black,
                    ),
                  ),
                ),
                Visibility(
                  visible: spFalse.settingHeight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: sm.w(14)),
                    child: Column(children: [
                      for (int i = 0; i < 4; i++)
                        listItems(
                            title: spFalse.title[i],
                            ico: spFalse.icon[i],
                            clicker: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => spFalse.pages[i]));
                            }),
                    ]),
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () => spTrue.changeSettingTool(),
                  child: ListTile(
                    leading: SvgPicture.asset('assets/icon/menu.svg',
                        alignment: Alignment.center, height: sm.h(3)),
                    title: Text(
                      "Business Tools",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                    trailing: Icon(
                      spFalse.settingTool != 0
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      size: 28,
                      color: Colors.black,
                    ),
                  ),
                ),
                Visibility(
                  visible: spFalse.settingTool,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: sm.w(14)),
                    child: Column(children: [
                      for (int _i = 4; _i < 10; _i++)
                        listItems(
                            title: spFalse.title[_i],
                            ico: spFalse.icon[_i],
                            clicker: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => spFalse.pages[_i]));
                            })
                    ]),
                  ),
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
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                ListTile(
                  leading: SvgPicture.asset('assets/icon/help.svg',
                      alignment: Alignment.center, height: sm.h(3)),
                  title: Text(
                    "Help",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Prefs().clear();
                    Provider.of<BusinessProfileProvider>(context, listen: false)
                        .allClear();
                    Provider.of<BusinessHoursProvider>(context, listen: false)
                        .allClear();
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: ListTile(
                    leading: Icon(FontAwesomeIcons.signOutAlt),
                    title: Text(
                      "Logout",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
