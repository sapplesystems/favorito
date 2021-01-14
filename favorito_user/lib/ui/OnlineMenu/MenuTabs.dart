import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/Business/Category.dart';
import 'package:favorito_user/ui/OnlineMenu/MenuPages.dart';
import 'package:favorito_user/ui/OnlineMenu/RequestData.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class MenuTabs extends StatefulWidget {
  List<Category> data;
  String onlyVeg;
  String id;
  Function selectedCat;
  String txt;
  MenuTabs({
    this.data,
    this.onlyVeg,
    this.id,
    this.selectedCat,
    this.txt,
  });

  @override
  _MenuTabsState createState() => _MenuTabsState();
}

class _MenuTabsState extends State<MenuTabs>
    with SingleTickerProviderStateMixin {
  SizeManager sm;
  List<Category> tabs = [];
  Widget pages;
  CatItem catItem = CatItem();
  var selected = 0;
  Category allCat = Category();

  @override
  void initState() {
    allCat.id = 0;
    allCat.categoryName = 'All';
    tabs.add(allCat);
    tabs.addAll(widget.data);
    super.initState();
    catItem.id = widget.id;
    catItem.cat = tabs[0].id.toString();
    pages = MenuPage(catItem: catItem);

    catItem.txt = widget.txt;
    catItem.isVeg = widget.onlyVeg;
    tabselection(catItem);
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
                    catItem.cat = tabs[index].id.toString();
                    catItem.index = index.toString();
                    tabselection(catItem);
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

  tabselection(CatItem catItem) {
    widget.selectedCat(catItem);
    print("called");
    setState(() {
      pages = MenuPage(catItem: catItem);
    });
  }
}
