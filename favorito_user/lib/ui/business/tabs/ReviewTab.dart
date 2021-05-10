import 'package:favorito_user/component/ImageMaster.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/search/BusinessProfileData.dart';
import 'package:favorito_user/ui/user/PersonalInfo/UserAddressProvider.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class ReviewTab extends StatelessWidget {
  BusinessProfileData data;
  ReviewTab({this.data});
  SizeManager sm;

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Scaffold(
      // appBar: AppBar(
      //     backgroundColor: Colors.transparent,
      //     elevation: 0,
      //     title: Text("Review's")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
            shrinkWrap: true,
            physics: new NeverScrollableScrollPhysics(),
            children: [
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                  flex: 2,
                  child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      direction: Axis.vertical,
                      spacing: -8,
                      children: [
                        Text(
                          '4.5',
                          style: Theme.of(context).textTheme.headline3.copyWith(
                              fontWeight: FontWeight.w500, fontSize: 46),
                        ),
                        Text(
                          'out of 5',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              fontWeight: FontWeight.w100, fontSize: 10),
                        )
                      ]),
                ),
                Expanded(
                  flex: 8,
                  child: Column(children: [
                    for (int i = 0; i < 5; i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          for (int j = 0; j < 5; j++)
                            if (i <= j)
                              Padding(
                                  padding: EdgeInsets.all(0.8),
                                  child:
                                      Icon(Icons.star, size: 18, color: myRed))
                            else
                              Padding(
                                  padding: const EdgeInsets.all(0.8),
                                  child: Icon(Icons.star,
                                      size: 18, color: Colors.transparent)),
                          LinearPercentIndicator(
                            width: sm.w(46),
                            lineHeight: 4.0,
                            percent: .5 <= 0 ? 0.0 : .3,
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            backgroundColor: Colors.grey,
                            progressColor: myRed,
                          ),
                        ],
                      ),
                    Text(
                      '100 Ratings       30 reviews',
                      style: Theme.of(context).textTheme.headline3.copyWith(
                          fontSize: 10,
                          letterSpacing: .40,
                          fontWeight: FontWeight.w600,
                          color: myGrey),
                    )
                  ]),
                ),
              ]),
              Divider(),
              ListView(shrinkWrap: true, children: [
                Card(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                  height: sm.h(8),
                                  width: sm.h(8),
                                  child: ImageMaster(
                                      url: Provider.of<UserAddressProvider>(
                                              context,
                                              listen: true)
                                          .getProfileImage()))),
                          SizedBox(width: sm.w(4)),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'John Hopkin',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(fontWeight: FontWeight.w300),
                                  ),
                                  Text(
                                    '2 Reviews',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w100),
                                  )
                                ]),
                          ),
                          Icon(Icons.more_vert, color: myGrey)
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        for (int i = 0; i < 5; i++)
                          Icon(
                            Icons.star,
                            size: 16,
                            color: 0 == 0 ? myRed : Colors.white,
                          ),
                        SizedBox(width: 20),
                        Text(
                          '12 Jan',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'Overall it was great experience. There are some things i didn’t liked. So you have to change it as soon as possibile. So you have to change it as soon as possibile',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              fontSize: 16,
                              letterSpacing: .40,
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.justify),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Padding(
                        padding: EdgeInsets.only(left: sm.w(4)),
                        child: Icon(Icons.favorite_border_outlined,
                            color: Colors.black87),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: sm.w(2)),
                        child: Text(
                          '3',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              fontSize: 15,
                              letterSpacing: .40,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Icon(Icons.share)
                    ])
                  ],
                ))
              ])
            ]),
      ),
    );
  }
}
