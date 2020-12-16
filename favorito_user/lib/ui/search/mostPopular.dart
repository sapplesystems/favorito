import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/search/BusinessProfileData.dart';
import 'package:favorito_user/model/appModel/search/TrendingBusinessModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/home/ServicesOfBusiness.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/MyString.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class MostPopular extends StatefulWidget {
  @override
  _mostPopularState createState() => _mostPopularState();
}

class _mostPopularState extends State<MostPopular> {
  List<BusinessProfileData> dataList;
  SizeManager sm;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return FutureBuilder(
        future: APIManager.mostPopulerBusiness(),
        builder: (BuildContext context,
            AsyncSnapshot<TrendingBusinessModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: Text(loading));
          else if (snapshot.hasError)
            return Center(child: Text('Error : ${snapshot.error}'));
          else if (dataList != snapshot.data.data) {
            dataList = snapshot.data.data;
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dataList?.length ?? 0,
                itemBuilder: (BuildContext contect, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          elevation: 10,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            child: Image.network(
                              dataList[index].photo,
                              height: sm.h(16),
                              fit: BoxFit.cover,
                              width: sm.w(34),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(dataList[index].businessName,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ServicesOfBusiness(
                              data: dataList[index].subCategory),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: myOrangeBase,
                                  size: 12,
                                ),
                                Text(
                                  dataList[index].avgRating.toString(),
                                  style: TextStyle(color: myOrangeBase),
                                )
                              ]),
                        ),
                      ],
                    ),
                  );
                });
          }
        });
  }
}
