import 'package:favorito_user/component/ImageMaster.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/Review/ReviewListModel.dart';
import 'package:favorito_user/model/appModel/search/BusinessProfileData.dart';
import 'package:favorito_user/ui/business/tabs/Review/RateMe.dart';
import 'package:favorito_user/ui/business/tabs/Review/ReviewProvider.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../../../utils/Extentions.dart';

class ReviewTab extends StatelessWidget {
  BusinessProfileData data;
  ReviewTab({this.data});
  SizeManager sm;
  ReviewProvider vaTrue;
  bool isFirst = true;

  @override
  Widget build(BuildContext context) {
    if (isFirst) {
      sm = SizeManager(context);
      vaTrue = Provider.of<ReviewProvider>(context, listen: true);

      vaTrue.getCurrentBusinessId(context);
      vaTrue.getrating();
      vaTrue.getReviewListing(context);
      isFirst = false;
    }
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () async {
        vaTrue.getReviewListing(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          // height: sm.h(20),
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
                            '${vaTrue.getRatingData()?.avgRatingData?.avgRating ?? 0}'
                                .substring(0, 3),
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                .copyWith(
                                    fontWeight: FontWeight.w400, fontSize: 42),
                          ),
                          Text(
                            'Out of 5',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
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
                                    child: Icon(Icons.star,
                                        size: 18, color: myRed))
                              else
                                Padding(
                                    padding: const EdgeInsets.all(0.8),
                                    child: Icon(Icons.star,
                                        size: 18, color: Colors.transparent)),
                            LinearPercentIndicator(
                              width: sm.w(46),
                              lineHeight: 4.0,
                              percent: 1.0 <= 0 ? 0.0 : vaTrue.ratingPoints[i],
                              linearStrokeCap: LinearStrokeCap.roundAll,
                              backgroundColor: Colors.grey,
                              progressColor: myRed,
                            ),
                          ],
                        ),
                      Text(
                        '${vaTrue.getRatingData()?.totalRating?.totalRatings ?? 0} Ratings       ${vaTrue.getRatingData()?.totalReview?.totalReviews ?? 0} reviews',
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
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          // vaTrue.setRootId("null");
                          // Navigator.pushNamed(context, '/review')
                          //     .whenComplete(() {
                          //   vaTrue.getReviewListing(
                          //       // Provider.of<BusinessProfileProvider>(context,
                          //       // listen: true)
                          //       // .getBusinessId()
                          //       ,
                          //       context);
                          // });

                          showModalBottomSheet<void>(
                              isDismissible: false,
                              enableDrag: true,
                              isScrollControlled: true,
                              context: context,
                              backgroundColor: Color.fromRGBO(255, 0, 0, 0),
                              builder: (BuildContext context) {
                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setState) {
                                  return Container(
                                      height: sm.h(26),
                                      decoration: new BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: new BorderRadius.only(
                                            topLeft:
                                                const Radius.circular(40.0),
                                            topRight:
                                                const Radius.circular(40.0),
                                          )),
                                      child: RateMe());
                                });
                              }).whenComplete(() {
                            vaTrue.getCurrentBusinessId(context);
                            vaTrue.getrating();
                            vaTrue.getReviewListing(context);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '+ Add Rating ',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: myRed),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          vaTrue.setRootId("null");

                          Navigator.pushNamed(context, '/review')
                              .whenComplete(() {
                            vaTrue.getCurrentBusinessId(context);
                            vaTrue.getrating();
                            vaTrue.getReviewListing(context);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '+ Add Review ',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: myRed),
                          ),
                        ),
                      )
                    ]),
                Container(
                  height: sm.h(41),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: vaTrue.getAllreviewsListForUi()?.length,
                      itemBuilder: (BuildContext _context, int _index) {
                        List<ReviewData1> _data =
                            vaTrue.getAllreviewsListForUi();
                        return InkWell(
                          onTap: () {
                            if (_data[_index].self == 1) {
                              vaTrue.setRootId(_data[_index].rootId.toString());
                              Navigator.pushNamed(context, '/review')
                                  .whenComplete(() {
                                vaTrue.getCurrentBusinessId(context);
                                vaTrue.getrating();
                                vaTrue.getReviewListing(context);
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Card(
                              elevation: 6,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(children: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Container(
                                                height: sm.h(6),
                                                width: sm.h(6),
                                                child: ImageMaster(
                                                    url: _data[_index]?.photo ??
                                                        "https://emoji.gg/assets/emoji/f.png"))),
                                        SizedBox(width: sm.w(4)),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    _data[_index].name ?? '',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                    textScaleFactor: .8,
                                                  ),
                                                  Text(
                                                    '${_data[_index]?.totalReviews ?? 0} Reviews',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w100),
                                                    textScaleFactor: .6,
                                                  )
                                                ]),
                                          ),
                                        ),
                                        // Icon(Icons.more_vert, color: myGrey)
                                      ]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 4.0),
                                      child: Row(children: [
                                        for (int i = 0;
                                            i < (_data[_index].rating ?? 0);
                                            i++)
                                          Icon(
                                            Icons.star,
                                            size: 18,
                                            color:
                                                0 == 0 ? myRed : Colors.white,
                                          ),
                                        SizedBox(width: 20),
                                        Text(
                                            _data[_index]
                                                ?.createdAt
                                                ?.substring(0, 6)
                                                ?.replaceAll('-', ' '),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .copyWith(
                                                    color: myGrey,
                                                    fontWeight:
                                                        FontWeight.w400),
                                            textScaleFactor: .6)
                                      ]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          '${_data[_index]?.reviews ?? ' '}'
                                          // ?.sentenseCase()
                                          ,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(
                                                  fontSize: 16,
                                                  letterSpacing: .40,
                                                  fontWeight: FontWeight.w400),
                                          textAlign: TextAlign.justify),
                                    ),
                                    // Row(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.start,
                                    //     children: [
                                    //       Padding(
                                    //         padding:
                                    //             EdgeInsets.only(left: sm.w(4)),
                                    //         child: Icon(
                                    //             Icons.favorite_border_outlined,
                                    //             color: Colors.black87),
                                    //       ),
                                    //       Padding(
                                    //         padding: EdgeInsets.symmetric(
                                    //             horizontal: sm.w(2)),
                                    //         child: Text(
                                    //           '3',
                                    //           style: Theme.of(context)
                                    //               .textTheme
                                    //               .headline6
                                    //               .copyWith(
                                    //                   fontSize: 15,
                                    //                   letterSpacing: .40,
                                    //                   fontWeight:
                                    //                       FontWeight.w600),
                                    //         ),
                                    //       ),
                                    //       Icon(Icons.share)
                                    //     ])
                                    Visibility(
                                      visible:
                                          _data[_index]?.businessReview != null,
                                      child: Row(children: [
                                        Container(
                                            height: 50,
                                            padding:
                                                EdgeInsets.only(left: 18.0),
                                            margin: EdgeInsets.only(
                                                left: 18.0,
                                                top: 10,
                                                bottom: 40),
                                            child: SvgPicture.asset(
                                                'assets/icon/Line.svg')),
                                        // Visibility(
                                        //   visible:
                                        //       _data[_index]?.businessReview !=
                                        //           null,
                                        //   child:
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Response from owner",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline3
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                    textScaleFactor: .3),
                                                Text(
                                                  _data[_index]
                                                      ?.createdAt
                                                      ?.replaceAll('-', ' ')
                                                      ?.substring(0, 6),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline3
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: myGrey),
                                                  textScaleFactor: .35,
                                                ),
                                                Text(
                                                    _data[_index]
                                                            ?.businessReview ??
                                                        '',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline3
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                    textScaleFactor: .35)
                                              ]),
                                        ),
                                        // ),
                                      ]),
                                    ),
                                  ]),
                            ),
                          ),
                        );
                      }),
                )
              ]),
        ),
      ),
    ));
  }
}
