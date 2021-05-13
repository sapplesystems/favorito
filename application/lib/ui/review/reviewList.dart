import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/model/review/ReviewListModel.dart';
import 'package:Favorito/model/review/ReviewintroModel.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/review/review.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ReviewList extends StatefulWidget {
  @override
  _ReviewListState createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  SizeManager sm;
  ReviewintroModel rmi = ReviewintroModel();
  List<double> ratinglist = [];
  var page = 0;
  List<ReviewListData> rlm = List();

  @override
  void initState() {
    super.initState();
    getData();
    getListData();
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    var y = 5;
    var x = 5;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        centerTitle: true,
        title: Text(
          "Review List",
          style: TextStyle(
              color: Colors.black,
              fontSize: 26,
              fontFamily: 'Gilroy-Bold',
              letterSpacing: .2),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getData();
          getListData();
        },
        child: ListView(shrinkWrap: true, children: [
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: sm.w(4), vertical: sm.h(3)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text(
                        (rmi?.data?.avgRatingData?.avgRating ?? 0.000)
                            .toStringAsFixed(1),
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600)),
                    Icon(Icons.star, color: myRed)
                  ]),
                  Text(
                      "${rmi?.data?.totalRating?.totalRatings ?? 0} Ratings\n${rmi?.data?.totalReview?.totalReviews ?? 0} Reviews",
                      style: TextStyle(fontSize: 14))
                ]),
          ),
          Padding(
            padding: EdgeInsets.only(left: sm.w(6), bottom: 12),
            child: Row(
              children: [
                Column(children: [
                  for (int i = 0; i < y; i++)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        for (int j = 0; j < x; j++)
                          if (i <= j)
                            Padding(
                                padding: EdgeInsets.all(0.8),
                                child: Icon(Icons.star, size: 18, color: myRed))
                          else
                            Padding(
                              padding: const EdgeInsets.all(0.8),
                              child: Icon(
                                Icons.star,
                                size: 18,
                                color: myBackGround,
                              ),
                            ),
                        LinearPercentIndicator(
                          width: 200.0,
                          lineHeight: 4.0,
                          percent: ratinglist.length <= 0 ? 0.0 : ratinglist[i],
                          // trailing: Icon(Icons.mood),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          backgroundColor: Colors.grey,
                          progressColor: myRed,
                        ),
                      ],
                    )
                ]),
              ],
            ),
          ),
          Container(
            height: sm.h(62),
            child: Card(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  children: [
                    Container(
                        // height: sm.h(4),
                        child: header()),
                    Container(
                      height: sm.h(52),
                      child: ListView(
                        children: [
                          for (int i = 0; i < (rlm.length ?? 0); i++)
                            rowCard(rlm[i]?.reviewDate, rlm[i]?.fullName,
                                rlm[i]?.reviews, () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => review(
                                          userid: rlm[i].userId,
                                          id: rlm[i].id,
                                          rating: rlm[i].rating ?? 0)));
                            }, rlm[i]?.rating ?? 0),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget rowCard(
      String date, String title, String subtitle, Function function, int rat) {
    return InkWell(
      onTap: function,
      child: Card(
        child: Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.symmetric(vertical: 12),
            decoration: bd3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(date,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily: 'Gilroy-Regular',
                            fontWeight: FontWeight.w400)),
                    Text(title,
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Gilroy-Regular',
                            fontWeight: FontWeight.w600)),
                    Container(
                      width: sm.w(75),
                      child: AutoSizeText(subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          minFontSize: 14,
                          maxFontSize: 14,
                          softWrap: false,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'Gilroy-Regular',
                              fontWeight: FontWeight.w400)),
                    ),
                  ],
                ),
                Row(children: [
                  Text("$rat",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: 'Gilroy-Regular',
                          fontWeight: FontWeight.w600)),
                  Icon(Icons.star, color: myRed, size: 16)
                ]),
              ],
            )),
      ),
    );
  }

  void getData() async {
    await WebService.funReviewIntro(context).then((value) {
      if (value.status == 'success') {
        setState(() {
          rmi = value;
        });
        var va = rmi.data.ratingsByPoints;
        ratinglist.add(va.rating5.toDouble() * .1);
        ratinglist.add(va.rating4.toDouble() * .1);
        ratinglist.add(va.rating3.toDouble() * .1);
        ratinglist.add(va.rating2.toDouble() * .1);
        ratinglist.add(va.rating1.toDouble() * .1);
        ratinglist = ratinglist.reversed;
      }
    });
  }

  void getListData() async {
    await WebService.funReviewList({"page": page}).then((value) {
      setState(() => rlm = value.data);
    });
  }
}

class header extends StatelessWidget {
  const header({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Icon(Icons.filter_alt, color: myRed, size: 30),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "Alphabetical",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Icon(Icons.sort, color: myRed, size: 30)
          ],
        )
      ]),
    );
  }
}
