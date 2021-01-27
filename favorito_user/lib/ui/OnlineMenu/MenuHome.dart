import 'dart:async';
import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/Business/Category.dart';
import 'package:favorito_user/model/appModel/Menu/MenuItemModel.dart';
import 'package:favorito_user/model/appModel/Menu/MenuTabModel.dart';
import 'package:favorito_user/model/appModel/WaitList/WaitListDataModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/OnlineMenu/FloatingActionButtons.dart';
import 'package:favorito_user/ui/OnlineMenu/MenuPages.dart';
import 'package:favorito_user/ui/OnlineMenu/RequestData.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/Singletons.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:favorito_user/utils/MyString.dart';
import 'package:progress_dialog/progress_dialog.dart';

class MenuHome extends StatefulWidget {
  WaitListDataModel data;
  MenuHome({this.data});
  @override
  _MenuHomeState createState() => _MenuHomeState();
}

class _MenuHomeState extends State<MenuHome> {
  var _mySearchEditTextController = TextEditingController();
  SizeManager sm;
  var fut;
  Widget pages;
  CatItem catItems = CatItem();
  String txt = '';
  List<MenuItemModel> menuItemBaseModel = [];
  ProgressDialog pr;
  ControllerCallback controller;
  List<Category> cat = [];
  Category ca = Category();

  @override
  void initState() {
    super.initState();
    fut = APIManager.menuTabGet({'business_id': widget.data.businessId});
    catItems.buId = widget.data.businessId;
    catItems.isVeg = catItems.isVeg ?? false;
    catItems.index = catItems.index ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    Basket basket = Basket();
    sm = SizeManager(context);
    pr = ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please wait');
    return SafeArea(
      child: Scaffold(
          backgroundColor: myBackGround,
          appBar: AppBar(
            backgroundColor: myBackGround,
            elevation: 0,
            title: Text('Menu', style: TextStyle(fontFamily: 'Gilroy-Medium')),
          ),
          body: ListView(children: [
            Text(widget?.data?.businessName ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Gilroy-Medium', fontSize: 20)),
            Divider(),
            Container(
              height: 80,
              padding: EdgeInsets.all(sm.w(4)),
              child: Row(children: [
                Flexible(
                  child: EditTextComponent(
                      ctrl: _mySearchEditTextController,
                      hint: "Search for ... ",
                      security: false,
                      valid: true,
                      keyboardSet: TextInputType.text,
                      prefixIcon: 'search',
                      keyBoardAction: TextInputAction.search,
                      atSubmit: (_val) {
                        setState(() {
                          txt = _val;
                          catItems.txt = _val;
                        });
                      },
                      prefClick: () {
                        setState(() {
                          txt = _mySearchEditTextController.text;
                          catItems.txt = txt;
                        });
                      }),
                ),
                Column(children: [
                  Text(
                    'Only Veg',
                    style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'Gilroy-Medium',
                        color: myGrey),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: sm.w(2), right: sm.w(1), top: sm.h(1)),
                    child: NeumorphicSwitch(
                      value: catItems.isVeg ?? false,
                      height: sm.h(3.5),
                      style: NeumorphicSwitchStyle(
                          activeThumbColor: Colors.green,
                          activeTrackColor: Colors.green[100],
                          inactiveTrackColor: Color(0xfff4f6fc),
                          inactiveThumbColor: myBackGround),
                      onChanged: (val) {
                        setState(() {
                          catItems.isVeg = val;
                        });
                      },
                    ),
                  ),
                ])
              ]),
            ),
            FutureBuilder<MenuTabModel>(
              future: fut,
              builder:
                  (BuildContext context, AsyncSnapshot<MenuTabModel> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: Text(loading));
                else if (snapshot.hasError) {
                  return Center(child: Text(wentWrong));
                } else {
                  // if (cat.length == 1)
                  print("snapshot.data.data${snapshot.data.data.length}");
                  cat.clear();
                  ca.id = 0;
                  ca.categoryName = 'All';
                  cat.add(ca);
                  cat.addAll(snapshot.data.data);
                  return Container(
                    height: 500,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: sm.h(6),
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: cat.length,
                              itemBuilder: (BuildContext context, int index) {
                                return MaterialButton(
                                  shape: catItems.index == index
                                      ? UnderlineInputBorder()
                                      : null,
                                  onPressed: () {
                                    categorySelector(index);
                                    setState(() {});
                                  },
                                  child: Text(cat[index]?.categoryName,
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .bodyText1),
                                );
                              }),
                        ),
                        Divider(),
                        Container(height: sm.h(60), child: pages)
                      ],
                    ),
                  );
                }
              },
            )
          ]),
          floatingActionButton: FloatingActionButtons()),
    );
  }

  void categorySelector(int index) {
    catItems.index = index;
    catItems.cat = cat[index].id.toString();
    pages = MenuPage(catItem: catItems);
  }
}
