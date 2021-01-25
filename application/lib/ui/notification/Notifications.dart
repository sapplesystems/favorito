import 'package:Favorito/model/notification/NotificationListRequestModel.dart';
import 'package:Favorito/ui/notification/CreateNotification.dart';
import 'package:Favorito/utils/myColors.dart';
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
    WebService.funGetNotifications(context).then((value) {
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
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          centerTitle: true,
          title: Text("Notifications",
              style: TextStyle(color: Colors.black, letterSpacing: 2.0)),
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            height: sm.h(75),
            margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32.0),
            child: ListView.builder(
                itemCount: _notificationsListdata.notifications.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      var id = _notificationsListdata.notifications[index].id;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CreateNotification(id: id)));
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      child: Container(
                          height: sm.h(10),
                          width: sm.w(80),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
                          margin: EdgeInsets.symmetric(vertical: 2.0),
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(_notificationsListdata
                                    .notifications[index].title)),
                            subtitle: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
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
                    ),
                  );
                }),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: sm.w(50),
              child: RoundedButton(
                clicker: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateNotification(id: null)));
                },
                clr: Colors.red,
                title: "Create New",
              ),
            ),
          ),
        ]));
  }
}
