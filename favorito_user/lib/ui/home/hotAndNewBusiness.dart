import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/Business/NewBusinessModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/business/BusinessProfileProvider.dart';
import 'package:favorito_user/ui/home/RatingHolder.dart';
import 'package:favorito_user/ui/home/ServicesOfBusiness.dart';
import 'package:favorito_user/ui/home/myClipRRect.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class HotAndNewBusiness extends StatefulWidget {
  HotAndNewBusiness({Key key}) : super(key: key);

  @override
  _HotAndNewBusinessState createState() => _HotAndNewBusinessState();
}

class _HotAndNewBusinessState extends State<HotAndNewBusiness> {
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
            return Center(
                child: Text(
              'Please wait its loading...',
              style:
                  Theme.of(context).textTheme.headline6.copyWith(fontSize: 16),
            ));
          else {
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            else {
              if (newBusinessData != snapshot.data)
                newBusinessData = snapshot.data;
              return Container(
                padding: EdgeInsets.only(bottom: sm.h(2)),
                height: sm.h(25),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: newBusinessData?.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: InkWell(
                          onTap: () {
                            Provider.of<BusinessProfileProvider>(context,
                                    listen: false)
                                .setBusinessId(
                                    newBusinessData.data[index].businessId);
                                    
                            Navigator.of(context).pushNamed('/businessProfile'
                                // ,arguments:
                                //     newBusinessData.data[index].businessId
                                );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            elevation: 50,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Stack(children: [
                                    myClipRRect(
                                        image:
                                            newBusinessData.data[index].photo,
                                        sm: sm),
                                    Positioned(
                                      top: sm.h(1),
                                      left: sm.w(1),
                                      child: RatingHolder(
                                          sm: sm,
                                          rate: newBusinessData.data[index].id
                                              .toString()),
                                    ),
                                  ]),
                                  Container(
                                    width: sm.w(36),
                                    padding: EdgeInsets.only(left: sm.w(2)),
                                    child: Text(
                                        newBusinessData
                                            .data[index].businessName,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: sm.w(2)),
                                    child: ServicesOfBusiness(
                                        sm: sm,
                                        data: newBusinessData
                                            .data[index].subCategory),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: sm.w(2)),
                                    child: Text(
                                        "${newBusinessData?.data[index]?.distance?.toStringAsFixed(1) ?? '00'} km | ${newBusinessData.data[index].townCity ?? ''}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: sm.w(2), bottom: sm.w(2)),
                                    child: Text(
                                        newBusinessData
                                            .data[index].businessStatus,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                            color: (newBusinessData.data[index]
                                                        .businessStatus)
                                                    .contains('Off')
                                                ? myGrey
                                                : Colors.green)),
                                  ),
                                ]),
                          ),
                        ),
                      );
                    }),
              );
            }
          }
        });
  }
}
