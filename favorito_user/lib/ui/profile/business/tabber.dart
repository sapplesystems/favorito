import 'package:favorito_user/model/appModel/search/BusinessProfileData.dart';
import 'package:favorito_user/ui/profile/business/tabs/CatlogTab.dart';
import 'package:favorito_user/ui/profile/business/tabs/JobTab.dart';
import 'package:favorito_user/ui/profile/business/tabs/OverviewTab.dart';
import 'package:favorito_user/ui/profile/business/tabs/ReviewTab.dart';
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
  List<String> tabs = [
    'Overview', 'Catlog',
    // 'Review',
    'Job  '
  ];
  List<Widget> pages = [];

  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: tabs.length, vsync: this);
    super.initState();
    pages = [
      OverviewTab(data: widget.data),
      CatlogTab(data: widget.data),
      // ReviewTab(data: widget.data),
      JobTab(data: widget.data)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TabBar(
            isScrollable: true,
            unselectedLabelColor: Colors.black,
            labelColor: Colors.red,
            indicatorColor: myRed,
            indicatorPadding: EdgeInsets.only(left: 16, right: 40),
            tabs: [
              for (int i = 0; i < tabs.length; i++)
                Tab(child: Text(tabs[i], style: TextStyle(fontSize: 20))),
            ],
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          Expanded(
            child: TabBarView(
              children: [
                for (int i = 0; i < tabs.length; i++) pages[i],
              ],
              controller: _tabController,
            ),
          ),
        ],
      ),
    );
  }
}
