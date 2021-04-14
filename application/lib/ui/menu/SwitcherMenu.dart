import 'package:Favorito/model/menu/MenuBaseModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:flutter/material.dart';

class SwitcherMenu extends StatefulWidget {
  String id;
  SwitcherMenu({this.id});
  @override
  _SwitcherMenuState createState() => _SwitcherMenuState();
}

class _SwitcherMenuState extends State<SwitcherMenu> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MenuBaseModel>(
        future: WebService.funMenuCatList({"category_id": widget.id}),
        builder: (BuildContext context, AsyncSnapshot<MenuBaseModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Container(
              height: 10,
              child: Center(
                  child: Icon(
                Icons.cached,
              )),
            );
          else if (snapshot.hasError)
            return Center(child: null);
          else {
            return Switch(
              value: snapshot?.data?.data[0]?.outOfStock == 1,
              onChanged: (value) async {
                Map _map = {
                  "id": widget.id,
                  'out_of_stock':
                      snapshot?.data?.data[0]?.outOfStock == 1 ? 0 : 1,
                };
                print("Data is :${_map}");
                await WebService.funMenuCatEdit(_map).then((value) {
                  if (value.status == 'success') setState(() {});
                });
              },
              activeTrackColor: Color(0x56dd2525),
              activeColor: Colors.red,
            );
          }
        });
  }
}
