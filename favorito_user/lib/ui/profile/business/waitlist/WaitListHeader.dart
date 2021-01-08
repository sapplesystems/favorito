import 'package:favorito_user/config/SizeManager.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class WaitListHeader extends StatefulWidget {
  String title;
  Function function;
  WaitListHeader({this.title, this.function});
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
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: sm.h(0.4)),
            child: Text(widget.title,
                style: TextStyle(fontSize: 20, fontFamily: 'Gilroy-Reguler')),
          ),
        ),
        // InkWell(
        //   onTap: () => widget.function(),
        //   child: Icon(
        //     Icons.cached,
        //     size: sm.w(8),
        //     color: Colors.black,
        //   ),
        // ),
      ],
    );
  }
}
