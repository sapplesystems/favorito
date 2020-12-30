import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/WaitList/WaitListBaseModel.dart';
import 'package:favorito_user/model/appModel/WaitList/WaitListDataModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/profile/business/waitlist/WaitListHeader.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/MyString.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class Waitlist extends StatefulWidget {
  WaitListDataModel data;
  Waitlist({this.data});
  @override
  _WaitlistState createState() => _WaitlistState();
}

class _WaitlistState extends State<Waitlist> {
  SizeManager sm;
  WaitListBaseModel data = WaitListBaseModel();
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return SafeArea(
      child: Scaffold(
          backgroundColor: myBackGround,
          body: FutureBuilder<WaitListBaseModel>(
            future: APIManager.baseUserWaitlistVerbose(
                {'business_id': widget.data.businessId}),
            builder: (BuildContext context,
                AsyncSnapshot<WaitListBaseModel> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: Text(loading));
              else {
                if (data != snapshot.data) data = snapshot.data;
                return Padding(
                  padding: EdgeInsets.all(sm.w(6)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WaitListHeader(title: waitingList),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: sm.w(8), horizontal: sm.w(2.5)),
                        child: titlePart(data.data[0].businessName),
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

  Widget bodyPart() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: sm.h(60),
            width: sm.w(40),
            padding: EdgeInsets.only(left: sm.w(2)),
            child: ListView(
              children: [
                Text(
                  'Availeble slot',
                  style: TextStyle(
                      fontSize: 14,
                      color: myGrey,
                      fontFamily: 'Gilroy-Reguler'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.alarm,
                      color: myGreyLight,
                      size: 14,
                    ),
                    Text(
                      data.data[0].availableTimeSlots,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Gilroy-medium',
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: sm.w(14),
                    )
                  ],
                ),
                SizedBox(height: sm.h(6)),
                Text(
                  'Parties Before you',
                  style: TextStyle(fontSize: 16, fontFamily: 'Gilroy-Regular'),
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icon/admin.svg',
                      height: sm.h(2),
                      width: sm.w(2),
                      fit: BoxFit.fill,
                    ),
                    Text(
                      ' 6 ',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Gilroy-medium',
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height: sm.h(6)),
                Text(
                  'Waiting time',
                  style: TextStyle(fontSize: 16, fontFamily: 'Gilroy-Regular'),
                ),
                Row(children: [
                  SvgPicture.asset(
                    'assets/icon/clock.svg',
                    height: sm.h(7),
                    width: sm.w(4),
                    fit: BoxFit.fill,
                  ),
                  Wrap(
                    spacing: -10,
                    runSpacing: 20,
                    direction: Axis.vertical,
                    children: [
                      Text(
                        ' 20',
                        style: TextStyle(
                          fontSize: 50,
                          fontFamily: 'Gilroy-Reguler',
                        ),
                      ),
                      Text(
                        '\t\tMinutes',
                        style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 1,
                          fontFamily: 'Gilroy-Bold',
                        ),
                      ),
                    ],
                  )
                ]),
              ],
            ),
          ),
          Container(
            height: sm.h(60),
            width: sm.w(28),
            child: ListView(
              children: [
                for (int i = 0; i < 14; i++)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          (i + 1).toString(),
                          style: TextStyle(
                            fontSize: 20,
                            color: myGrey,
                            fontFamily: 'Gilroy-Bold',
                          ),
                        ),
                        Card(
                          color: myBackGround2,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 22),
                            child: SvgPicture.asset(
                              'assets/icon/men.svg',
                              height: sm.h(6),
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
              ],
            ),
          ),
        ],
      );
  titlePart(String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            SizedBox(
              height: sm.h(.4),
            ),
            Text(
              currentWaitlistAt,
              style: TextStyle(fontSize: 16, fontFamily: 'Gilroy-Regular'),
            ),
            Text(
              name,
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
              Navigator.of(context).pushNamed('/joinWaitList');
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
                  padding: const EdgeInsets.only(
                      left: 12.0, right: 30, bottom: 16, top: 16),
                  child: Text(
                    'Join waitlist',
                    style: TextStyle(
                      color: Color(0xffdd2626),
                      fontSize: 18,
                      letterSpacing: 0.36,
                      // fontSize: 22,
                      fontFamily: 'Gilroy-Light',
                      // color: myRed
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            launch("tel://${999999999}");
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
}
