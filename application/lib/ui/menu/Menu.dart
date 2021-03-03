import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/model/menu/Category.dart';
import 'package:Favorito/model/menu/MenuBaseModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/menu/CategoryPage.dart';
import 'package:Favorito/ui/menu/MenuSetting.dart';
import 'package:Favorito/ui/menu/MenuSwitch.dart';
import 'package:Favorito/ui/menu/item/MenuItem.dart';
import 'package:Favorito/ui/menu/item/NewMenuItem.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../../utils/myString.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final _mySearchEditController = TextEditingController();
  SizeManager sm;
  Map _dataMap = Map();
  ProgressDialog pr;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(
        message: 'Please wait...',
        borderRadius: 8.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 8.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: myRed, fontSize: 19.0, fontWeight: FontWeight.w600));
    return Scaffold(
      body: FutureBuilder<MenuBaseModel>(
        future: WebService.funMenuList(context),
        builder: (BuildContext context, AsyncSnapshot<MenuBaseModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: Text(loading));
          else if (snapshot.hasError)
            return Center(child: Text("Something went wrong.."));
          else {
            _dataMap.clear();
            for (var key in snapshot.data.data)
              _dataMap[key.categoryName ??
                  '' + '|' + key.categoryId.toString() ??
                  '' + '|' + key.outOfStock.toString() ??
                  ''] = key.items;
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  title: Text(
                    snapshot.data.businessType == 3
                        ? "Menu"
                        : snapshot.data.businessType == 4
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
                                    showVeg: snapshot.data.businessType == 3)));
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
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                            controller: _mySearchEditController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Search ",
                                enabled: false,
                                suffixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ))),
                      ),
                      Container(
                        height: sm.h(70),
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, bottom: 16, top: 0),
                        child: ListView(
                          // shrinkWrap: true,
                          children: <Widget>[
                            Column(children: [
                              for (var key in _dataMap.keys)
                                _header(key, _dataMap[key], snapshot.data)
                            ]),
                          ],
                        ),
                      ),
                    ]),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _header(String title, List<Items> childList, MenuBaseModel snapshot) {
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoryPage(
                              title: title.split('|')[0],
                              id: title.split('|')[1],
                            ))).whenComplete(() => setState(() {}));
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
                              builder: (context) => MenuItem(
                                  child.id, snapshot.businessType == 3)))
                      .whenComplete(() {
                    setState(() {});
                  });
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
