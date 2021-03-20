import 'package:favorito_user/component/CirculerProgress.dart';
import 'package:favorito_user/component/Minut20.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/ui/profile/business/BusinessProfileProvider.dart';
import 'package:favorito_user/ui/profile/business/waitlist/WaitListHeader.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/MyString.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Waitlist extends StatelessWidget {
  SizeManager sm;
  BusinessProfileProvider vaTrue;
  BusinessProfileProvider vaFalse;

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    vaTrue = Provider.of<BusinessProfileProvider>(context, listen: true);
    vaFalse = Provider.of<BusinessProfileProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
          backgroundColor: myBackGround,
          body: FutureBuilder<void>(
            future: vaTrue.waitlistVerbose(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: Text(loading));
              else {
                // try {
                // if (snapshot.data.data.isEmpty)
                //   return Center(child: Text(snapshot.data.message ?? ''));
                // } catch (e) {
                //   print('Error 1:${e.toString()}');
                // }
                // if (snapshot.data.data.length != 0) {
                //   var v = snapshot.data?.data[0];
                //   // if (data != v && !waiting) {
                //   data?.partiesBeforeYou = v?.partiesBeforeYou;
                //   data?.businessName = v?.businessName;
                //   data?.availableTimeSlots = v?.availableTimeSlots;
                //   data?.minimumWaitTime = v?.minimumWaitTime ?? '00:00:00';
                // }
                // }

                return Padding(
                  padding: EdgeInsets.all(sm.w(6)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WaitListHeader(
                        title: waitingList,
                        preFunction: () {
                          // getWaitList(true);
                          Navigator.pop(context);
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: sm.w(8), horizontal: sm.w(2.5)),
                        child: titlePart(
                            vaTrue.getWaitListData()?.businessName ?? ''),
                      ),
                      bodyPart(),
                      footer(context)
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
              beforeU(
                  'Availeble slot',
                  'wclock',
                  vaTrue.getWaitListData()?.availableTimeSlots
                      // ?.convert24to12()
                      ??
                      vaTrue.getWaitListData()?.bookedSlot),
              SizedBox(height: sm.h(6)),
              Visibility(
                  visible: vaTrue.waiting,
                  child: beforeU('# in Parties', 'admin',
                      vaTrue.getWaitListData()?.noOfPerson.toString())),
              Visibility(
                  visible: vaTrue.waiting, child: SizedBox(height: sm.h(6))),
              beforeU('Parties Before you', 'admin',
                  vaTrue.getWaitListData()?.partiesBeforeYou.toString()),
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
                    (!vaTrue.waiting
                        ? vaTrue.getWaitListData()?.partiesBeforeYou ?? 0
                        : (vaTrue.getWaitListData()?.partiesBeforeYou + 1));
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
                          image: AssetImage(
                              (vaTrue.getWaitListData()?.userId != null &&
                                      i ==
                                          vaTrue
                                              .getWaitListData()
                                              ?.partiesBeforeYou)
                                  ? "assets/icon/arrowRed.png"
                                  : ''),
                        )),
                        child: Text(
                          (i + 1).toString() ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            color: (vaTrue.getWaitListData()?.userId != null &&
                                    i ==
                                        vaTrue
                                            .getWaitListData()
                                            ?.partiesBeforeYou)
                                ? Colors.white
                                : myGrey,
                            fontFamily: 'Gilroy-Bold',
                          ),
                        ),
                      ),
                      Card(
                        color: (vaTrue.getWaitListData()?.userId != null &&
                                i == vaTrue.getWaitListData()?.partiesBeforeYou)
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
                            (vaTrue.getWaitListData()?.userId != null &&
                                    i ==
                                        vaTrue
                                            .getWaitListData()
                                            ?.partiesBeforeYou)
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
                Navigator.of(context).pushNamed('/joinWaitList',
                    arguments: vaTrue.getWaitListData());
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
                  child: Icon(
                    Icons.add_circle_outline,
                    color: myRed,
                  ),
                ),
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
                  ),
                )
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            launch("tel://${vaTrue.getWaitListData().contact}");
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
    ]);
  }

  waitingTime() {
    print("data.waitlistStatus:${vaTrue.getWaitListData()?.waitlistStatus}");
    var _wait = vaTrue.getWaitListData()?.minimumWaitTime ?? "00:33";

    return Column(
      children: [
        Text(
          'Waiting time',
          style: TextStyle(fontSize: 16, fontFamily: 'Gilroy-Regular'),
        ),
        (vaTrue.waiting &&
                vaTrue.getWaitListData()?.waitlistStatus == 'accepted')
            ? CirculerProgress(
                minutTxt: '\t${_wait.split(':')[1]}', per: vaTrue.per)
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
}
