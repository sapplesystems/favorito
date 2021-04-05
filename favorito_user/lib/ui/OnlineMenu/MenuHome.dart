import 'dart:async';
import 'package:favorito_user/Providers/MenuHomeProvider.dart';
import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/Menu/MenuItemModel.dart';
import 'package:favorito_user/ui/OnlineMenu/FloatingActionButtons.dart';
import 'package:favorito_user/ui/OnlineMenu/MenuPages.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class MenuHome extends StatelessWidget {
  var _mySearchEditTextController = TextEditingController();
  SizeManager sm;

  List<MenuItemModel> menuItemBaseModel = [];
  ProgressDialog pr;
  ControllerCallback controller;
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    pr = ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please wait');

    var vaTrue = Provider.of<MenuHomeProvider>(context, listen: true);
    var vaFalse = Provider.of<MenuHomeProvider>(context, listen: false);
    vaTrue.userOrderCreateVerbose();
    vaTrue.getMenuData();
    return SafeArea(
      child: Scaffold(
        backgroundColor: myBackGround,
        appBar: myAppBar(),
        body: RefreshIndicator(
          onRefresh: () async {
            vaTrue.notifyListeners();
          },
          child: ListView(children: [
            Text(vaFalse.getBusinessName() ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Gilroy-Medium', fontSize: 20)),
            Divider(),
            search(vaFalse, vaTrue),
            Container(
              height: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      height: sm.h(6),
                      child: Consumer<MenuHomeProvider>(
                        builder: (context, data, child) {
                          if (data.cat.length == 0) vaTrue.notifyListeners();

                          return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: data.cat.length,
                              itemBuilder: (BuildContext context, int index) {
                                return MaterialButton(
                                  shape: vaTrue.catItems.selectedCatId == index
                                      ? UnderlineInputBorder()
                                      : null,
                                  onPressed: () {
                                    vaFalse.categorySelector(index);
                                    vaFalse.notifyListeners();
                                  },
                                  child: Text(vaTrue.cat[index]?.categoryName,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: data.cat[index].outOfStock == 1
                                            ? myGrey
                                            : null,
                                        fontFamily: 'Gilroy-Medium',
                                      )),
                                );
                              });
                        },
                      )),
                  Divider(),
                  Container(height: sm.h(60), child: MenuPage())
                ],
              ),
            )
          ]),
        ),
        floatingActionButton: FloatingActionButtons(),
      ),
    );
  }

  myAppBar() {
    return AppBar(
        backgroundColor: myBackGround,
        elevation: 0,
        title: Text('Menu',
            style: TextStyle(
                fontFamily: 'Gilroy-Reguler',
                fontWeight: FontWeight.w600,
                letterSpacing: .4,
                fontSize: 20)));
  }

  search(vaFalse, vaTrue) {
    return Container(
      height: 80,
      padding: EdgeInsets.all(sm.w(4)),
      child: Row(children: [
        Flexible(
          child: EditTextComponent(
              controller: _mySearchEditTextController,
              hint: "Search for ... ",
              security: false,
              valid: true,
              keyboardSet: TextInputType.text,
              prefixIcon: 'search',
              keyBoardAction: TextInputAction.search,
              myOnChanged: (_val) {
                vaFalse.txt = _val;
              },
              atSubmit: (_val) {
                vaFalse.setSearchText(_val);
                vaTrue.notifyListeners();
              },
              prefClick: () {
                vaFalse.setSearchText(
                    (_mySearchEditTextController.text == null ||
                            _mySearchEditTextController.text == "")
                        ? null
                        : _mySearchEditTextController.text);
                vaTrue.notifyListeners();
              }),
        ),
        Column(children: [
          Text(
            'Only Veg',
            style: TextStyle(
                fontSize: 10, fontFamily: 'Gilroy-Medium', color: myGrey),
          ),
          Padding(
            padding:
                EdgeInsets.only(left: sm.w(2), right: sm.w(1), top: sm.h(1)),
            child: NeumorphicSwitch(
              value: vaFalse.getIsVeg() ?? false,
              height: sm.h(3.5),
              style: NeumorphicSwitchStyle(
                  activeThumbColor: Colors.green,
                  activeTrackColor: Colors.green[100],
                  inactiveTrackColor: Color(0xfff4f6fc),
                  inactiveThumbColor: myBackGround),
              onChanged: (val) {
                vaFalse.setIsVeg(val);
                vaFalse.catItems.isVeg = val;
              },
            ),
          ),
        ])
      ]),
    );
  }
}
