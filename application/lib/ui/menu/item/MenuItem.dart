import 'package:Favorito/component/DeleteItem.dart';
import 'package:Favorito/component/EditItem.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/model/menu/MenuItem/ItemData.dart';
import 'package:Favorito/model/menu/MenuItem/MenuItem.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/menu/item/NewMenuItem.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../../../utils/myString.dart';

class MenuItem extends StatefulWidget {
  int id;
  bool showVeg;
  MenuItem(this.id, this.showVeg);

  @override
  _MenuItemState createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  ItemData model = ItemData();
  ProgressDialog pr;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    pr = ProgressDialog(context, type: ProgressDialogType.Normal);
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
    print("widget.id${widget.id}");
    return Scaffold(
        body: FutureBuilder<MenuItemModel>(
      future: WebService.funMenuItemDetail({"menu_item_id": widget.id}),
      builder: (BuildContext context, AsyncSnapshot<MenuItemModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: Text(loading));
        else if (snapshot.hasError)
          return Center(child: Text(wentWrong));
        else {
          model = snapshot.data.data[0];

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(model.title ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2)),
              leading: IconButton(
                icon: Icon(Icons.keyboard_backspace, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              iconTheme: IconThemeData(color: Colors.black),
              elevation: 0,
            ),
            body: Container(
              height: sm.h(95),
              width: sm.w(100),
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: ListView(shrinkWrap: true, children: [
                Container(
                  height:
                      snapshot?.data?.data[0]?.photo.length == 0 ? 0 : sm.h(14),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (var _v in snapshot?.data?.data[0]?.photo)
                        Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Image.network(
                            _v.url,
                            fit: BoxFit.fill,
                            width: sm.h(10),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 5,
                          margin: EdgeInsets.all(10),
                        )
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: sm.h(2)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Price :",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "\u{20B9}${model.price}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(height: sm.h(2)),
                                Row(
                                  children: [
                                    Text(
                                      "Quantity :",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      " ${model.quantity}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: widget.showVeg,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      model.type == "Veg"
                                          ? SvgPicture.asset(
                                              'assets/icon/foodTypeVeg.svg',
                                              height: sm.w(5.5))
                                          : SvgPicture.asset(
                                              'assets/icon/foodTypeNonVeg.svg',
                                              height: sm.w(5.5)),
                                      Text(
                                        "  ${model.type}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: sm.h(2)),
                                Row(
                                  children: [
                                    Text(
                                      "Max qty per order : ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      " ${model.maxQtyPerOrder}",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: sm.h(2)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Details : ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Text(
                                  model.description,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: sm.h(8)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              EditItem(onClick: () {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NewMenuItem(
                                                model: model,
                                                showVeg: widget.showVeg)))
                                    .whenComplete(() async {
                                  setState(() {});
                                  // fut = await WebService.funMenuItemDetail(
                                  //     {"menu_item_id": widget.id});
                                });
                              }),
                              SizedBox(width: sm.w(10)),
                              DeleteItem(onClick: () async {
                                pr.show();
                                await WebService.funMenuItemDelete(
                                    {"menu_item_id": widget.id}).then((value) {
                                  pr.hide();
                                  if (value.status == 'success') {
                                    Navigator.pop(context);
                                  }
                                });
                              }),
                            ],
                          ),
                        )
                      ]),
                ),
              ]),
            ),
          );
        }
      },
    ));
  }
}
