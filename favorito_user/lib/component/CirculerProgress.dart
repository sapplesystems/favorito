import 'package:favorito_user/component/Minut20.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CirculerProgress extends StatefulWidget {
  String minutTxt;
  double v;
  String waitTime;
  CirculerProgress({this.minutTxt, this.v, this.waitTime});
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
          percent: widget.v ?? 0,
          animateFromLastPercent: true,
          reverse: true,
          backgroundColor: Colors.white70,
          center: minut20(myMinut: widget.waitTime),
          footer: new Text(
            '',
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontWeight: FontWeight.bold, fontSize: 17.0),
          ),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: myRed),
    );
  }
}
