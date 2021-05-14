import 'package:favorito_user/config/SizeManager.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class Following extends StatefulWidget {
  String txt;
  Color clr;
  Function onClick;
  Following({this.txt, this.clr, this.onClick});

  @override
  _fromToState createState() => _fromToState();
}

class _fromToState extends State<Following> {
  SizeManager sm;

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Container(
      width: sm.w(26),
      padding: EdgeInsets.symmetric(vertical: sm.h(1.4)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: widget.clr, width: 1),
      ),
      child: Text(
        widget.txt,
        style: TextStyle(
            color: widget.clr, fontSize: 14, fontFamily: 'Gilroy-ExtraBold'),
        textAlign: TextAlign.center,
      ),
    );
  }
}
