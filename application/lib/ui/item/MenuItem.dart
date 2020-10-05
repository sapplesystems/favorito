import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/model/menu/MenuDisplayItemModel.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuItem extends StatefulWidget {
  int id;
  String name;
  MenuItem(this.id, this.name);

  @override
  _MenuItemState createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  MenuDisplayItemModel model = MenuDisplayItemModel();

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
    model.foodType = "Veg";
  }

  @override
  Widget build(BuildContext context) {
    initializeValues();
    SizeManager sm = SizeManager(context);
    return Scaffold(
      backgroundColor: myBackGround,
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
        height: sm.scaledHeight(95),
        width: sm.scaledWidth(100),
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: ListView(shrinkWrap: true, children: [
          Container(
            height: sm.scaledHeight(14),
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
                        model.foodType == "Veg"
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
                          "${model.foodType}",
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
                      "Max qty per order : ${model.maxQuantity}",
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
                          style: TextStyle(color: Colors.grey, fontSize: 16),
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
                      IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: null,
                          iconSize: sm.scaledHeight(5)),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: null,
                        iconSize: sm.scaledHeight(5),
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
