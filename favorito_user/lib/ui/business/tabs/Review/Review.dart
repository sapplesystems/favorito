import 'package:bot_toast/bot_toast.dart';
import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/Review/ReviewModel.dart';
import 'package:favorito_user/ui/business/tabs/Review/ReviewProvider.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/dateformate.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import '../../../../utils/Extentions.dart';

class Review extends StatelessWidget {
  SizeManager sm;
  ReviewProvider vaTrue;
  bool isFirst = true;
  @override
  Widget build(BuildContext context) {
    if (isFirst) {
      vaTrue = Provider.of<ReviewProvider>(context, listen: true);
      vaTrue.reviewModel.clear();
      sm = SizeManager(context);
      vaTrue.getReviewReplies();
      isFirst = false;
    }
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            iconTheme: IconThemeData(color: Colors.black),
            centerTitle: true,
            title: Text("Review",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: myRed),
                textScaleFactor: 1)),
        // funReviewgetReviewReplies
        body: RefreshIndicator(
          onRefresh: () async {
            vaTrue.getReviewReplies();
          },
          child: ListView(
            children: [
              Visibility(
                visible: !vaTrue.getSelectedReviewId(),
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    height: sm.h(54),
                    child: Card(
                        child: bodyData(
                            ctrl: vaTrue.controller,
                            data: vaTrue.reviewModel,
                            rat: 0))),
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                child: EditTextComponent(
                    valid: true,
                    title: "Reply",
                    controller: vaTrue.controller,
                    maxLines: 5,
                    hint: "Enter reply to user",
                    security: false),
              ),
              // ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: sm.w(20)),
                child: NeumorphicButton(
                  style: NeumorphicStyle(
                      // shape: NeumorphicShape.concave,
                      // depth: 11,
                      intensity: 40,
                      surfaceIntensity: -.4,
                      // lightSource: LightSource.topLeft,
                      color: myButtonBackground,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.all(Radius.circular(24.0)))),
                  margin: EdgeInsets.symmetric(horizontal: sm.w(10)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: sm.w(2)),
                    child: Text("Submit",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: myRed),
                        textScaleFactor: .65),
                  ),
                  onPressed: () {
                    if (vaTrue.controller.text != null &&
                        vaTrue.controller.text.length > 0) {
                      vaTrue.businessSetReview(context);
                    } else {
                      BotToast.showText(text: "Please fill Review..");
                    }
                  },
                ),
              ),
              //   ],
              // );
            ],
          ),
        ));
  }
}

class bodyData extends StatelessWidget {
  List<Reviewdata> data;
  var rat;
  bodyData({Key key, @required this.ctrl, @required this.data, this.rat})
      : super(key: key);

  final TextEditingController ctrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView.builder(
          itemCount: data?.length ?? 0,
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
                      if (index != 0 &&
                          data[index].bToU != data[index - 1]?.bToU)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            (data[index].bToU != 0 &&
                                    data[index - 1]?.bToU == 0)
                                ? "Business Reply : "
                                : "User Reply : ",
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(color: myRed),
                            textScaleFactor: .65,
                          ),
                        ),
                    ],
                  ),
                  Column(children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (index == 0)
                            Expanded(
                              child: Text(data[index].reviews,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(fontWeight: FontWeight.w400),
                                  textScaleFactor: .65),
                            )
                          else
                            Expanded(
                                child: Text(data[index].reviews,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(fontWeight: FontWeight.w400),
                                    textScaleFactor: .7)),
                          // if (_v[index].bToU != 0)
                          Text(
                            dateFormat4
                                .format(DateTime.parse(data[index].createdAt)),
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: myGreyDark),
                          ),
                        ]),
                  ]),

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
                  if (index != data.length - 1 &&
                      data[index].bToU != data[index + 1].bToU)
                    Divider(height: 10)
                ],
              ),
            );
          }),
    );
  }
}
