import 'package:favorito_user/component/Following.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/Business/businessProfileModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/MyString.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../utils/Extentions.dart';

class BusinessProfile extends StatefulWidget {
  String businessId;
  BusinessProfile({this.businessId});
  @override
  _BusinessProfileState createState() => _BusinessProfileState();
}

class _BusinessProfileState extends State<BusinessProfile> {
  SizeManager sm;
  businessProfileModel data = businessProfileModel();
  var fut;
  @override
  void initState() {
    super.initState();
    fut = APIManager.baseUserProfileDetail({'business_id': widget.businessId});
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder<businessProfileModel>(
          future: fut,
          builder: (BuildContext context,
              AsyncSnapshot<businessProfileModel> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: Text(loading));
            else {
              if (data != snapshot.data) data = snapshot.data;
              return Stack(
                children: [
                  ListView(
                    children: [
                      headerPart(),
                      midLavel(),
                      followingAndFavorite(),
                      Padding(
                        padding: EdgeInsets.only(left: sm.w(4), top: sm.h(4)),
                        child: Text(
                            // data?.data[0]?.businessName ?? "",
                            'Restaurent And Banquet Hall',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: sm.w(4), top: sm.h(1)),
                        child: Text(
                            // data?.data[0]?.businessName ?? "",
                            'Pare point, Surat',
                            style: TextStyle(
                                color: myGrey,
                                fontSize: 16,
                                fontWeight: FontWeight.w400)),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(left: sm.w(4), top: sm.h(1)),
                            child: Text(
                                // data?.data[0]?.businessName ?? "",
                                'Open Now',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300)),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: sm.w(4), top: sm.h(1)),
                            child: Text(
                                // data?.data[0]?.businessName ?? "",
                                '11 am - 12 midnight(Todat)',
                                style: TextStyle(
                                    color: myGrey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300)),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: sm.w(4), top: sm.h(1)),
                        child: Text(
                            // data?.data[0]?.businessName ?? "",
                            'R R R R',
                            style: TextStyle(
                                color: myGrey,
                                fontSize: 16,
                                fontWeight: FontWeight.w300)),
                      ),
                      ServicCart()
                    ],
                  ),
                  Positioned(
                    top: sm.h(31),
                    left: sm.w(35),
                    right: sm.w(35),
                    child: CircleAvatar(
                      radius: sm.w(15),
                      backgroundColor: Colors.red,
                      child: CircleAvatar(
                        radius: sm.w(14.5),
                        backgroundImage: NetworkImage(data?.data[0]?.photo),
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        )).safe();
  }

  Widget headerPart() {
    return Stack(
      children: [
        Image.network(
          'https://via.placeholder.com/150',
          height: sm.h(38),
          width: sm.w(100),
          fit: BoxFit.fill,
        ),
        Container(
          color: Colors.black.withOpacity(.2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.navigate_before,
                  size: sm.w(12),
                  color: Colors.white,
                ),
              ),
              Expanded(child: Container()),
              Padding(
                padding: EdgeInsets.only(right: sm.w(2)),
                child: SvgPicture.asset('assets/icon/share.svg'),
              ),
            ],
          ),
        ),
        // Positioned(top: 200, child: Image.asset('assets/icon/logo.png')),
        Positioned(
          top: sm.h(33.5),
          right: sm.w(6),
          child: Container(
            width: sm.w(18),
            padding:
                EdgeInsets.symmetric(horizontal: sm.w(1), vertical: sm.w(2)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              color: myRed,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('4.5',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w900)),
                Icon(
                  Icons.star,
                  color: Colors.yellow,
                  size: sm.w(4),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget midLavel() {
    return Column(children: [
      Padding(
        padding: EdgeInsets.only(top: sm.h(9), left: sm.w(4)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Foodie Circles',
                style: TextStyle(fontSize: 28, fontFamily: 'Gilroy-Bold')),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Icon(
                FontAwesomeIcons.solidCheckCircle,
                color: Color(0xff2196f3),
              ),
            )
          ],
        ),
      ),
      Row(
        children: [],
      )
    ]);
  }

  followingAndFavorite() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: sm.w(8)),
        Following(
          clr: Colors.blue,
          txt: 'Following',
        ),
        Padding(
          padding: EdgeInsets.only(left: sm.w(4)),
          child: Icon(
            Icons.favorite_border,
            color: Color(0xffdd2626),
          ),
        )
      ],
    );
  }

  List<String> service = [
    'Call Now',
    'Chat',
    'Appointment',
    'Waitlist',
    'Catlog'
  ];
  ServicCart() {
    return Container(
      height: sm.w(21),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (int i = 0; i < service.length; i++)
            Container(
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
                        child: Icon(
                          Icons.call_outlined,
                          color: myRed,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Text(
                          service[i],
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                    ],
                  )),
            ),
        ],
      ),
    );
  }
}
