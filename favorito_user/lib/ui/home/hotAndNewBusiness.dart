import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/Business/NewBusinessModel.dart';
import 'package:favorito_user/model/appModel/Business/SubCategory.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/home/RatingHolder.dart';
import 'package:favorito_user/ui/home/ServicesOfBusiness.dart';
import 'package:favorito_user/ui/home/myClipRRect.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class HotAndNewBusiness extends StatefulWidget {
  HotAndNewBusiness({Key key}) : super(key: key);

  @override
  _hotAndNewBusinessState createState() => _hotAndNewBusinessState();
}

class _hotAndNewBusinessState extends State<HotAndNewBusiness> {
  NewBusinessModel newBusinessData;
  SizeManager sm;

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return FutureBuilder<NewBusinessModel>(
        future: APIManager.hotAndNewBusiness(context),
        builder:
            (BuildContext context, AsyncSnapshot<NewBusinessModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: Text('Please wait its loading...'));
          else {
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            else {
              if (newBusinessData != snapshot.data)
                newBusinessData = snapshot.data;
              print(
                  "newBusinessData?.data?.length:${newBusinessData?.data?.length}");
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: newBusinessData?.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        elevation: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              children: [
                                myClipRRect(
                                    image: newBusinessData.data[index].photo,
                                    sm: sm),
                                Positioned(
                                  top: sm.scaledHeight(1),
                                  left: sm.scaledWidth(1),
                                  child: RatingHolder(
                                      sm: sm,
                                      rate: newBusinessData.data[index].id
                                          .toString()),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: sm.scaledWidth(2)),
                              child: Text(
                                  newBusinessData.data[index].businessName,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: sm.scaledWidth(2)),
                              child: ServicesOfBusiness(
                                  sm: sm,
                                  data:
                                      newBusinessData.data[index].subCategory),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: sm.scaledWidth(2)),
                              child: Text(
                                  "${newBusinessData.data[index].distance} km | ${newBusinessData.data[index].townCity}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: sm.scaledWidth(2),
                                  bottom: sm.scaledWidth(2)),
                              child: Text(
                                  newBusinessData.data[index].businessStatus,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      color: (newBusinessData
                                                  .data[index].businessStatus)
                                              .contains('Off')
                                          ? myGrey
                                          : Colors.green)),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }
          }
        });
  }
}
