import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/Business/Category.dart';
import 'package:favorito_user/ui/OnlineMenu/MenuPages.dart';
import 'package:favorito_user/ui/OnlineMenu/RequestData.dart';
// import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class MenuTabs extends StatefulWidget {
  List<Category> data;
  var onlyVeg;
  String id;
  MenuTabs({this.data, this.onlyVeg, this.id});

  @override
  profilePageState createState() => profilePageState();
}

class profilePageState extends State<MenuTabs>
    with SingleTickerProviderStateMixin {
  SizeManager sm;
  List<Category> tabs = [];
  Widget pages;
  CatItemReq catItemReq = CatItemReq();
  var selected = 0;

  @override
  void initState() {
    tabs.addAll(widget.data);
    super.initState();
    catItemReq.id = widget.id;
    catItemReq.cat = tabs[0].id;
    pages = MenuPages(catItemReq: catItemReq, isVeg: widget.onlyVeg);
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: sm.h(6),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tabs.length,
              itemBuilder: (BuildContext context, int index) {
                return MaterialButton(
                  shape: selected == index ? UnderlineInputBorder() : null,
                  onPressed: () {
                    selected = index;
                    catItemReq.cat = tabs[index].id;

                    setState(() {
                      pages = MenuPages(
                          catItemReq: catItemReq, isVeg: widget.onlyVeg);
                    });
                  },
                  child: Text(tabs[index].categoryName ?? 'null',
                      style: Theme.of(context).primaryTextTheme.bodyText1
                      // TextStyle(fontSize: 20)
                      ),
                );
              }),
        ),
        Divider(),
        Container(height: sm.h(60), child: pages)
      ],
    );
  }
}
