import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/ui/home/hotAndNewBusiness.dart';
import 'package:favorito_user/ui/search/SearchResult.dart';
import 'package:favorito_user/ui/search/TrendingNearby.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class Search extends StatefulWidget {
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var _mySearchEditTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return SafeArea(
      child: Container(
        height: sm.scaledHeight(100),
        decoration: BoxDecoration(color: myBackGround),
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: sm.scaledWidth(5),
                  right: sm.scaledWidth(5),
                  top: sm.scaledHeight(5)),
              child: EditTextComponent(
                ctrl: _mySearchEditTextController,
                title: "Search for ...",
                security: false,
                valid: true,
                prefixIcon: 'search',
                prefClick: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SearchResult(_mySearchEditTextController.text)));
                },
              ),
            ),
            header(sm, "Trending Nearby"),
            trendingNearby(),
            header(sm, "Hot & New Business"),
            Container(
              height: sm.scaledHeight(26),
              child: Padding(
                padding: EdgeInsets.only(bottom: sm.scaledHeight(2)),
                child: HotAndNewBusiness(),
              ),
            ),
            header(sm, "Top Rated"),
            Container(
              height: sm.scaledHeight(35),
              child: Padding(
                padding: EdgeInsets.only(bottom: sm.scaledHeight(2)),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (var i = 0; i < 5; i++)
                      InkWell(
                        onTap: () {},
                        child: topRatedChild(sm),
                      ),
                  ],
                ),
              ),
            ),
            header(sm, "Most Popular"),
            Container(
              height: sm.scaledHeight(32),
              child: Padding(
                padding: EdgeInsets.only(bottom: sm.scaledHeight(2)),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (var i = 0; i < 5; i++)
                      InkWell(
                        onTap: () {},
                        child: mostPopularChild(sm),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget header(SizeManager sm, String title) {
    return Padding(
      padding: EdgeInsets.all(sm.scaledWidth(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          InkWell(
            onTap: () {},
            child: Text(
              "View all",
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }

  Widget topRatedChild(SizeManager sm) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            elevation: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              child: Image.network(
                "https://source.unsplash.com/random/600*400",
                height: sm.scaledHeight(20),
                fit: BoxFit.cover,
                width: sm.scaledWidth(32),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: sm.scaledWidth(2), top: sm.scaledHeight(1)),
            child: Text("Orange",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
          ),
          Padding(
            padding: EdgeInsets.only(left: sm.scaledWidth(2)),
            child: Text("Restaurant",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
          ),
          Padding(
            padding: EdgeInsets.only(left: sm.scaledWidth(1)),
            child: Row(
              children: [for (var i = 0; i < 5; i++) Icon(Icons.star)],
            ),
          ),
        ],
      ),
    );
  }

  Widget mostPopularChild(SizeManager sm) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            elevation: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              child: Image.network(
                "https://source.unsplash.com/random/600*400",
                height: sm.scaledHeight(16),
                fit: BoxFit.cover,
                width: sm.scaledWidth(34),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: sm.scaledWidth(2), top: sm.scaledHeight(1)),
            child: Text("Eggeterian",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
          ),
          Padding(
            padding: EdgeInsets.only(left: sm.scaledWidth(2)),
            child: Text("Cafe | Restro",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
          ),
          Padding(
            padding: EdgeInsets.only(left: sm.scaledWidth(2)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              width: sm.scaledWidth(18),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Icon(Icons.star),
                Text(
                  "4.6",
                  style: TextStyle(color: Colors.green),
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
