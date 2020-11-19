import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Favorito/config/SizeManager.dart';

class listItems extends StatelessWidget {
  String ico;
  String title;
  Function clicker;
  listItems({this.clicker, this.ico, this.title});

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: clicker,
        child: Row(
          children: [
            SvgPicture.asset("assets/icon/$ico.svg",
                alignment: Alignment.center, height: sm.scaledHeight(3)),
            SizedBox(width: 20),
            Text(title.trim(), style: TextStyle(fontSize: 18))
          ],
        ),
      ),
    );
  }
}
