import 'dart:ui';
import 'package:Favorito/Provider/BaseProvider.dart';
import 'package:Favorito/component/listItem.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/ui/adSpent/adspent.dart';
import 'package:Favorito/ui/setting/setting/SettingProvider.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
    spFalse.setContext(context);
    return WillPopScope(
      onWillPop: (){

        BaseProvider.onWillPop(context);
      },
          child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("Settings",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontFamily: 'Gilroy-ExtraBold',
                  letterSpacing: .2)),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          elevation: 0,
        ),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
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
                          fontFamily: 'Gilroy-Medium',
                          fontWeight: FontWeight.w800,
                          letterSpacing: .5,
                          fontSize: 18),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: AutoSizeText(
                        spTrue?.shortdescription,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        softWrap: true,
                        wrapWords: true,
                        minFontSize: 12,
                        maxFontSize: 14,
                        style: TextStyle(
                            wordSpacing: 2,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      InkWell(
                          onTap: () => spTrue.changeSettingHeight(),
                          child: Row(children: [
                            Expanded(
                                flex: 2,
                                child: SvgPicture.asset('assets/icon/set.svg',
                                    alignment: Alignment.center,
                                    height: sm.h(3))),
                            Expanded(
                                flex: 7,
                                child: Text("Business Settings",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800))),
                            Expanded(
                                flex: 1,
                                child: Icon(
                                    spFalse.settingHeight
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down,
                                    size: 28,
                                    color: Colors.black))
                          ])
                          //   ListTile(
                          //   leading: SvgPicture.asset('assets/icon/set.svg',
                          //       alignment: Alignment.center, height: sm.h(3)),
                          //   title: Text(
                          //     "Business Settings",
                          //     style: TextStyle(
                          //         fontSize: 18, fontWeight: FontWeight.w800),
                          //   ),
                          //   trailing: Icon(
                          //     spFalse.settingHeight
                          //         ? Icons.arrow_drop_up
                          //         : Icons.arrow_drop_down,
                          //     size: 28,
                          //     color: Colors.black,
                          //   ),
                          // ),
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
                                            builder: (context) =>
                                                spFalse.pages[i]));
                                  }),
                          ]),
                        ),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                          onTap: () => spTrue.changeSettingTool(),
                          child: Row(children: [
                            Expanded(
                                flex: 2,
                                child: SvgPicture.asset('assets/icon/menu.svg',
                                    alignment: Alignment.center,
                                    height: sm.h(3))),
                            Expanded(
                                flex: 7,
                                child: Text("Business Tools",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800))),
                            Expanded(
                                flex: 1,
                                child: Icon(
                                    spFalse.settingTool
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down,
                                    size: 28,
                                    color: Colors.black))
                          ])),
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
                                            builder: (context) =>
                                                spFalse.pages[_i]));
                                  })
                          ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => adSpent()));
                            },
                            child: Row(children: [
                              Expanded(
                                  flex: 2,
                                  child: SvgPicture.asset('assets/icon/horn.svg',
                                      alignment: Alignment.center,
                                      height: sm.h(3))),
                              Expanded(
                                  flex: 7,
                                  child: Text("Advertise",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800))),
                              Expanded(
                                  flex: 1,
                                  child: Icon(spFalse.settingTool ? null : null,
                                      size: 28, color: Colors.black))
                            ])

                            // ListTile(
                            //   leading: SvgPicture.asset('assets/icon/horn.svg',
                            //       alignment: Alignment.center, height: sm.h(3)),
                            //   title: Text(
                            //     "Advertise",
                            //     style: TextStyle(
                            //         fontSize: 22, fontWeight: FontWeight.w500),
                            //   ),
                            // ),
                            ),
                      ),
                      Row(children: [
                        Expanded(
                            flex: 2,
                            child: SvgPicture.asset('assets/icon/help.svg',
                                alignment: Alignment.center, height: sm.h(3))),
                        Expanded(
                            flex: 7,
                            child: Text("Help",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w800))),
                        Expanded(
                            flex: 1,
                            child: Icon(spFalse.settingTool ? null : null,
                                size: 28, color: Colors.black))
                      ]),
                      InkWell(
                        onTap: () => spFalse.logout(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(children: [
                            Expanded(
                                flex: 2,
                                child: Icon(
                                  FontAwesomeIcons.signOutAlt,
                                  color: Colors.black,
                                  size: 22,
                                )),
                            Expanded(
                                flex: 7,
                                child: Text("Logout",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800))),
                            Expanded(
                                flex: 1,
                                child: Icon(spFalse.settingTool ? null : null,
                                    size: 28, color: Colors.black))
                          ]),
                        ),
                        // ListTile(
                        //     leading: Icon(FontAwesomeIcons.signOutAlt),
                        //     title: Text("Logout",
                        //         style: TextStyle(
                        //             fontSize: 22,
                        //             fontWeight: FontWeight.w500))),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
