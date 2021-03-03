import 'package:Favorito/ui/notification/CreateNotification.dart';
import 'package:Favorito/ui/notification/NotificationProvider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:provider/provider.dart';

class Notifications extends StatelessWidget {
  NotificationsProvider vaTrue;
  NotificationsProvider vaFalse;
  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    vaTrue = Provider.of<NotificationsProvider>(context, listen: true);
    vaFalse = Provider.of<NotificationsProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black, size: 26),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: IconThemeData(color: Colors.black //change your color here
              ),
          title: Text("Notifications",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 26,
                  fontFamily: 'Gilroy-Bold',
                  letterSpacing: .2)),
        ),
        body: ListView(children: [
          Container(
            height: sm.h(75),
            margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32.0),
            child: ListView.builder(
                itemCount: vaTrue.notificationsListdata.notifications.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      vaTrue.setNotificationId(
                          vaTrue.notificationsListdata.notifications[index].id);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateNotification()));
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
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                      vaTrue.notificationsListdata
                                          .notifications[index].title,
                                      style: TextStyle(
                                          fontFamily: 'Gilroy-Medium',
                                          fontSize: 18))),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Container(
                                  child: AutoSizeText(
                                      vaTrue.notificationsListdata
                                          .notifications[index].description,
                                      minFontSize: 14,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'Gilroy-Regular',
                                          fontSize: 16)),
                                ),
                              )
                            ],
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
                        vaTrue.allClear();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateNotification()));
                      },
                      clr: Colors.red,
                      title: "Create New")))
        ]));
  }
}
