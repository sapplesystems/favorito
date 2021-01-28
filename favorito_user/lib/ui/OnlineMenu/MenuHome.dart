import 'dart:async';
import 'package:favorito_user/Providers/MenuHomeProvider.dart';
import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/Menu/MenuItemModel.dart';
import 'package:favorito_user/model/appModel/Menu/MenuTabModel.dart';
import 'package:favorito_user/ui/OnlineMenu/FloatingActionButtons.dart';
import 'package:favorito_user/ui/OnlineMenu/MenuPages.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:favorito_user/utils/MyString.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class MenuHome extends StatelessWidget {
  MenuHomeProvider menuHomeProvider = MenuHomeProvider();
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
    return SafeArea(
      child: Scaffold(
          backgroundColor: myBackGround,
          appBar: AppBar(
            backgroundColor: myBackGround,
            elevation: 0,
            title: Text('Menu', style: TextStyle(fontFamily: 'Gilroy-Medium')),
          ),
          body: ListView(children: [
            Text(menuHomeProvider.businessName ?? "business name",
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
                        // setState(() {
                        menuHomeProvider.txt = _val;
                        menuHomeProvider.catItems.txt = _val;
                        // });
                      },
                      prefClick: () {
                        // setState(() {
                        menuHomeProvider.txt = _mySearchEditTextController.text;

                        menuHomeProvider.catItems.txt =
                            _mySearchEditTextController.text;
                        // });
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
                      value: menuHomeProvider.getIsVeg() ?? false,
                      height: sm.h(3.5),
                      style: NeumorphicSwitchStyle(
                          activeThumbColor: Colors.green,
                          activeTrackColor: Colors.green[100],
                          inactiveTrackColor: Color(0xfff4f6fc),
                          inactiveThumbColor: myBackGround),
                      onChanged: (val) {
                        Provider.of<MenuHomeProvider>(context, listen: false)
                            .setIsVeg(val);
                        menuHomeProvider.catItems.isVeg = val;
                        // });
                      },
                    ),
                  ),
                ])
              ]),
            ),
            FutureBuilder<MenuTabModel>(
              future: Provider.of<MenuHomeProvider>(context, listen: false)
                  .getMenuData(),
              builder:
                  (BuildContext context, AsyncSnapshot<MenuTabModel> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: Text(loading));
                else if (snapshot.hasError) {
                  return Center(child: Text(wentWrong));
                } else {
                  var va = Provider.of<MenuHomeProvider>(context, listen: true);
                  return Container(
                    height: 500,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            height: sm.h(6),
                            child: Consumer<MenuHomeProvider>(
                              builder: (context, data, child) {
                                return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: va.cat.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return MaterialButton(
                                        shape: Provider.of<MenuHomeProvider>(
                                                        context,
                                                        listen: true)
                                                    .catItems
                                                    .selectedCatId ==
                                                index
                                            ? UnderlineInputBorder()
                                            : null,
                                        onPressed: () {
                                          Provider.of<MenuHomeProvider>(context,
                                                  listen: false)
                                              .categorySelector(index);
                                          Provider.of<MenuHomeProvider>(context,
                                                  listen: false)
                                              .notifyListeners();
                                        },
                                        child: Text(
                                            Provider.of<MenuHomeProvider>(
                                                    context,
                                                    listen: true)
                                                .cat[index]
                                                ?.categoryName,
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .bodyText1),
                                      );
                                    });
                              },
                            )),
                        Divider(),
                        Container(height: sm.h(60), child: MenuPage())
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
}
