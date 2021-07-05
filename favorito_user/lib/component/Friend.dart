import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class FriendBtn extends StatefulWidget {
  
  @override
  _FriendBtnState createState() => _FriendBtnState();
}

class _FriendBtnState extends State<FriendBtn> {
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
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: Text(
          true ? 'Add as friend' : 'Friend',
          style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white),
        ),
      ),
    );
  }
}
