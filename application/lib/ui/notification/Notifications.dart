import 'package:application/model/NotificationListModel.dart';
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
      notificationsList = value;
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
        ),
        body: Container(
            color: Color(0xfffff4f4),
            height: context.percentHeight * 90,
            child: Stack(children: [
              Positioned(
                top: context.percentWidth * 6,
                left: context.percentWidth * 10,
                right: context.percentWidth * 10,
                child: ListView.builder(
                    itemCount: notificationsList.notifications.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: context.percentHeight * 70,
                            width: context.percentWidth * 80,
                            child: Card(
                              elevation: 0,
                              child: Column(
                                children: [
                                  Text(
                                    notificationsList
                                        .notifications[index].title,
                                    style: TextStyle(fontSize: 22),
                                  ),
                                  Text(
                                    notificationsList
                                        .notifications[index].title,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ));
                    }),
              ),
              Positioned(
                bottom: context.percentWidth * 6,
                left: context.percentWidth * 20,
                right: context.percentWidth * 20,
                child: roundedButton(
                  clicker: () {},
                  clr: Colors.red,
                  title: "Next",
                ),
              ),
            ])));
  }
}
