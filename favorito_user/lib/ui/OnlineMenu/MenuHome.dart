import 'dart:async';
import 'package:favorito_user/ui/OnlineMenu/MenuHomeProvider.dart';
import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/Menu/MenuItemModel.dart';
import 'package:favorito_user/ui/OnlineMenu/FloatingActionButtons.dart';
import 'package:favorito_user/ui/OnlineMenu/MenuPages.dart';
import 'package:favorito_user/ui/business/BusinessProfileProvider.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/RIKeys.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class MenuHome extends StatelessWidget {
  var _mySearchEditTextController = TextEditingController();
  SizeManager sm;
  List<MenuItemModel> menuItemBaseModel = [];
  MenuHomeProvider vaTrue;
  ControllerCallback controller;
  bool isFisrt = true;
  @override
  Widget build(BuildContext context) {
    if (isFisrt) {
      sm = SizeManager(context);
      vaTrue = Provider.of<MenuHomeProvider>(context, listen: true);
      vaTrue
        ..setBusinessIdName(
            Provider.of<BusinessProfileProvider>(context, listen: true)
                .getBusinessProfileData()
                .businessId,
            Provider.of<BusinessProfileProvider>(context, listen: true)
                .getBusinessProfileData()
                .businessName)
        ..isVegFilter = false
        ..checkisFoody()
        ..userOrderCreateVerbose()
        ..getMenuItem()
        ..menuTabGet();
      isFisrt = false;
    }
    return WillPopScope(
      onWillPop: () async {
        vaTrue.clearAll();
        Navigator.pop(context);
      },
      child: SafeArea(
        child: Scaffold(
          key: RIKeys.josKeys25,
          backgroundColor: myBackGround,
          appBar: myAppBar(context),
          body: RefreshIndicator(
            onRefresh: () async {},
            child: ListView(children: [
              Text(
                  Provider.of<BusinessProfileProvider>(context, listen: true)
                          .getBusinessProfileData()
                          ?.businessName ??
                      '',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(fontSize: 20)),
              Divider(),
              search(),
              Container(
                height: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        height: sm.h(6),
                        child: Consumer<MenuHomeProvider>(
                          builder: (context, data, child) {
                            // if (data?.cat?.length == 0)
                            //   vaTrue.notifyListeners();
                            return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: data?.cat?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return MaterialButton(
                                    shape:
                                        vaTrue.catItems?.selectedCatId == index
                                            ? UnderlineInputBorder()
                                            : null,
                                    onPressed: () {
                                      vaTrue.categorySelector(index);
                                      vaTrue.notifyListeners();
                                    },
                                    child: Text(
                                        vaTrue.cat[index]?.categoryName ?? '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            .copyWith(
                                                fontSize: 12,
                                                color: data?.cat[index]
                                                            ?.outOfStock ==
                                                        1
                                                    ? myGrey
                                                    : null)),
                                  );
                                });
                          },
                        )),
                    Divider(),
                    Container(
                        height: sm.h(60),
                        child: vaTrue.cat.isEmpty
                            ? Center(child: CircularProgressIndicator())
                            : MenuPage())
                  ],
                ),
              )
            ]),
          ),
          floatingActionButton: FloatingActionButtons(),
        ),
      ),
    );
  }

  myAppBar(context) {
    return AppBar(
        backgroundColor: myBackGround,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace, color: myGrey),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Menu',
            style: Theme.of(context).textTheme.headline6.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: .4,
                )));
  }

  search() {
    return Padding(
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
                vaTrue.txt = _val;
              },
              atSubmit: (_val) {
                vaTrue.setSearchText(_val);
                vaTrue.notifyListeners();
              },
              prefClick: () {
                vaTrue.setSearchText(
                    (_mySearchEditTextController.text == null ||
                            _mySearchEditTextController.text == "")
                        ? null
                        : _mySearchEditTextController.text);
                vaTrue.notifyListeners();
              }),
        ),
        Visibility(
          visible: vaTrue.getisFoody(),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text(
              'Only Veg',
              style: TextStyle(
                  fontSize: 10, fontFamily: 'Gilroy-Medium', color: myGrey),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: sm.w(2), right: sm.w(1), bottom: sm.h(3)),
              child: NeumorphicSwitch(
                value: vaTrue.getIsVeg() ?? false,
                height: sm.h(3.5),
                style: NeumorphicSwitchStyle(
                    activeThumbColor: Colors.green,
                    activeTrackColor: Colors.green[100],
                    inactiveTrackColor: Color(0xfff4f6fc),
                    inactiveThumbColor: myBackGround),
                onChanged: (val) {
                  vaTrue.setIsVeg(val);
                  vaTrue.catItems.isVeg = val;
                },
              ),
            ),
          ]),
        )
      ]),
    );
  }
}
