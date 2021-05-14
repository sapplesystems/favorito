import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class MessageBtn extends StatefulWidget {
  String txt;
  MessageBtn({this.txt});
  @override
  _MessageBtnState createState() => _MessageBtnState();
}

class _MessageBtnState extends State<MessageBtn> {
  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      style: NeumorphicStyle(
          shape: NeumorphicShape.convex,
          // depth: 4,
          lightSource: LightSource.topLeft,
          color: myRed,
          boxShape: NeumorphicBoxShape.roundRect(
              BorderRadius.all(Radius.circular(8)))),
      onPressed: () {},
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: Container(
        width: 100,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: Text(
          widget.txt,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white),
        ),
      ),
    );
  }
}
