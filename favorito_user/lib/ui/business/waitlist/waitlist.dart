import 'package:favorito_user/component/CirculerProgress.dart';
import 'package:favorito_user/component/Minut20.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/ui/business/BusinessProfileProvider.dart';
import 'package:favorito_user/ui/business/waitlist/WaitListHeader.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/MyString.dart';
import 'package:favorito_user/utils/RIKeys.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Waitlist extends StatelessWidget {
  SizeManager sm;
  BusinessProfileProvider vaTrue;
  BusinessProfileProvider vaFalse;
  bool isFirst = true;
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    vaTrue = Provider.of<BusinessProfileProvider>(context, listen: true);
    vaFalse = Provider.of<BusinessProfileProvider>(context, listen: false);
    if (isFirst) {
      vaTrue.setWaitlistDone(false);
      isFirst = false;
    }
    print("noOfPerson:${vaTrue.getWaitListData()?.noOfPerson}");
    return WillPopScope(
      onWillPop: () {
        vaTrue.allClear();
        Navigator.pop(context);
      },
      child: SafeArea(
        child: Scaffold(
            key: RIKeys.josKeys18,
            backgroundColor: myBackGround,
            body: RefreshIndicator(
              onRefresh: () async {
                vaTrue.getWaitList();
              },
              child: vaTrue.getWaitlistDone()
                  ? Padding(
                      padding: EdgeInsets.all(sm.w(6)),
                      child: ListView(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WaitListHeader(
                                title: 'Waiting List',
                                preFunction: () => Navigator.pop(context)),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: sm.w(8), horizontal: sm.w(2.5)),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: sm.h(.4)),
                                            Text(currentWaitlistAt,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily:
                                                        'Gilroy-Regular')),
                                            Text(
                                                vaTrue
                                                        .getWaitListData()
                                                        ?.businessName ??
                                                    '',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'Gilroy-Bold')),
                                          ]),
                                      SvgPicture.asset(
                                          'assets/icon/cutlery.svg')
                                    ])),
                            bodyPart(),
                            footer(context)
                          ]))
                  : Center(
                      child: CircularProgressIndicator(
                          semanticsLabel: pleaseWait)),
            )),
      ),
    );
  }

  Widget bodyPart() {
    print("dddd${vaTrue.getWaitListData()?.partiesBeforeYou}");
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
          height: sm.h(60),
          width: sm.w(40),
          padding: EdgeInsets.only(left: sm.w(2)),
          child: ListView(
            children: [
              beforeU(
                  'Available slot',
                  'wclock',
                  vaTrue.getWaitListData()?.availableTimeSlots
                      // ?.convert24to12()
                      ??
                      vaTrue.getWaitListData()?.bookedSlot ??
                      '0'),
              SizedBox(height: sm.h(6)),
              Visibility(
                  visible: vaTrue.isWaiting,
                  child: beforeU('# in Parties', 'admin',
                      vaTrue.getWaitListData()?.noOfPerson?.toString() ?? '0')),
              Visibility(
                  visible: vaTrue.isWaiting, child: SizedBox(height: sm.h(6))),
              beforeU(
                  'Parties Before you',
                  'admin',
                  vaTrue.getWaitListData()?.partiesBeforeYou?.toString() ??
                      '0'),
              SizedBox(height: sm.h(6)),
              waitingTime(),
            ],
          )),
      Container(
        height: sm.h(60),
        width: sm.w(28),
        child: ListView(children: [
          for (int i = 0;
              i <
                  (vaTrue.getWaitListData()?.partiesBeforeYou ?? 0) +
                      (vaTrue.isWaiting ? 1 : 0);
              i++)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: sm.h(2.4),
                      width: sm.w(8),
                      padding: EdgeInsets.only(left: sm.w(1.2)),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage((vaTrue.isWaiting &&
                                i == vaTrue.getWaitListData()?.partiesBeforeYou)
                            ? "assets/icon/arrowRed.png"
                            : ''),
                      )),
                      child: Text(
                        (i + 1).toString(),
                        style: TextStyle(
                            fontSize: 16,
                            color: (vaTrue.isWaiting &&
                                    i ==
                                        vaTrue
                                            .getWaitListData()
                                            ?.partiesBeforeYou)
                                ? Colors.white
                                : myGrey,
                            fontFamily: 'Gilroy-Bold'),
                      ),
                    ),
                    Card(
                      color: (vaTrue.isWaiting &&
                              i == vaTrue.getWaitListData()?.partiesBeforeYou)
                          ? myRed
                          : myBackGround2,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 22),
                        child: SvgPicture.asset(
                            (vaTrue.isWaiting &&
                                    i ==
                                        vaTrue
                                            .getWaitListData()
                                            ?.partiesBeforeYou)
                                ? 'assets/icon/menWhite.svg'
                                : 'assets/icon/menBlack.svg',
                            height: sm.h(6),
                            fit: BoxFit.fill),
                      ),
                    )
                  ]),
            )
        ]),
      ),
    ]);
  }

  Widget footer(context) {
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
                  if (vaTrue.btnTxt == waitingJoin) {
                    // widget?.data?.fun1 = getWaitList;
                    vaTrue.joinWaitlistClear();
                    Navigator.of(context)
                        .pushNamed('/joinWaitList',
                            arguments: vaTrue.getWaitListData())
                        .whenComplete(() {
                      vaTrue.getWaitList();
                    });
                  } else if (vaTrue.btnTxt == waitingCancel) {
                    vaTrue.cancelWaitList();
                  } else if (vaTrue.btnTxt == waitingCancel) {}
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 12, top: 16, bottom: 16),
                          child: Icon(Icons.add_circle_outline, color: myRed)),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 12.0, right: 30, bottom: 16, top: 16),
                          child: Text(
                            vaTrue.btnTxt,
                            style: TextStyle(
                                color: Color(0xffdd2626),
                                fontSize: 18,
                                letterSpacing: 0.36,
                                fontFamily: 'Gilroy-Light'),
                          ))
                    ]))),
        InkWell(
          onTap: () {
            launch("tel://${vaTrue.getBusinessProfileData().phone}");
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

  Widget beforeU(String _title, String _icon, String _val) {
    return Column(children: [
      Row(children: [
        Text(
          _title,
          style: TextStyle(fontSize: 16, fontFamily: 'Gilroy-Regular'),
        ),
      ]),
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
    ]);
  }

  waitingTime() {
    print("data.waitlistStatus:${vaTrue.getWaitListData()?.waitlistStatus}");
    var _wait = vaTrue.getWaitListData()?.minimumWaitTime ?? "00";
    print("asd${vaTrue.getWaitListData()?.waitlistStatus}");
    return Column(
      children: [
        Text('Waiting time',
            style: TextStyle(fontSize: 16, fontFamily: 'Gilroy-Regular')),
        (vaTrue.isWaiting &&
                vaTrue.timerTime &&
                vaTrue.getWaitListData()?.waitlistStatus == 'accepted')
            ? CirculerProgress(
                minutTxt: _wait,
                v: vaTrue.per,
                waitTime: vaTrue.remainTime.toString())
            : Row(children: [
                SvgPicture.asset('assets/icon/clock.svg',
                    height: sm.h(7), width: sm.w(4), fit: BoxFit.fill),
                minut20(myMinut: _wait)
              ]),
      ],
    );
  }
}
