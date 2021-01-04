import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class minut20 extends StatelessWidget {
  String myMinut;
  minut20({this.myMinut});
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: -10,
      runSpacing: 20,
      direction: Axis.vertical,
      children: [
        Text(
          myMinut,
          style: TextStyle(
            fontSize: 50,
            fontFamily: 'Gilroy-Reguler',
          ),
        ),
        Text(
          '\t\tMinutes',
          style: TextStyle(
            fontSize: 14,
            letterSpacing: 1,
            fontFamily: 'Gilroy-Bold',
          ),
        ),
      ],
    );
  }
}
