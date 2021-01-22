import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/model/review/ReviewListModel.dart';
import 'package:Favorito/model/review/ReviewintroModel.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/review/review.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class reviewList extends StatefulWidget {
  @override
  _reviewListState createState() => _reviewListState();
}

class _reviewListState extends State<reviewList> {
  SizeManager sm;
  ReviewintroModel rmi = ReviewintroModel();
  List<double> ratinglist;
  var page = 0;
  List<ReviewListData> rlm = List();

  @override
  void initState() {
    super.initState();
    getData();
    ratinglist = List();
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
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: sm.w(4), vertical: sm.h(3)),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text(
                  (rmi?.data?.avgRatingData?.avgRating ?? 0.000)
                      .toStringAsFixed(1),
                  style: TextStyle(fontSize: 24)),
              Icon(Icons.star, color: myRed)
            ]),
            Text(
                "${rmi?.data?.totalRating?.totalRatings ?? 0} Rating\n${rmi?.data?.totalReview?.totalReviews ?? 0} Reviews",
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
                            child: Icon(
                              Icons.star,
                              size: 18,
                              color: myRed,
                            ),
                          )
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
                  Container(height: sm.h(4), child: header()),
                  Container(
                    height: sm.h(56),
                    child: ListView(
                      children: [
                        for (int i = 0; i < (rlm.length ?? 0); i++)
                          rowCard(rlm[i]?.fullName, rlm[i]?.reviewDate, () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => review(
                                        userid: rlm[i].userId,
                                        id: rlm[i].id,
                                        rating: rlm[i].rating)));
                          }, rlm[i]?.rating),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }

  Widget rowCard(String title, String subtitle, Function function, int rat) {
    return InkWell(
      onTap: function,
      child: Card(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 6),
            margin: EdgeInsets.symmetric(vertical: 12),
            decoration: bd3,
            child: ListTile(
                title: Text(title,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                subtitle: Text(subtitle),
                trailing: Container(
                  height: 40,
                  width: 40,
                  child: Row(children: [
                    Text("$rat", style: TextStyle(fontSize: 16)),
                    Icon(Icons.star, color: myRed, size: 16)
                  ]),
                ))),
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
        ratinglist.add(va.rating1.toDouble() * .1);
        ratinglist.add(va.rating2.toDouble() * .1);
        ratinglist.add(va.rating3.toDouble() * .1);
        ratinglist.add(va.rating4.toDouble() * .1);
        ratinglist.add(va.rating5.toDouble() * .1);
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
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Icon(Icons.filter_alt, color: myRed, size: 30),
      Row(
        children: [
          Text(
            "Alphabetical",
            style: TextStyle(color: Colors.grey),
          ),
          Icon(Icons.sort, color: myRed, size: 30)
        ],
      )
    ]);
  }
}
