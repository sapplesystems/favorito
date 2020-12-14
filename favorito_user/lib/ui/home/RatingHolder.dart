import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class RatingHolder extends StatelessWidget {
  String rate;
  RatingHolder({
    Key key,
    @required this.sm,
    @required this.rate,
  }) : super(key: key);

  final SizeManager sm;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xfffff6ea),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      width: sm.w(18),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.star, color: myOrangeBase),
        //here id is used to show but rating need to be
        Text(
          rate,
          style: TextStyle(color: myOrangeBase),
        )
      ]),
    );
  }
}
