import 'package:application/model/NotificationListModel.dart';
import 'package:application/ui/notification/CreateNotification.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:application/component/roundedButton.dart';

import '../../network/webservices.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  NotificationListModel notificationsList = NotificationListModel();

  @override
  void initState() {
    WebService.funGetNotifications().then((value) {
      setState(() {
        notificationsList = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        body: Container(
            child: Stack(children: [
          Positioned(
            top: context.percentWidth * 6,
            left: context.percentWidth * 10,
            right: context.percentWidth * 10,
            child: Container(
              height: context.percentHeight * 70,
              child: ListView.builder(
                  itemCount: notificationsList.notifications.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        height: context.percentHeight * 10,
                        width: context.percentWidth * 80,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        margin: EdgeInsets.symmetric(vertical: 2.0),
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              notificationsList.notifications[index].title,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Container(
                              //height: context.percentHeight * 4,
                              child: AutoSizeText(
                                notificationsList
                                    .notifications[index].description,
                                minFontSize: 14,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ));
                  }),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: context.percentWidth * 10),
              width: context.percentWidth * 50,
              child: roundedButton(
                clicker: () {},
                clr: Colors.red,
                title: "Send",
              ),
            ),
          ),
        ])));
  }
}
