import 'package:favorito_user/Providers/MenuHomeProvider.dart';
import 'package:favorito_user/Providers/OptController.dart';
import 'package:favorito_user/component/RoundedButton.dart';
import 'package:favorito_user/component/VegNonVegMarka.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/ui/OnlineMenu/Fab.dart';
import 'package:favorito_user/ui/OnlineMenu/MenuItem.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/Singletons.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../utils/myString.dart';

class FloatingActionButtons extends StatefulWidget {
  GlobalKey key;
  FloatingActionButtons({this.key});
  @override
  _FloatingActionButtonsState createState() => _FloatingActionButtonsState();
}

class _FloatingActionButtonsState extends State<FloatingActionButtons> {
  SizeManager sm;
  var vaTrue;
  var vaFalse;
  var vaOptFalse;
  var vaOptTrue;
  String totel;
  String title = yourBasket;

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    vaTrue = Provider.of<BasketControllers>(context, listen: true);
    vaFalse = Provider.of<MenuHomeProvider>(context, listen: false);
    vaOptFalse = Provider.of<OptController>(context, listen: false);
    vaOptTrue = Provider.of<OptController>(context, listen: true);

    return FloatingActionButton(
        onPressed: () {
          bucketBottomSheet();
          // callCustomizetion();
        },
        backgroundColor: myBackGround,
        child: Fab());
  }

  void callCustomizetion() {
    title = "customizetion";
    showModalBottomSheet<void>(
        enableDrag: true,
        isScrollControlled: true,
        context: widget.key.currentContext,
        backgroundColor: Color.fromRGBO(255, 0, 0, 0),
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: sm.h(90),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: ListView(
                physics: new NeverScrollableScrollPhysics(),
                children: <Widget>[header(), body2(), footer()],
              ),
            );
          });
        });
  }

  void bucketBottomSheet() {
    showModalBottomSheet<void>(
        enableDrag: true,
        isScrollControlled: true,
        context: context,
        backgroundColor: Color.fromRGBO(255, 0, 0, 0),
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: sm.h(60),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: ListView(
                physics: new NeverScrollableScrollPhysics(),
                children: <Widget>[header(), body1(), footer()],
              ),
            );
          });
        });
  }

  header() {
    return Container(
      height: 100,
      child: ListView(
        physics: new NeverScrollableScrollPhysics(),
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: sm.w(4)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: myGreyLight,
              ),
              width: sm.w(18),
              height: 6,
            ),
          ),
          Row(
            children: [
              SizedBox(width: sm.w(2)),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: sm.w(5), horizontal: sm.w(2)),
                child: SvgPicture.asset(
                  title == yourBasket
                      ? 'assets/icon/basket.svg'
                      : 'assets/icon/customize.svg',
                  height: sm.h(4),
                ),
              ),
              Text(title,
                  style: TextStyle(fontFamily: 'Gilroy-Medium', fontSize: 20)),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }

  footer() {
    return Container(
      height: 100,
      child: ListView(
        physics: new NeverScrollableScrollPhysics(),
        children: [
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sm.h(2)),
            child: Row(
              children: [
                Text("Total Amount",
                    style:
                        TextStyle(fontFamily: 'Gilroy-Medium', fontSize: 16)),
                Spacer(),
                Consumer<BasketControllers>(builder: (context, _data, child) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(_data?.getTotelPrice() + "\u{20B9}",
                        style: TextStyle(
                            fontFamily: 'Gilroy-Medium', fontSize: 16)),
                  );
                }),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sm.w(16), vertical: 2),
            child: RoundedButton(
              clicker: () {
                callCustomizetion();
              },
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: "Gilroy-Bold",
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1),
              title: 'Confirm Order',
            ),
          )
        ],
      ),
    );
  }

  body1() => Container(
        height: sm.h(30),
        child: Scrollbar(
          child: ListView.builder(
              itemCount: vaTrue.getMyObjectsList().length,
              itemBuilder: (BuildContext context, int index) {
                return MenuItems(
                    data: vaTrue.getMyObjectsList()[index],
                    isRefresh: true,
                    callBack: () {
                      vaTrue.notifyListeners();
                    });
              }),
        ),
      );

  body2() {
    vaOptTrue = Provider.of<OptController>(widget.key.currentContext, listen: true);

    // Colors.grey
    // Icons.check_box_outline_blank,
    return Container(
      height: sm.h(62),
      child: Scrollbar(
        child: ListView.builder(
            itemCount: vaOptFalse.getOpt().length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  VegNonVegMarka(isVeg: true),
                  IconButton(
                    icon: Icon(
                      vaOptTrue.,
                      color: Colors.red,
                    ),
                    onPressed: () {
                     vaOptTrue.o
                    },
                  ),
                  Text("Olive Carry"),
                  Text("100 \u{20B9}")
                ]),
              );
            }),
      ),
    );
  }
}

// Map _map = {
//                               "business_id": vaFalse.getBusinessId(),
//                               "notes": "test test test",
//                               "order_type": 3,
//                               "payment_type": "card",
//                               "category": [
//                                 {
//                                   "category_id": 1,
//                                   "category_item": [
//                                     {
//                                       "item_id": "1",
//                                       "price": "180.50",
//                                       "qty": 1,
//                                       "tax": 0.10
//                                     }
//                                   ]
//                                 },
//                                 {
//                                   "category_id": 1,
//                                   "category_item": [
//                                     {
//                                       "item_id": "3",
//                                       "price": "150.20",
//                                       "qty": 2,
//                                       "tax": 0.10
//                                     }
//                                   ]
//                                 }
//                               ]
//                             };
//                             await APIManager.userOrderCreate(_map);
