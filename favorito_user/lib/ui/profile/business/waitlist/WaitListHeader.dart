import 'package:favorito_user/config/SizeManager.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class WaitListHeader extends StatefulWidget {
  String title;
  WaitListHeader({this.title});
  @override
  _WaitListHeaderState createState() => _WaitListHeaderState();
}

class _WaitListHeaderState extends State<WaitListHeader> {
  SizeManager sm;
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.navigate_before,
            size: sm.w(12),
            color: Colors.black,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: sm.h(0.4)),
          child: Text(widget.title,
              style: TextStyle(fontSize: 20, fontFamily: 'Gilroy-Bold')),
        )
      ],
    );
  }
}
