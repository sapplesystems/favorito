import 'package:Favorito/model/notification/NotificationListRequestModel.dart';
import 'package:Favorito/ui/notification/CreateNotification.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/component/roundedButton.dart';

import '../../network/webservices.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  NotificationListRequestModel _notificationsListdata =
      NotificationListRequestModel();

  @override
  void initState() {
    WebService.funGetNotifications().then((value) {
      setState(() {
        _notificationsListdata = value;
      });
    });
    super.initState();
  }
  //changes is need to check

  @override
  Widget build(BuildContext context) {
        SizeManager sm = SizeManager(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xfffff4f4),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            "Notification",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            height: sm.scaledHeight(75),
            margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32.0),
            child: ListView.builder(
                itemCount: _notificationsListdata.notifications.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: Container(
                        height: sm.scaledHeight(10),
                        width: sm.scaledWidth(80),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(40))),
                        margin: EdgeInsets.symmetric(vertical: 2.0),
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              _notificationsListdata.notifications[index].title,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Container(
                              child: AutoSizeText(
                                _notificationsListdata
                                    .notifications[index].description,
                                minFontSize: 14,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        )),
                  );
                }),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: sm.scaledWidth(50),
              child: roundedButton(
                clicker: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateNotification()));
                },
                clr: Colors.red,
                title: "Create New",
              ),
            ),
          ),
        ]));
  }
}
