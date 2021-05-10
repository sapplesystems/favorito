import 'package:favorito_user/component/ImageMaster.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/search/BusinessProfileData.dart';
import 'package:favorito_user/model/appModel/search/TrendingBusinessModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/business/BusinessProfileProvider.dart';
import 'package:favorito_user/ui/home/ServicesOfBusiness.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/MyString.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class MostPopular extends StatefulWidget {
  @override
  _mostPopularState createState() => _mostPopularState();
}

class _mostPopularState extends State<MostPopular> {
  List<BusinessProfileData> dataList;
  SizeManager sm;
  @override
  void initState() {
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
            return Center(
                child: Text(
              loading,
              style:
                  Theme.of(context).textTheme.headline6.copyWith(fontSize: 12),
            ));
          else if (snapshot.hasError)
            return Center(child: Text('Error : ${snapshot.error}'));
          else if (dataList != snapshot.data.data) {
            dataList = snapshot.data.data;
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dataList?.length ?? 0,
                itemBuilder: (BuildContext contect, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Provider.of<BusinessProfileProvider>(context,
                                    listen: false)
                                .setBusinessId(dataList[index].businessId);
                            Navigator.of(context).pushNamed('/businessProfile'
                                // ,arguments: dataList[index].businessId
                                );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            // elevation: 10,
                            child: SizedBox(
                              height: sm.h(16),
                              width: sm.w(34),
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  child:
                                      ImageMaster(url: dataList[index].photo)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 4.0),
                          child: Text(
                              dataList[index].businessName.length <= 12
                                  ? dataList[index].businessName
                                  : dataList[index]
                                          .businessName
                                          .substring(0, 12) +
                                      '..',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ServicesOfBusiness(
                            data: dataList[index].subCategory,
                            sm: sm,
                          ),
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                          fontSize: 12, color: myOrangeBase),
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
