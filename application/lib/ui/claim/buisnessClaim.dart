import 'package:Favorito/myCss.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_multi_chip_select/flutter_multi_chip_select.dart';

class claim extends StatefulWidget {
  @override
  _claimState createState() => _claimState();
}

class _claimState extends State<claim> {
  final multiSelectKey = GlobalKey<MultiSelectDropdownState>();
  var menuItems = [1, 2, 3, 4, 5, 6];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: ListView(children: [
          Text(
            "Business Settings",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2),
          ),
          Container(
            decoration: bd1,
            child: FlutterMultiChipSelect(
              key: multiSelectKey,
              elements: List.generate(
                menuItems.length,
                (index) => MultiSelectItem<String>.simple(
                    actions: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            menuItems.remove(menuItems[index]);
                          });
                          print(
                              "Delete Call at: " + menuItems[index].toString());
                        },
                      )
                    ],
                    title: "Item " + menuItems[index].toString(),
                    value: menuItems[index].toString()),
              ),
              label: "Dropdown Select",
              values: [
                1, 2 // Pass Initial value array or leave empty array.
              ],
            ),
            margin: EdgeInsets.only(bottom: context.percentHeight * 0),
            padding: EdgeInsets.symmetric(
                horizontal: context.percentWidth * 6,
                vertical: context.percentHeight * 4),
          )
        ]),
      ),
    );
  }
}
