import 'package:flutter/material.dart';

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, final GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.black54,
                  children: <Widget>[
                    Center(
                      child: Row(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 10),
                            width: MediaQuery.of(context).size.width * .6,
                            child: Text(
                              "Please wait while we are processing ....",
                              style: TextStyle(color: Colors.blueAccent),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ))
                      ]),
                    )
                  ]));
        });
  }
}
