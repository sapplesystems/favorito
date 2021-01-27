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
  FloatingActionButtonsState createState() =>
      basket.getFloatingActionButtonsState();
}

class FloatingActionButtonsState extends State<FloatingActionButtons> {
  SizeManager sm;
  String totel;

  @override
  void initState() {
    super.initState();
  }

  void refresh() {
    setState(() {
      print("clicked");
    });
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);

    totel = widget.basket.getTotelPrice();

    print("clicked:${totel}");
    return FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
              context: context,
              enableDrag: true,
              isScrollControlled: true,
              backgroundColor: myBackGround,
              builder: (BuildContext context) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Container(
                    height: sm.h(70),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(vertical: sm.h(3)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: myGrey,
                          ),
                          width: sm.w(20),
                          height: 6,
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
                              Text(widget.basket.getTotelPrice() + "\u{20B9}",
                                  style: TextStyle(
                                      fontFamily: 'Gilroy-Medium',
                                      fontSize: 16)),
                            ],
                          ),
                          // widget(child: ElevatedButton(child: Text(''),onPressed: (){}))
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
