import 'package:Favorito/model/BaseResponse/BaseResponseModel.dart';
import 'package:Favorito/model/menu/MenuItem/MenuItem.dart';
import 'package:Favorito/model/menu/MenuItem/MenuItemModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../../utils/myString.dart';

class MenuSwitch extends StatefulWidget {
  String id;
  MenuSwitch({this.id});
  @override
  _MenuSwitchState createState() => _MenuSwitchState();
}

class _MenuSwitchState extends State<MenuSwitch> {
  ProgressDialog pr;
  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: 'Please wait');
    return FutureBuilder<MenuItemOnlyModel>(
        future: WebService.funMenuStatusChange(
            {"api_type": "get", "item_id": widget.id}),
        builder:
            (BuildContext context, AsyncSnapshot<MenuItemOnlyModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(Icons.autorenew),
            ));
          else if (snapshot.hasError)
            return Center(child: Text(wentWrong));
          else {
            return Switch(
              value: snapshot.data.data[0].isActivated == 1,
              onChanged: (value) async {
                pr.show();

                await WebService.funMenuStatusChange({
                  "api_type": "set",
                  "item_id": widget.id,
                  "is_activated": snapshot.data.data[0].isActivated == 1 ? 0 : 1
                }).then((value) {
                  if (value.status == 'success') {
                    setState(() {
                      snapshot.data.data[0].isActivated =
                          snapshot.data.data[0].isActivated == 0 ? 1 : 0;
                    });
                  }
                  pr.hide();
                });
              },
              activeTrackColor: myRedLight,
              activeColor: Colors.red,
            );
          }
        });
  }
}
