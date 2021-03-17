import 'package:favorito_user/Providers/BookTableProvider.dart';
import 'package:favorito_user/Providers/MenuHomeProvider.dart';
import 'package:favorito_user/component/FollowBtn.dart';
import 'package:favorito_user/component/ImageMaster.dart';
import 'package:favorito_user/component/favoriteBtn.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/WorkingHoursModel.dart';
import 'package:favorito_user/model/appModel/BookingOrAppointment/BookingOrAppointmentDataModel.dart';
import 'package:favorito_user/model/appModel/Business/businessProfileModel.dart';
import 'package:favorito_user/model/appModel/WaitList/WaitListDataModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/profile/business/BusinessProfileProvider.dart';
import 'package:favorito_user/ui/profile/business/tabs/tabber.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/MyString.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/Extentions.dart';
import '../../../utils/RIKeys.dart';

class BusinessProfile extends StatefulWidget {
  String businessId;
  BusinessProfile({this.businessId});
  List<String> attribute = [];
  List<String> service = [];
  @override
  _BusinessProfileState createState() => _BusinessProfileState();
}

class _BusinessProfileState extends State<BusinessProfile> {
  SizeManager sm;
  businessProfileModel data = businessProfileModel();
  BusinessProfileProvider vatrue;
  bool isFirst = true;
  var fut;
  @override
  void initState() {
    super.initState();
    fut = APIManager.baseUserProfileDetail(
        {'business_id': widget.businessId}, RIKeys.josKeys2);
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    Provider.of<AppBookProvider>(context, listen: false)
        .setBusinessId(widget.businessId);
    vatrue = Provider.of<BusinessProfileProvider>(context, listen: true);
    if (isFirst) {
      vatrue.setId(widget.businessId);
      isFirst = false;
    }
    return Scaffold(
        key: RIKeys.josKeys2,
        backgroundColor: Colors.white,
        body: FutureBuilder<businessProfileModel>(
          future: fut,
          builder: (BuildContext context,
              AsyncSnapshot<businessProfileModel> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: Text(loading));
            if (snapshot.hasError)
              return Center(child: Text('Something went wrong..'));
            else {
              if (data != snapshot?.data) data = snapshot.data ?? '';
              widget.attribute.clear();
              widget.attribute
                  .addAll(data.data[0].attributes.map((e) => e.attributeName));

              Provider.of<BusinessProfileProvider>(context, listen: false);
              return ListView(children: [
                Stack(children: [
                  Column(children: [
                    headerPart(),
                    Stack(children: [
                      Padding(
                        padding: EdgeInsets.only(top: sm.h(8), bottom: sm.h(1)),
                        child: Center(
                          child: Text(data?.data[0]?.businessName ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  letterSpacing: -.5,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Gilroy-Bold')),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: sm.h(0), left: sm.w(75.8)),
                        child: Container(
                          width: sm.w(18.4),
                          padding: EdgeInsets.symmetric(
                              horizontal: sm.w(1), vertical: sm.w(0)),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8)),
                              color: Colors.white),
                          child: Center(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              direction: Axis.vertical,
                              spacing: 0,
                              children: [
                                Center(
                                  child: Text(
                                      '${data?.data[0]?.totalReviews ?? 0}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Gilroy-Reguler')),
                                ),
                                Text(
                                  'Reviews',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: myGrey,
                                    fontFamily: 'Gilroy-Reguler',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ]),
                  ]),
                  smallProfile(),
                ]),
                followingAndFavorite(),
                Padding(
                  padding: EdgeInsets.only(left: sm.w(4), top: sm.h(4)),
                  child: Text(data?.data[0]?.shortDesciption ?? "",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                ),
                Padding(
                    padding: EdgeInsets.only(left: sm.w(4), top: sm.h(1)),
                    child: InkWell(
                        onTap: () {
                          vatrue.getBusinessHours();
                        },
                        child: Text(
                            '${data?.data[0]?.townCity ?? ""}, ${data?.data[0]?.state ?? ""}',
                            style: TextStyle(
                                color: myGrey,
                                fontSize: 16,
                                fontWeight: FontWeight.w400)))),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: sm.w(4), top: sm.h(1)),
                      child: Text(data?.data[0]?.businessStatus ?? "",
                          style: TextStyle(
                              color: data?.data[0]?.businessStatus == 'Offline'
                                  ? myRed
                                  : Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.w300)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: sm.w(4), top: sm.h(1)),
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet<void>(
                              enableDrag: true,
                              isScrollControlled: true,
                              context: context,
                              backgroundColor: Color.fromRGBO(255, 0, 0, 0),
                              builder: (BuildContext context) {
                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setState) {
                                  return Container(
                                      height: sm.h(70),
                                      decoration:
                                          BoxDecoration(color: Colors.white),
                                      child: HoursList(vatrue, sm));
                                });
                              });
                        },
                        child: Text(vatrue.getShopTime(),
                            style: TextStyle(
                                color: myGrey,
                                fontSize: 16,
                                fontWeight: FontWeight.w300)),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: sm.w(4), top: sm.h(1)),
                  child: Text("\u{20B9} : " + data?.data[0]?.priceRange ?? "",
                      style: TextStyle(
                          color: myGrey,
                          fontSize: 16,
                          fontWeight: FontWeight.w300)),
                ),
                ServicCart(),
                Container(height: sm.h(70), child: Tabber(data: data.data[0]))
              ]);
            }
          },
        )).safe();
  }

  Widget smallProfile() {
    return Positioned(
      top: sm.h(30),
      left: sm.w(34),
      right: sm.w(35),
      child: CircleAvatar(
        radius: sm.w(15),
        backgroundColor: Colors.red,
        child: CircleAvatar(
          radius: sm.w(2) * sm.w(2.05),
          backgroundImage: NetworkImage(data?.data[0]?.photo),
          backgroundColor: Colors.red,
        ),
      ),
    );
  }

  Widget headerPart() => Stack(
        children: [
          Container(
              height: sm.h(38),
              width: sm.w(100),
              child: ImageMaster(url: data?.data[0]?.photo)),
          Container(
            color: Colors.black.withOpacity(0.2),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.navigate_before,
                          size: sm.w(12), color: Colors.white)),
                  Expanded(child: Container()),
                  Padding(
                      padding: EdgeInsets.only(right: sm.w(2)),
                      child: SvgPicture.asset('assets/icon/share.svg')),
                ]),
          ),
          Positioned(
            bottom: 0,
            right: sm.w(6),
            child: Container(
              width: sm.w(18),
              padding:
                  EdgeInsets.symmetric(horizontal: sm.w(1), vertical: sm.w(2)),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                  color: myRed),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 2.0),
                    child: Text(
                        double.parse(
                                '${data?.data[0].avgRating.toStringAsFixed(1) ?? 0} ')
                            .toString(),
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Gilroy-Regular',
                            color: Colors.white,
                            fontWeight: FontWeight.w900)),
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: sm.w(4.5),
                  )
                ],
              ),
            ),
          ),
        ],
      );

  followingAndFavorite() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: sm.w(12)),
        FollowBtn(id: data.data[0].businessId),
        FavoriteBtn(id: data.data[0].businessId),
      ],
    );
  }

  ServicCart() {
    BookingOrAppointmentDataModel badm = BookingOrAppointmentDataModel();
    List<String> service = [
      'Call Now',
      'Chat',
      // (widget.attribute.contains('Booking')
      //     ? 'Booking'
      //     : (widget.attribute.contains('Appointment'))
      //         ? 'Appointment'
      //         : null),
      // (widget.attribute.contains('Waitlist') ? 'Waitlist' : null),
    ];
    service.addAll(widget.attribute);
    List<IconData> serviceIcons = [
      Icons.call_outlined,
      FontAwesomeIcons.comment,
      Icons.calendar_today,
      Icons.alarm,
      Icons.call_outlined,
      FontAwesomeIcons.comment,
      Icons.calendar_today,
      Icons.alarm
    ];
    for (int i = 0; i < service.length; i++) service.remove(null);
    return Container(
      height: sm.w(21),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (int i = 0; i < service.length; i++)
            InkWell(
              onTap: () {
                String _v = service[i];

                switch (_v) {
                  case 'Call Now':
                    launch("tel://${data.data[0].phone}");
                    break;

                  case 'Chat':
                    {}
                    break;
                  case 'Booking':
                    {
                      badm.businessId = data.data[0].businessId;
                      badm.isBooking = 0;
                      Navigator.of(context).pushNamed(
                          '/bookingOrAppointmentList',
                          arguments: badm);
                    }
                    break;
                  case 'Appointment':
                    {
                      Provider.of<AppBookProvider>(context, listen: false)
                          .setIsBooking(1);
                      Navigator.of(context).pushNamed(
                          '/bookingOrAppointmentList',
                          arguments: badm);
                    }
                    break;
                  case 'Waitlist':
                    {
                      WaitListDataModel wdm = WaitListDataModel();
                      wdm.businessId = data.data[0].businessId;
                      wdm.contact = data.data[0].phone;
                      Navigator.of(context)
                          .pushNamed('/waitlist', arguments: wdm);
                    }
                    break;
                  case 'Online Menu':
                    {
                      Provider.of<MenuHomeProvider>(context, listen: false)
                          .setBusinessIdName(data.data[0].businessId,
                              data.data[0].businessName);
                      Navigator.of(context).pushNamed('/menuHome');
                    }
                }
              },
              child: Container(
                width: sm.w(28),
                padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                child: Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(serviceIcons[i], color: myRed),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Text(service[i] ?? "",
                              style: TextStyle(fontSize: 12)),
                        )
                      ],
                    )),
              ),
            ),
        ],
      ),
    );
  }

  HoursList(BusinessProfileProvider vaTrue, SizeManager sm) {
    List<WorkingHoursData> businessProfileProvider =
        vaTrue.getWorkingHoursList();
    return Container(
      height: sm.h(70),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                    width: sm.w(20),
                    child: Text('Day',
                        style: TextStyle(fontFamily: 'Gilroy-Bold'))),
                SizedBox(
                    width: sm.w(20),
                    child: Text('StartTime',
                        style: TextStyle(fontFamily: 'Gilroy-Bold'))),
                SizedBox(
                    width: sm.w(20),
                    child: Text('EndTime',
                        style: TextStyle(fontFamily: 'Gilroy-Bold'))),
              ],
            ),
          ),
          Container(
            height: sm.h(64),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: businessProfileProvider?.length ?? 0,
                itemBuilder: (context, index) {
                  var v = businessProfileProvider[index];
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: sm.w(20),
                          child: Text(v.day,
                              textAlign: TextAlign.start,
                              style: TextStyle(fontFamily: 'Gilroy-Regular')),
                        ),
                        SizedBox(
                          width: sm.w(20),
                          child: Text(v.startHours.trim().substring(0, 5),
                              textAlign: TextAlign.start,
                              style: TextStyle(fontFamily: 'Gilroy-Regular')),
                        ),
                        SizedBox(
                          width: sm.w(20),
                          child: Text(v.endHours.substring(0, 5).trim(),
                              textAlign: TextAlign.start,
                              style: TextStyle(fontFamily: 'Gilroy-Regular')),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
