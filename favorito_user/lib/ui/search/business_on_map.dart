import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/search/BusinessProfileData.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:favorito_user/ui/business/BusinessProfileProvider.dart';
import 'package:favorito_user/ui/home/RatingHolder.dart';
import 'package:favorito_user/ui/home/ServicesOfBusiness.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:provider/provider.dart';

class business_on_map extends StatefulWidget {
  List<BusinessProfileData> list;
  business_on_map({this.list});
  @override
  _business_on_mapState createState() => _business_on_mapState();
}

class _business_on_mapState extends State<business_on_map> {

  SizeManager sm;
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Container(
        height: sm.h(26),
        padding: EdgeInsets.all(4.0),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount:widget.list.length,
            itemBuilder: (BuildContext context, int i) {
              var data = widget.list[i];
              return InkWell(
                onTap: () {
                  Provider.of<BusinessProfileProvider>(context, listen: false)
                      .setBusinessId(data.businessId);
                  Navigator.of(context).pushNamed('/businessProfile'
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  elevation: 10,
                  child: 
                      SizedBox(
                        width: sm.w(70),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  Text(data.businessName,
                                  textAlign: TextAlign.start,
                                  style:
                                    Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(fontSize: 16, fontWeight: FontWeight.w800)),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: ServicesOfBusiness(sm: sm, data: data.subCategory),
                          )
                              ]),

                              Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xfffff6ea),
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                  ),
                                  width: sm.w(18),
                                  child: Padding(
                                      padding:
                                      EdgeInsets.symmetric(horizontal: sm.h(1)),
                                      child: RatingHolder(
                                          sm: sm, rate: double.parse('${data.avgRating??0.0}').toStringAsFixed(1)))),
                              ]),
                            ),
                              Container(
                              height: 82,
                              child: Expanded(
                                child: ListView(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                 for(int i=0;i<4;i++) Padding(
                                   padding: const EdgeInsets.symmetric(horizontal: 4),
                                   child: ClipRRect(
                                                        borderRadius: BorderRadius.all(
                                                           Radius.circular(12),
                                                          // bottomRight: Radius.circular(12),
                                                        ),
                                                        child: Image.network(
                                                          data.photo ?? "",
                                                          height: sm.h(12),
                                                          fit: BoxFit.cover,
                                                          width: sm.h(14),
                                                        ),
                                                      ),
                                 ),
                                ]),
                              ),
                            )
                            
                            // SizedBox(height: sm.h(1)),
                            // Text(
                            //     "${data.distance?.toStringAsFixed(1) ?? ''}",
                            //     style: Theme.of(context)
                            //           .textTheme
                            //           .headline6
                            //           .copyWith(
                            //         fontSize: 12,
                            //         fontWeight: FontWeight.w300,
                            //         color: myGrey)),
                            // SizedBox(height: sm.h(.5)),
                            // Text(data.businessStatus,
                            //     style: Theme.of(context)
                            //           .textTheme
                            //           .headline6
                            //           .copyWith(
                            //         fontSize: 12,
                            //         fontWeight: FontWeight.w300,
                            //         color: (data.businessStatus).contains('Off')
                            //             ? myGrey
                            //             : Colors.green)),
                            // Text(
                            //     "Opens | ${data?.startHours?.substring(0, 5)}\nCloses | ${data?.endHours?.substring(0, 5)}",
                            //     style:
                            //     Theme.of(context)
                            //           .textTheme
                            //           .headline6
                            //           .copyWith(fontSize: 12, fontWeight: FontWeight.w300)),
                          ],
                        ),
                      ),
                      
                    
                ),
              );
            }));
  }
}
