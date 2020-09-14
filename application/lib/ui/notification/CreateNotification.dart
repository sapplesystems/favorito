import 'package:application/component/roundedButton.dart';
import 'package:application/component/txtfieldboundry.dart';
import 'package:application/textFieldBasics.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CreateNotification extends StatefulWidget {
  @override
  _CreateNotificationState createState() => _CreateNotificationState();
}

class _CreateNotificationState extends State<CreateNotification> {
  @override
  void initState() {
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
        body: Center(
          child: Container(
              child: Stack(children: [
            Positioned(
                top: context.percentWidth * 6,
                left: context.percentWidth * 5,
                right: context.percentWidth * 5,
                child: Container(
                  height: context.percentHeight * 70,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: txtfieldboundry(
                          title: "Title",
                          security: false,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: txtfieldboundry(
                          title: "Description",
                          security: false,
                          maxLines: 5,
                        ),
                      ),
                    ],
                  ),
                )),
            Positioned(
              bottom: context.percentWidth * 10,
              left: context.percentWidth * 20,
              right: context.percentWidth * 20,
              child: roundedButton(
                clicker: () {},
                clr: Colors.red,
                title: "Send",
              ),
            ),
          ])),
        ));
  }
}
