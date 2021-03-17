import 'dart:async';

import 'package:favorito_user/component/CirculerProgress.dart';
import 'package:favorito_user/component/Minut20.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/WaitList/WaitListBaseModel.dart';
import 'package:favorito_user/model/appModel/WaitList/WaitListDataModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/profile/business/waitlist/WaitListHeader.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/MyString.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/Extentions.dart';

class Waitlist extends StatefulWidget {
  WaitListDataModel data;

  Waitlist({this.data});

  @override
  _WaitlistState createState() => _WaitlistState();
}

class _WaitlistState extends State<Waitlist> {
  SizeManager sm;
  String btnTxt = waitingJoin;
  ProgressDialog pr;
  WaitListDataModel data = WaitListDataModel();
  bool waiting = false;
  var fut;
  Timer t;
  double per = 0;

  @override
  void initState() {
    fut = APIManager.baseUserWaitlistVerbose(
        {'business_id': widget.data.businessId});
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((val) {
      getWaitList(false);
    });
    // t = Timer(Duration(seconds: 10), getWaitList(false));
    abc();
  }

  @override
  void dispose() {
    t.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    pr = ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Fetching Data, please wait.');

    return SafeArea(
      child: Scaffold(
          backgroundColor: myBackGround,
          body: FutureBuilder<WaitListBaseModel>(
            future: fut,
            builder: (BuildContext context,
                AsyncSnapshot<WaitListBaseModel> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: Text(loading));
              else {
                try {
                  if (snapshot.data.data.isEmpty)
                    return Center(child: Text(snapshot.data.message ?? ''));
                } catch (e) {
                  print('Error 1:${e.toString()}');
                }
                if (snapshot.data.data.length != 0) {
                  var v = snapshot.data?.data[0];
                  // if (data != v && !waiting) {
                  data?.partiesBeforeYou = v?.partiesBeforeYou;
                  data?.businessName = v?.businessName;
                  data?.availableTimeSlots = v?.availableTimeSlots;
                  data?.minimumWaitTime = v?.minimumWaitTime ?? '00:00:00';
                  // }
                }

                return Padding(
                  padding: EdgeInsets.all(sm.w(6)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WaitListHeader(
                        title: waitingList,
                        preFunction: () {
                          getWaitList(true);
                          Navigator.pop(context);
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: sm.w(8), horizontal: sm.w(2.5)),
                        child: titlePart(data?.businessName ?? ''),
                      ),
                      bodyPart(),
                      footer()
                    ],
                  ),
                );
              }
            },
          )),
    );
  }

  Widget bodyPart() =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          height: sm.h(60),
          width: sm.w(40),
          padding: EdgeInsets.only(left: sm.w(2)),
          child: ListView(
            children: [
              beforeU('Availeble slot', 'wclock',
                  data?.availableTimeSlots?.convert24to12() ?? data.bookedSlot),
              SizedBox(height: sm.h(6)),
              Visibility(
                  visible: waiting,
                  child: beforeU(
                      '# in Parties', 'admin', data?.noOfPerson.toString())),
              Visibility(visible: waiting, child: SizedBox(height: sm.h(6))),
              beforeU('Parties Before you', 'admin',
                  data?.partiesBeforeYou.toString()),
              SizedBox(height: sm.h(6)),
              waitingTime(),
            ],
          ),
        ),
        Container(
          height: sm.h(60),
          width: sm.w(28),
          child: ListView(children: [
            for (int i = 0;
                i <
                    (!waiting
                        ? data?.partiesBeforeYou ?? 0
                        : (data?.partiesBeforeYou + 1));
                i++)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: sm.h(2.4),
                        width: sm.w(8),
                        padding: EdgeInsets.only(
                          left: sm.w(1.2),
                        ),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: AssetImage((data.userId != null &&
                                  i == data?.partiesBeforeYou)
                              ? "assets/icon/arrowRed.png"
                              : ''),
                        )),
                        child: Text(
                          (i + 1).toString() ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            color: (data.userId != null &&
                                    i == data?.partiesBeforeYou)
                                ? Colors.white
                                : myGrey,
                            fontFamily: 'Gilroy-Bold',
                          ),
                        ),
                      ),
                      Card(
                        color:
                            (data.userId != null && i == data?.partiesBeforeYou)
                                ? myRed
                                : myBackGround2,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 22),
                          child: SvgPicture.asset(
                            (data.userId != null && i == data?.partiesBeforeYou)
                                ? 'assets/icon/menWhite.svg'
                                : 'assets/icon/menBlack.svg',
                            height: sm.h(6),
                            fit: BoxFit.fill,
                          ),
                        ),
                      )
                    ]),
              )
          ]),
        ),
      ]);

  titlePart(String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            SizedBox(height: sm.h(.4)),
            Text(
              currentWaitlistAt ?? '',
              style: TextStyle(fontSize: 16, fontFamily: 'Gilroy-Regular'),
            ),
            Text(
              name ?? '',
              style: TextStyle(fontSize: 20, fontFamily: 'Gilroy-Bold'),
            ),
          ],
        ),
        SvgPicture.asset('assets/icon/cutlery.svg'),
      ],
    );
  }

  Widget footer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Card(
          color: myBackGround,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          child: InkWell(
            onTap: () {
              if (btnTxt == waitingJoin) {
                widget?.data?.fun1 = getWaitList;
                Navigator.of(context)
                    .pushNamed('/joinWaitList', arguments: widget.data);
              } else if (btnTxt == waitingCancel) {
                pr.show();
                APIManager.baseUserWaitlistCancel(
                    {'waitlist_id': data.waitlistId}).then((value) {
                  pr.hide();
                  if (value.status == 'success') Navigator.pop(context);
                });
              } else if (btnTxt == waitingCancel) {}
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 12, top: 16, bottom: 16),
                  child: Icon(
                    Icons.add_circle_outline,
                    color: myRed,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 12.0, right: 30, bottom: 16, top: 16),
                  child: Text(
                    btnTxt,
                    style: TextStyle(
                        color: Color(0xffdd2626),
                        fontSize: 18,
                        letterSpacing: 0.36,
                        fontFamily: 'Gilroy-Light'),
                  ),
                )
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            launch("tel://${widget.data.contact}");
          },
          child: Card(
              color: myBackGround,
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Padding(
                padding: EdgeInsets.all(sm.w(5)),
                child: SvgPicture.asset(
                  'assets/icon/call.svg',
                  height: sm.h(2.5),
                ),
              )),
        ),
      ],
    );
  }

  getWaitList(bool val) async {
    if (val) pr?.show();
    await APIManager.baseUserWaitlistGet(
        {'business_id': widget.data.businessId}).then((value) {
      if (val) pr?.hide();
      try {
        if (!value.data.isEmpty) {
          data?.createdAt = value.data[0].createdAt;
          waiting = true;
          data?.waitlistId = value.data[0].waitlistId;
          data?.userId = value.data[0].userId;
          data.updatedAt = value.data[0].updatedAt;
          data?.waitlistStatus = value.data[0].waitlistStatus;
          data?.noOfPerson = value.data[0].noOfPerson;
          data?.partiesBeforeYou = value.data[0].partiesBeforeYou;
          DateTime now = new DateTime.now();
          try {
            var difference =
                now.difference((DateTime.parse(data.updatedAt))).inMinutes;
            var _min = int.parse(data?.minimumWaitTime?.split(':')[1]);
            if (_min > difference)
              per = ((((_min - difference) * 100) / _min) / 100);
            else
              per = 0.0;
            setState(() {});
          } catch (e) {
            print('Error:${e.toString()}');
            per = 0.0;
          }
          btnTxt = data?.waitlistStatus == 'rejected'
              ? waitingCanceled
              : (data?.waitlistStatus == 'pending')
                  ? waitingCancel
                  : (data?.waitlistStatus == 'accepted')
                      ? 'waiting'
                      : waitingJoin;
        }
      } catch (e) {
        print('Error: $e');
        waiting = false;
      } finally {
        setState(() {});
      }
    });
  }

  Widget beforeU(String _title, String _icon, String _val) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              _title,
              style: TextStyle(fontSize: 16, fontFamily: 'Gilroy-Regular'),
            ),
          ],
        ),
        Row(
          children: [
            SvgPicture.asset(
              'assets/icon/$_icon.svg',
              height: sm.h(2),
              width: sm.w(2),
              fit: BoxFit.fill,
            ),
            Text(
              ' $_val',
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Gilroy-medium',
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }

  waitingTime() {
    print("data.waitlistStatus:${data.waitlistStatus}");
    var _wait = data?.minimumWaitTime ?? "00:33";

    return Column(
      children: [
        Text(
          'Waiting time',
          style: TextStyle(fontSize: 16, fontFamily: 'Gilroy-Regular'),
        ),
        (waiting && data.waitlistStatus == 'accepted')
            ? CirculerProgress(minutTxt: '\t${_wait.split(':')[1]}', per: per)
            : Row(children: [
                SvgPicture.asset(
                  'assets/icon/clock.svg',
                  height: sm.h(7),
                  width: sm.w(4),
                  fit: BoxFit.fill,
                ),
                minut20(myMinut: '\t${_wait.split(':')[1]}')
              ]),
      ],
    );
  }

  void abc() {
    t = Timer.periodic(new Duration(seconds: 10), (timer) {
      getWaitList(false);
    });
  }
}
