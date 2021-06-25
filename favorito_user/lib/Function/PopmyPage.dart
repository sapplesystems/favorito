
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter/material.dart';

class PopmyPage {
  Function funOkay;
  Function funCancel;
  String message;
  String okayTxt;
  String cancelTxt;
  GlobalKey<ScaffoldState> key;

  PopmyPage({this.funOkay, this.funCancel, this.key,this.message,this.cancelTxt,this.okayTxt});

  void popMe() {
    showModalBottomSheet<void>(
      backgroundColor: Colors.white,
        context: key.currentContext,
        builder: (BuildContext context) {
          return Container(
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:8.0),
                  child: Text(
                    message,textAlign: TextAlign.center,
                    style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(fontSize: 16),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        child: Text(okayTxt,
                            style: TextStyle(
                                color: myRed,
                                fontSize: 16,
                                fontFamily: 'Gilroy-Medium')),
                        onPressed: funOkay),
                    InkWell(
                        child: Text(
                          cancelTxt,
                          style: TextStyle(
                              color: myRed,
                              fontSize: 16,
                              fontFamily: 'Gilroy-Medium'),
                        ),
                        onTap: funCancel),
                  ],
                )
              ],
            ),
          );
        });
  }
}
