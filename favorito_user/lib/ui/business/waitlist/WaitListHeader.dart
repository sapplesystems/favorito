import 'package:favorito_user/config/SizeManager.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class WaitListHeader extends StatefulWidget {
  String title;
  Function preFunction;
  Function postfunction;
  WaitListHeader({this.title, this.preFunction, this.postfunction});
  @override
  _WaitListHeaderState createState() => _WaitListHeaderState();
}

class _WaitListHeaderState extends State<WaitListHeader> {
  SizeManager sm;
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      InkWell(
          onTap: () => widget.preFunction(),
          child:
              Icon(Icons.navigate_before, size: sm.w(12), color: Colors.black)),
      Padding(
          padding: EdgeInsets.only(top: sm.h(0.2)),
          child: Text(widget.title,
              textAlign: TextAlign.start,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontSize: 20, fontWeight: FontWeight.w600)))
    ]);
  }
}
