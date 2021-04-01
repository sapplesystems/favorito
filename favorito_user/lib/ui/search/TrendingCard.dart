import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/search/BusinessProfileData.dart';
import 'package:favorito_user/ui/business/BusinessProfileProvider.dart';
import 'package:favorito_user/ui/home/RatingHolder.dart';
import 'package:favorito_user/ui/home/ServicesOfBusiness.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class TrendingCard extends StatelessWidget {
  BusinessProfileData data;
  TrendingCard({
    Key key,
    @required this.sm,
    @required this.data,
  }) : super(key: key);

  final SizeManager sm;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<BusinessProfileProvider>(context, listen: false)
            .setBusinessId(data.businessId);
        Navigator.of(context).pushNamed('/businessProfile'
            // , arguments: data.businessId
            );
      },
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        elevation: 10,
        child: Row(
          children: [
            Container(
              width: sm.w(36),
              padding: EdgeInsets.only(left: sm.h(1.5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(data.businessName,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                  ServicesOfBusiness(sm: sm, data: data.subCategory),
                  Padding(
                      padding: EdgeInsets.only(left: sm.w(2), top: sm.h(1)),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xfffff6ea),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          width: sm.w(18),
                          child: Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: sm.h(1)),
                              child: RatingHolder(
                                  sm: sm, rate: data.avgRating.toString())))),
                  SizedBox(height: sm.h(1)),
                  Text(
                      "${data.distance?.toStringAsFixed(1) ?? ''} ${data.townCity != null ? '| ' + data.townCity : ''}",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: myGrey)),
                  SizedBox(height: sm.h(.5)),
                  Text(data.businessStatus,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: (data.businessStatus).contains('Off')
                              ? myGrey
                              : Colors.green)),
                  Text(
                      "Opens | ${data?.startHours?.substring(0, 5)}\nCloses | ${data?.endHours?.substring(0, 5)}",
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
                data.photo ?? "",
                height: sm.h(26),
                fit: BoxFit.cover,
                width: sm.w(38),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
