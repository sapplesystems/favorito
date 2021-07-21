import 'package:Favorito/component/card4.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';

class PageViews extends StatefulWidget {
  @override
  _PageViewsState createState() => _PageViewsState();
}

class _PageViewsState extends State<PageViews> {
  String branchList = "";
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 8; i++)
      branchList = branchList + "\u2022KeyWord : $i, \t";
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            "Page Views",
            style: Theme.of(context).appBarTheme.textTheme.headline1,
          ),
          centerTitle: true,
        ),
        body: Card(
          elevation: 10,
          shape: rrb28,
          child: Padding(
            padding: EdgeInsets.only(top: sm.w(4)),
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: sm.w(6)),
                  padding: EdgeInsets.only(top: sm.h(2), bottom: sm.h(2)),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    primary: false,
                    padding: const EdgeInsets.all(2),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: [
                      card4(
                          circleColor: 0xffe4efff,
                          circleIcon: "like",
                          title: "Impressions",
                          ammount: "15K",
                          icon: "arrowdrop",
                          percent: "12"),
                      card4(
                          circleColor: 0xffdecfff,
                          circleIcon: "eye",
                          title: "Page Views",
                          ammount: "33K",
                          icon: "arrowDropUp",
                          percent: "15"),
                      card4(
                          circleColor: 0xffe4efff,
                          circleIcon: "phone",
                          title: "Call Business",
                          ammount: "125K",
                          icon: "arrowdrop",
                          percent: "12"),
                      card4(
                          circleColor: 0xffffe3cf,
                          circleIcon: "speech",
                          title: "Chat Counts",
                          ammount: "500",
                          icon: "arrowDropUp",
                          percent: "15"),
                      card4(
                          circleColor: 0xfffff9c5,
                          circleIcon: "click",
                          title: "WebSite clicks",
                          ammount: "5K",
                          icon: "arrowdrop",
                          percent: "12"),
                      card4(
                          circleColor: 0xffc9fffb,
                          circleIcon: "direction",
                          title: "Directions Clicks",
                          ammount: "2K",
                          icon: "arrowDropUp",
                          percent: "15"),
                      card4(
                          circleColor: 0xffe3f8fa,
                          circleIcon: "checkin",
                          title: "Check-ins",
                          ammount: "1.5K",
                          icon: "arrowdrop",
                          percent: "12"),
                      card4(
                          circleColor: 0xffffe6e2,
                          circleIcon: "follow",
                          title: "Followers",
                          ammount: "900",
                          icon: "arrowDropUp",
                          percent: "15"),
                      card4(
                          circleColor: 0xfff9ddf0,
                          circleIcon: "heart",
                          title: "Fevorites",
                          ammount: "3K",
                          icon: "arrowdrop",
                          percent: "12"),
                      card4(
                          circleColor: 0xffe4efff,
                          circleIcon: "ratings",
                          title: "Ratings",
                          ammount: "450",
                          icon: "arrowDropUp",
                          percent: "15"),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    children: <Widget>[
                      Text("Top KeyWords",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: sm.h(2), horizontal: sm.h(3)),
                        child: Text(branchList,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.w400)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
