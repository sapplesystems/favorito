import 'dart:async';

import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/Menu/MenuItemModel.dart';
import 'package:favorito_user/model/appModel/Menu/MenuTabModel.dart';
import 'package:favorito_user/model/appModel/WaitList/WaitListDataModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/OnlineMenu/MenuTabs.dart';
import 'package:favorito_user/ui/OnlineMenu/RequestData.dart';
import 'package:favorito_user/utils/MyColors.dart';
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
  bool isVegOnly = false;
  var fut;
  CatItem catItem = CatItem();
  String txt = '';
  List<MenuItemModel> menuItemBaseModel = [];
  ProgressDialog pr;
  MenuTabs k = MenuTabs();
  ControllerCallback controller;
  // var child = MenuTabsState();
  @override
  void initState() {
    super.initState();
    fut = APIManager.menuTabGet({'business_id': widget.data.businessId});
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    pr = ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Fetching Data, please wait');
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
                    hint: "Search for ...",
                    security: false,
                    valid: true,
                    keyboardSet: TextInputType.text,
                    prefixIcon: 'search',
                    keyBoardAction: TextInputAction.search,
                    atSubmit: (_val) {
                      setState(() {
                        txt = _val;
                        catItem.txt = _val;
                      });
                      // child.tabselection(catItem);
                    },
                    prefClick: () {
                      setState(() {
                        txt = _mySearchEditTextController.text;
                        catItem.txt = txt;
                      });
                    }),
              ),
              Column(children: [
                Text(
                  'Only Veg',
                  style: TextStyle(
                      fontSize: 10, fontFamily: 'Gilroy-Medium', color: myGrey),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: sm.w(2), right: sm.w(1), top: sm.h(1)),
                  child: NeumorphicSwitch(
                    value: isVegOnly,
                    height: sm.h(3.5),
                    style: NeumorphicSwitchStyle(
                        activeThumbColor: Colors.green,
                        activeTrackColor: Colors.green[100],
                        inactiveTrackColor: Color(0xfff4f6fc),
                        inactiveThumbColor: myBackGround),
                    onChanged: (val) {
                      setState(() {
                        isVegOnly = val;
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
                print("snapshot.data.data:${widget.data}");
                return Container(
                  height: 500,
                  child: MenuTabs(
                    data: snapshot.data.data,
                    onlyVeg: "${isVegOnly ? 1 : 0}",
                    id: widget.data.businessId,
                    txt: txt,
                    selectedCat: (val) {
                      catItem = val;
                    },
                  ),
                );
              }
            },
          )
        ]),
      ),
    );
  }
}
