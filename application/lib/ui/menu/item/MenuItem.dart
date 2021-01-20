import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/model/menu/MenuDisplayItemModel.dart';
import 'package:Favorito/model/menu/MenuItem/ItemData.dart';
import 'package:Favorito/model/menu/MenuItem/MenuItem.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/menu/CategoryForm.dart';
import 'package:Favorito/ui/menu/item/NewMenuItem.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../../../utils/myString.dart';

class MenuItem extends StatefulWidget {
  int id;
  MenuItem(this.id);

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
    pr.style(message: 'Fetching Data, please wait');
    print("widget.id${widget.id}");
    return Scaffold(
        backgroundColor: myBackGround,
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
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
        ),
        body: FutureBuilder<MenuItemModel>(
          future: WebService.funMenuItemDetail({"menu_item_id": widget.id}),
          builder:
              (BuildContext context, AsyncSnapshot<MenuItemModel> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: Text(loading));
            else if (snapshot.hasError)
              return Center(child: Text(wentWrong));
            else {
              model = snapshot.data.data[0];
              return Container(
                height: sm.scaledHeight(95),
                width: sm.scaledWidth(100),
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: ListView(shrinkWrap: true, children: [
                  Container(
                    height: sm.scaledHeight(14),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (var _v in snapshot.data.data[0].photo ?? 0)
                          Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Image.network(
                              _v.url,
                              fit: BoxFit.fill,
                              width: sm.scaledHeight(10),
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
                    padding: EdgeInsets.symmetric(
                        horizontal: 8, vertical: sm.scaledHeight(2)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Price : ${model.price}",
                              style: TextStyle(fontSize: 16),
                            ),
                            Row(
                              children: [
                                model.type == "Veg"
                                    ? IconButton(
                                        onPressed: () => null,
                                        icon: SvgPicture.asset(
                                            'assets/icon/foodTypeVeg.svg',
                                            height: 20))
                                    : IconButton(
                                        onPressed: () => null,
                                        icon: SvgPicture.asset(
                                            'assets/icon/foodTypeNonVeg.svg',
                                            height: 20)),
                                Text(
                                  "${model.type}",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Quantity : ${model.quantity}",
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              "Max qty per order : ${model.maxQtyPerOrder}",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: sm.scaledHeight(2)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Details : ",
                                style: TextStyle(fontSize: 16),
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
                          padding: EdgeInsets.only(top: sm.scaledHeight(2)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NewMenuItem(model: model)));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                      color: myBackGround,
                                      border: Border.all(color: myRed),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  child: Icon(
                                    Icons.edit,
                                    color: myRed,
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              InkWell(
                                onTap: () async {
                                  pr.show();
                                  await WebService.funMenuItemDelete(
                                          {"menu_item_id": widget.id})
                                      .then((value) {
                                    pr.hide();
                                    if (value.status == 'success') {
                                      Navigator.pop(context);
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                      color: myBackGround,
                                      border: Border.all(color: myRed),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  child: Icon(
                                    Icons.delete,
                                    color: myRed,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ]),
              );
            }
          },
        ));
  }
}
