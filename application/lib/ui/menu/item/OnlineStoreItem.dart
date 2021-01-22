import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/model/store/OnlineStoreItemModel.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnlineStoreItem extends StatefulWidget {
  int id;
  String name;
  OnlineStoreItem(this.id, this.name);

  @override
  _OnlineStoreItem createState() => _OnlineStoreItem();
}

class _OnlineStoreItem extends State<OnlineStoreItem> {
  OnlineStoreItemModel model = OnlineStoreItemModel();

  @override
  void initState() {
    initializeValues();
    super.initState();
  }

  void initializeValues() {
    model.id = widget.id;
    model.name = widget.name;
    model.price = "Rs. 180";
    model.quantity = "4";
    model.maxQuantity = "4";
    model.description =
        "jnsfjfs hsfh skhf gslkuhfisdhfkdushg skufgh sugfkshdf hdslfh ksgdflk dfslgd fksdhf d";
  }

  @override
  Widget build(BuildContext context) {
    initializeValues();
    SizeManager sm = SizeManager(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.name,
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
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0,
      ),
      body: Container(
        height: sm.h(95),
        width: sm.w(100),
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: ListView(shrinkWrap: true, children: [
          Container(
            height: sm.h(14),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (int i = 0; i < 10; i++)
                  Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.network(
                      'https://eatforum.org/content/uploads/2018/05/table_with_food_top_view_900x700.jpg',
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
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: sm.h(2)),
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
                    Text(
                      "Quantity : ${model.quantity}",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: sm.h(2)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Max qty per order : ${model.maxQuantity}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: sm.h(2)),
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
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: sm.h(2)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: null,
                          iconSize: sm.h(5)),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: null,
                        iconSize: sm.h(5),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
