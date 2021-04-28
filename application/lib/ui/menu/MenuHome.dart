import 'package:Favorito/Provider/BaseProvider.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/model/menu/Category.dart';
import 'package:Favorito/model/menu/MenuBaseModel.dart';
import 'package:Favorito/ui/menu/CategoryPage.dart';
import 'package:Favorito/ui/menu/MenuProvider.dart';
import 'package:Favorito/ui/menu/MenuSetting.dart';
import 'package:Favorito/ui/menu/MenuSwitch.dart';
import 'package:Favorito/ui/menu/item/MenuItem.dart';
import 'package:Favorito/ui/menu/item/NewMenuItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MenuHome extends StatelessWidget {
  MenuProvider vaTrue;
  bool isFirst = true;
  SizeManager sm;
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    vaTrue = Provider.of<MenuProvider>(context, listen: true);
    if (isFirst) {
      vaTrue.getMenuList();
      isFirst = false;
    }
    return WillPopScope(
      onWillPop: () {
        BaseProvider.onWillPop(context);
      },
      child: Scaffold(
        body: Consumer<MenuProvider>(
          builder: (context, data, child) {
            return RefreshIndicator(
              onRefresh: () async {
                data.getMenuList();
              },
              child: Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  title: Text(
                    data.menuBaseModel.businessType == 3
                        ? "Menu"
                        : data.menuBaseModel.businessType == 4
                            ? "Online Store"
                            : "",
                    style: Theme.of(context).textTheme.title,
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.add_circle_outline,
                        size: sm.w(8.8),
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewMenuItem(
                                    showVeg:
                                        data.menuBaseModel.businessType == 3)));
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: sm.w(2)),
                      child: IconButton(
                          icon: SvgPicture.asset(
                              'assets/icon/settingWaitlist.svg',
                              height: sm.w(7.8)),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MenuSetting()))),
                    )
                  ],
                ),
                body: ListView(
                    // physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Container(
                        height: 86,
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                            controller: data.mySearchEditController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                hintText: "Search ",
                                suffixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ))),
                      ),
                      Container(
                        height: sm.h(70),
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, bottom: 16, top: 0),
                        child: ListView(children: <Widget>[
                          Column(children: [
                            for (var key in data.dataMap.keys)
                              _header(key, data.dataMap[key],
                                  data.menuBaseModel, context)
                          ]),
                        ]),
                      ),
                    ]),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _header(
      String title, List<Items> childList, MenuBaseModel snapshot, context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title.split('|')[0],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
          Padding(
            padding: EdgeInsets.only(right: sm.w(2.2)),
            child: InkWell(
              onTap: () {
                print('title${title}');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoryPage(
                              title: title.split('|')[0],
                              id: int.parse(title.split('|')[1]),
                            )));
              },
              child: Text(
                "Edit",
                style: TextStyle(color: Colors.red),
              ),
            ),
          )
        ]),
        for (var child in childList)
          Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MenuItem(child.id, snapshot.businessType == 3)));
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: snapshot.businessType == 3,
                        child: child.type == "Veg"
                            ? SvgPicture.asset('assets/icon/foodTypeVeg.svg',
                                height: 18)
                            : SvgPicture.asset('assets/icon/foodTypeNonVeg.svg',
                                height: 18),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: sm.w(4)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(child.title),
                              Text("\u{20B9}" + child.price.toString()),
                            ],
                          ),
                        ),
                      ),
                      MenuSwitch(id: child.id.toString(), title: title)
                    ],
                  ),
                ),
              ),
              Divider()
            ],
          )
      ]),
    );
  }
}
