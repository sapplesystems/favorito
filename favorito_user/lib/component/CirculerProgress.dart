import 'package:favorito_user/component/Minut20.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CirculerProgress extends StatefulWidget {
  String minutTxt;
  double per;
  CirculerProgress({this.minutTxt, this.per});
  @override
  _CirculerProgressState createState() => _CirculerProgressState();
}

class _CirculerProgressState extends State<CirculerProgress> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircularPercentIndicator(
        radius: 120.0,
        lineWidth: 13.0,
        animation: true,
        percent: widget.per,
        animateFromLastPercent: true,
        reverse: true,
        backgroundColor: Colors.white70,
        center: minut20(myMinut: widget.minutTxt),
        footer: new Text(
          '',
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
        ),
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: myRed,
      ),
    );
  }
}
