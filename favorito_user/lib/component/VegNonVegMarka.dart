import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class VegNonVegMarka extends StatelessWidget {
  SizeManager sm;
  bool isVeg;
  VegNonVegMarka({this.isVeg});
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isVeg ? myGreenLight : myRedLight1,
      ),
      padding: EdgeInsets.all(10),
      child: Icon(
        Icons.brightness_1,
        size: sm.h(2),
        color: isVeg ? myGreenDark : myRedDark1,
      ),
    );
  }
}
