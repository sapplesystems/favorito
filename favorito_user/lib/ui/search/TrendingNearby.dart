import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/search/BusinessProfileData.dart';
import 'package:favorito_user/model/appModel/search/TrendingBusinessModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/search/TrendingCard.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class trendingNearby extends StatefulWidget {
  @override
  _trendingNearbyState createState() => _trendingNearbyState();
}

class _trendingNearbyState extends State<trendingNearby> {
  List<BusinessProfileData> trendingBusinessData;
  SizeManager sm;
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return FutureBuilder<TrendingBusinessModel>(
        future: APIManager.trendingBusiness(context),
        builder: (BuildContext context,
            AsyncSnapshot<TrendingBusinessModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text('Please wait its loading...'));
          } else {
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            else {
              if (trendingBusinessData != snapshot.data.data)
                trendingBusinessData = snapshot.data.data;
              return Container(
                  height: sm.h(26),
                  padding: EdgeInsets.all(4.0),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: trendingBusinessData.length,
                      itemBuilder: (BuildContext context, int Index) {
                        return TrendingCard(
                            sm: sm, data: trendingBusinessData[Index]);
                      }));
            }
          }
        });
  }
}
