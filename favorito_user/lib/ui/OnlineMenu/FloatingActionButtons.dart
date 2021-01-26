import 'package:favorito_user/component/RoundedButton.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/ui/OnlineMenu/Fab.dart';
import 'package:favorito_user/ui/OnlineMenu/MenuItem.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/Singletons.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';

import 'package:favorito_user/utils/MyString.dart';

class FloatingActionButtons extends StatefulWidget {
  Basket basket = Basket();

  @override
  _FloatingActionButtonsState createState() => _FloatingActionButtonsState();
  // basket.getFloatingActionButtonsState();
}

class _FloatingActionButtonsState extends State<FloatingActionButtons> {
  SizeManager sm;
  String totel;

  @override
  void initState() {
    super.initState();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);

    return FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
              context: context,
              enableDrag: true,
              builder: (BuildContext context) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Container(
                    height: sm.h(60),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                    ),
                    child: ListView(
                      children: <Widget>[
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
                                  vertical: sm.w(3), horizontal: sm.w(2)),
                              child: SvgPicture.asset(
                                'assets/icon/basket.svg',
                                height: sm.h(4),
                              ),
                            ),
                            Text(yourBasket,
                                style: TextStyle(
                                    fontFamily: 'Gilroy-Medium', fontSize: 20)),
                          ],
                        ),
                        Divider(),
                        Container(
                          height: sm.h(40),
                          child: ListView.builder(
                              itemCount:
                                  widget.basket.getMyObjectsList().length,
                              itemBuilder: (BuildContext context, int index) {
                                // print("bucket:${basket.data.length}");

                                return MenuItem(
                                    data:
                                        widget.basket.getMyObjectsList()[index],
                                    isRefresh: true,
                                    callBack: () {
                                      widget.basket.menuPagesRefresh();
                                      setState(() {});
                                    });
                              }),
                        ),
                        Divider(),
                        Padding(
                          padding: EdgeInsets.all(sm.h(2)),
                          child: Row(
                            children: [
                              Text("Total Amount",
                                  style: TextStyle(
                                      fontFamily: 'Gilroy-Medium',
                                      fontSize: 16)),
                              Spacer(),
                              Text(widget?.basket?.getTotelPrice() + "\u{20B9}",
                                  style: TextStyle(
                                      fontFamily: 'Gilroy-Medium',
                                      fontSize: 16)),
                            ],
                          ),
                        ),
                        RoundedButton(
                          clicker: () {},
                          title: 'Confirm Order',
                        )
                      ],
                    ),
                  );
                });
              });
        },
        backgroundColor: myBackGround,
        child: Fab());
  }
}
