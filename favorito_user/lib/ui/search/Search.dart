import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/home/hotAndNewBusiness.dart';
import 'package:favorito_user/ui/search/SearchReqData.dart';
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
    return WillPopScope(
      onWillPop: () => APIManager.onWillPop(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xffF9FAFF),
          body: ListView(
            children: [
              Container(
                height: sm.h(10.8),
                padding: EdgeInsets.only(
                    right: sm.h(3), top: sm.h(2), left: sm.h(3), bottom: 0),
                child: EditTextComponent(
                  controller: _mySearchEditTextController,
                  title: "Search for ...",
                  security: false,
                  maxLines: 1,
                  maxlen: 100,
                  suffixTxt: '',
                  prefixIcon: 'search',
                  keyBoardAction: TextInputAction.search,
                  atSubmit: (_val) {
                    Navigator.of(context).pushNamed('/searchResult',
                        arguments: SearchReqData(
                            text: _mySearchEditTextController.text ?? ''));
                  },
                  prefClick: () {
                    Navigator.of(context).pushNamed('/searchResult',
                        arguments: SearchReqData(
                            text: _mySearchEditTextController.text ?? ''));
                  },
                ),
              ),
              Container(
                height: sm.h(82),
                decoration: BoxDecoration(color: myBackGround),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    header(sm, "Trending Nearby"),
                    trendingNearby(),
                    header(sm, "Hot & New Business"),
                    Container(
                      height: sm.h(28),
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
              ).safe(),
            ],
          ),
        ),
      ),
    );
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
