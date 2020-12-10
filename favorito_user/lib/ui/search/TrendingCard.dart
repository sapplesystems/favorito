import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/search/TrendingBusinessData.dart';
import 'package:favorito_user/ui/home/RatingHolder.dart';
import 'package:favorito_user/ui/home/ServicesOfBusiness.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class TrendingCard extends StatelessWidget {
  TrendingBusinessData data;
  TrendingCard({
    Key key,
    @required this.sm,
    @required this.data,
  }) : super(key: key);

  final SizeManager sm;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))),
      elevation: 10,
      child: Row(
        children: [
          Container(
            width: sm.scaledWidth(36),
            padding: EdgeInsets.only(left: sm.scaledHeight(1.5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(data.businessName,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                ServicesOfBusiness(sm: sm, data: data.subCategory),
                Padding(
                  padding: EdgeInsets.only(
                      left: sm.scaledWidth(2), top: sm.scaledHeight(1)),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xfffff6ea),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    width: sm.scaledWidth(18),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: sm.scaledHeight(1)),
                      child:
                          RatingHolder(sm: sm, rate: data.avgRating.toString()),
                    ),
                  ),
                ),
                SizedBox(height: sm.scaledHeight(1)),
                Text('${data.distance} km | ' + data.townCity,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: myGrey)),
                SizedBox(height: sm.scaledHeight(.5)),
                Text(data.businessStatus,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: (data.businessStatus).contains('Off')
                            ? myGrey
                            : Colors.green)),
                Text("Opens | ${data.avgRating}",
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
                Text("Closes | 09:00",
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            child: Image.network(
              "https://source.unsplash.com/random/600*400",
              height: sm.scaledHeight(26),
              fit: BoxFit.cover,
              width: sm.scaledWidth(38),
            ),
          ),
        ],
      ),
    );
  }
}
