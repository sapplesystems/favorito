import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import '../../utils/myString.dart';

class MenuSwitch extends StatefulWidget {
  String id;
  String title;
  MenuSwitch({this.id, this.title});
  @override
  _MenuSwitchState createState() => _MenuSwitchState();
}

class _MenuSwitchState extends State<MenuSwitch> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: WebService.funMenuStatusChange(
            {"api_type": "get", "item_id": widget.id}),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                print('title${widget.title}');
                if (widget.title.split('|')[2].toString().trim() == '0') {
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
