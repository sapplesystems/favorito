import 'package:Favorito/component/MyOutlineButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/model/review/ReviewModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/dateformate.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class review extends StatefulWidget {
  String userid;
  int id;
  var rating;
  review({this.userid, this.rating, this.id});
  @override
  _reviewState createState() => _reviewState();
}

class _reviewState extends State<review> {
  TextEditingController ctrl = TextEditingController();
  ReviewModel rm;
  SizeManager sm;
  @override
  @override
  ProgressDialog pr;
  Future<ReviewModel> futureData;

  @override
  void initState() {
    super.initState();
    futureData = WebService.funReviewgetReviewReplies(
        {"user_id": widget.userid, "review_id": widget.id});
  }

  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, isDismissible: false)
      ..style(
          message: 'Please wait...',
          borderRadius: 8.0,
          backgroundColor: Colors.white,
          progressWidget: CircularProgressIndicator(),
          elevation: 8.0,
          insetAnimCurve: Curves.easeInOut,
          progress: 0.0,
          maxProgress: 100.0,
          progressTextStyle: TextStyle(
              color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
          messageTextStyle: TextStyle(
              color: myRed, fontSize: 19.0, fontWeight: FontWeight.w600));

    sm = SizeManager(context);
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
            "Review",
            style: TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontFamily: 'Gilroy-Bold',
                letterSpacing: .2),
          ),
        ),
        // funReviewgetReviewReplies
        body: FutureBuilder<ReviewModel>(
          future: futureData,
          builder: (BuildContext context, AsyncSnapshot<ReviewModel> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: Text('Please wait its loading...'));
            else {
              rm = snapshot.data;
              return ListView(
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      height: sm.h(54),
                      child: Card(
                          child: bodyData(
                              ctrl: ctrl, data: rm, rat: widget.rating))),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                    child: txtfieldboundry(
                      valid: true,
                      title: "Reply",
                      controller: ctrl,
                      maxLines: 5,
                      hint: "Enter reply to user",
                      security: false,
                    ),
                  ),
                  // ),
                  MyOutlineButton(
                    title: "Submit",
                    function: () {
                      if (ctrl.text != null && ctrl.text.length > 0) {
                        Map _map = {
                          "user_id": widget.userid,
                          "review": ctrl.text,
                          "parent_id": rm.data[rm.data.length - 1].id
                        };
                        print("RequestData:$_map");
                        pr?.show();
                        WebService.funReviewReply(_map).then((value) {
                          // new Future.delayed(const Duration(seconds: 4), () {
                          WebService.funReviewgetReviewReplies({
                            "user_id": widget.userid,
                            "review_id": widget.id
                          }).then((value) {
                            pr?.hide();
                            rm.data.clear();
                            setState(() {
                              ctrl.text = "";
                              rm.data = value.data;
                            });
                          });
                          // });
                        });
                      } else {
                        BotToast.showText(text: "Please fill Review..");
                      }
                    },
                  ),
                  //   ],
                  // );
                ],
              );
            }
          },
        ));
  }
}

class bodyData extends StatelessWidget {
  ReviewModel data;
  var rat;
  bodyData({Key key, @required this.ctrl, @required this.data, this.rat})
      : super(key: key);

  final TextEditingController ctrl;

  @override
  Widget build(BuildContext context) {
    var _v = data?.data;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView.builder(
          itemCount: _v?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // if ()
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (index != 0 && _v[index].bToU != _v[index - 1]?.bToU)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            (_v[index].bToU != 0 && _v[index - 1]?.bToU == 0)
                                ? "Business Reply : "
                                : "User Reply : ",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (index == 0)
                            Expanded(
                              child: Text(_v[index].reviews,
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                            )
                          else
                            Expanded(child: Text(_v[index].reviews)),
                          // if (_v[index].bToU != 0)
                          Text(
                            dateFormat4
                                .format(DateTime.parse(_v[index].createdAt)),
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          for (int i = 0; i < rat; i++)
                            Icon(
                              Icons.star,
                              size: 16,
                              color: index == 0 ? myRed : Colors.white,
                            ),
                        ],
                      ),
                    ],
                  ),
                  if (index != _v.length - 1 &&
                      _v[index].bToU != _v[index + 1].bToU)
                    Divider(
                      height: 10,
                    )
                ],
              ),
            );
          }),
    );
  }
}
