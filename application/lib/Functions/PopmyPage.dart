import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';

class PopmyPage {
  Function save;
  Function cancel;
  GlobalKey<ScaffoldState> key;

  PopmyPage({this.cancel, this.save, this.key});

  void popMe() {
    print("sdfsdfffffff");
    showModalBottomSheet<void>(
        context: key.currentContext,
        builder: (BuildContext context) {
          return Container(
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  '\t\t\t\t\tPlease save your changes or cancel for discard.',
                  style: TextStyle(fontSize: 16, fontFamily: 'Gilroy-Medium'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        child: Text("save",
                            style: TextStyle(
                                color: myRed,
                                fontSize: 16,
                                fontFamily: 'Gilroy-Medium')),
                        onPressed: save),
                    InkWell(
                        child: Text(
                          "Discard",
                          style: TextStyle(
                              color: myRed,
                              fontSize: 16,
                              fontFamily: 'Gilroy-Medium'),
                        ),
                        onTap: cancel),
                  ],
                )
              ],
            ),
          );
        });
  }
}
