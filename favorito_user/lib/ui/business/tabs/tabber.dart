import 'package:favorito_user/model/appModel/search/BusinessProfileData.dart';

import 'package:favorito_user/ui/business/tabs/CatalogTab.dart';
import 'package:favorito_user/ui/business/tabs/JobTab.dart';
import 'package:favorito_user/ui/business/tabs/OverviewTab.dart';
import 'package:favorito_user/ui/business/tabs/Review/ReviewTab.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class Tabber extends StatefulWidget {
  BusinessProfileData data;
  Tabber({this.data});

  @override
  profilePageState createState() => profilePageState();
}

class profilePageState extends State<Tabber>
    with SingleTickerProviderStateMixin {
  List<String> tabs = ['Overview', 'Catlog', 'Review', 'Job  '];
  List<Widget> pages = [];

  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: tabs.length, vsync: this);
    super.initState();
    pages = [
      OverviewTab(data: widget.data),
      CatalogTab(data: widget.data),
      ReviewTab(data: widget.data),
      JobTab()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          isScrollable: true,
          unselectedLabelColor: myGreyLight,
          labelColor: Colors.red,
          indicatorColor: myRed,
          indicatorPadding: EdgeInsets.only(left: 16, right: 40),
          tabs: [
            for (int i = 0; i < tabs.length; i++)
              Tab(
                  child: Text(tabs[i],
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy-Regular'))),
          ],
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        Expanded(
          child: TabBarView(children: [
            for (int i = 0; i < tabs.length; i++) pages[i],
          ], controller: _tabController),
        ),
      ],
    );
  }
}
