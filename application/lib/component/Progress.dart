import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';

circularProgress() {
  return Container(
    color: myBackGround.withOpacity(.5),
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(myRed.withOpacity(0.5)),
    ),
  );
}

linearProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12),
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.lightGreenAccent),
    ),
  );
}
