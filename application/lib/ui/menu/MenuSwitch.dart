import 'package:Favorito/model/BaseResponse/BaseResponseModel.dart';
import 'package:Favorito/model/menu/MenuItem/MenuItem.dart';
import 'package:Favorito/model/menu/MenuItem/MenuItemModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../../utils/myString.dart';

class MenuSwitch extends StatefulWidget {
  String id;
  String title;
  MenuSwitch({this.id, this.title});
  @override
  _MenuSwitchState createState() => _MenuSwitchState();
}

class _MenuSwitchState extends State<MenuSwitch> {
  ProgressDialog pr;
  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
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
                print("widget.title${widget.title.split('|')[2]}");
                if (widget.title.split('|')[2] == "0") {
                  pr.show();
                  await WebService.funMenuStatusChange({
                    "api_type": "set",
                    "item_id": widget.id,
                    "is_activated":
                        snapshot.data.data[0].isActivated == 1 ? 0 : 1
                  }).then((value) {
                    if (value.status == 'success') {
                      setState(() {
                        snapshot.data.data[0].isActivated =
                            snapshot.data.data[0].isActivated == 0 ? 1 : 0;
                      });
                    }
                    pr.hide();
                  });
                } else {
                  BotToast.showText(
                      text: "${widget?.title?.split("|")[0]} is not available");
                }
              },
              activeTrackColor: myRedLight,
              activeColor: Colors.red,
            );
          }
        });
  }
}
