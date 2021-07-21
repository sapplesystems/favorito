import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/ui/business/tabs/Review/ReviewProvider.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RateMe extends StatelessWidget {
  ReviewProvider vaTrue;
  SizeManager sm;
  bool isFirst = true;
  @override
  Widget build(BuildContext context) {
    if (isFirst) {
      sm = SizeManager(context);
      vaTrue = Provider.of<ReviewProvider>(context, listen: true);
    }
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text("Please rate our business",
            style: Theme.of(context).textTheme.headline6, textScaleFactor: 1),
      ),
      Center(
          child: SmoothStarRating(
        borderColor: myRed,
        color: myRed,
        rating: (vaTrue.myRating),
        isReadOnly: false,
        size: 50,
        filledIconData: Icons.star,
        halfFilledIconData: Icons.star_half,
        defaultIconData: Icons.star_border,
        starCount: 5,
        allowHalfRating: false,
        spacing: 2.0,
        onRated: (value) {
          vaTrue.myRating = value;
        },
      )),
      NeumorphicButton(
        style: NeumorphicStyle(
            // shape: NeumorphicShape.concave,
            // depth: 11,
            intensity: 40,
            surfaceIntensity: -.4,
            // lightSource: LightSource.topLeft,
            color: myButtonBackground,
            boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.all(Radius.circular(24.0)))),
        margin: EdgeInsets.symmetric(vertical: sm.w(5)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: sm.h(1), horizontal: sm.w(4)),
          child: Text("Submit",
              textAlign: TextAlign.center,
              style:
                  Theme.of(context).textTheme.headline6.copyWith(color: myRed),
              textScaleFactor: .65),
        ),
        onPressed: () {
          vaTrue.setRating();
          Navigator.pop(context);
        },
      ),
    ]);
  }
}
