import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/ui/home/hotAndNewBusiness.dart';
import 'package:favorito_user/ui/search/SearchResult.dart';
import 'package:favorito_user/ui/search/TopRated.dart';
import 'package:favorito_user/ui/search/TrendingNearby.dart';
import 'package:favorito_user/ui/search/mostPopular.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../../utils/Extentions.dart';

class Search extends StatefulWidget {
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var _mySearchEditTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Container(
      height: sm.h(100),
      decoration: BoxDecoration(color: myBackGround),
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding:
                EdgeInsets.only(right: sm.h(5), top: sm.h(5), left: sm.h(5)),
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
            // height: sm.h(28),
            child: Padding(
              padding: EdgeInsets.only(bottom: sm.h(2)),
              child: HotAndNewBusiness(),
            ),
          ),
          header(sm, "Top Rated"),
          Container(
            height: sm.h(35),
            child: Padding(
              padding: EdgeInsets.only(bottom: sm.h(2)),
              child: TopRated(sm: sm),
            ),
          ),
          header(sm, "Most Popular"),
          Container(
            height: sm.h(32),
            padding: EdgeInsets.only(bottom: sm.h(2)),
            child: MostPopular(),
          ),
        ],
      ),
    ).safe();
  }

  Widget header(SizeManager sm, String title) {
    return Padding(
      padding: EdgeInsets.all(sm.w(5)),
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
}
