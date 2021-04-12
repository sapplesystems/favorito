import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class minut20 extends StatelessWidget {
  String myMinut;
  minut20({this.myMinut});
  @override
  Widget build(BuildContext context) {
    return Column(
        // spacing: -10,
        // runSpacing: 20,
        // direction: Axis.vertical,
        // alignment: WrapAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 10),
          Text(
            myMinut,
            style: TextStyle(fontSize: 40, fontFamily: 'Gilroy-Reguler'),
          ),
          Text('Minutes',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14, letterSpacing: 1, fontFamily: 'Gilroy-Bold')),
        ]);
  }
}
