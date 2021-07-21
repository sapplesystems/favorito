import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/component/ImageMaster.dart';
import 'package:favorito_user/component/myCarousel.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/ClusterMap/ClusterMap.dart';
import 'package:favorito_user/ui/home/hotAndNewBusiness.dart';
import 'package:favorito_user/ui/search/SearchReqData.dart';
import 'package:favorito_user/ui/user/PersonalInfo/PersonalInfoProvider.dart';
import 'package:favorito_user/ui/user/PersonalInfo/UserAddress.dart';
import 'package:favorito_user/ui/user/PersonalInfo/UserAddressProvider.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/RIKeys.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();

  List<String> image = ['pizza', 'table', 'callender', 'ala', 'bag', 'home'];
  List<String> imagName = [
    'Food',
    'Book A Table',
    'Book An\nAppointment',
    'Doctor',
    'Jobs',
    'Freelancers'
  ];
}

class _HomeState extends State<Home> {
   String messageTitle = "Empty";
String notificationAlert = "alert";

FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  var _mySearchEditTextController = TextEditingController();
  SizeManager sm;
  UserAddressProvider vaTrue;
  bool isFirst = true;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.getToken().then((value) {
      print("this is new Token:${value}");
    });

    _firebaseMessaging.configure(
      onMessage: (message) async {
        setState(() {
          messageTitle = message["notification"]["title"];
          messageTitle = message["data"]["message"];
          print("messageTitle:$messageTitle");
          notificationAlert = "New Notification Alert";
        });
      },
      onResume: (message) async {
        setState(() {
          messageTitle = message["data"]["title"];
          print("messageTitle1:$messageTitle");
          notificationAlert = "Application opened from Notification";
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    vaTrue = Provider.of<UserAddressProvider>(context, listen: true);
    if (isFirst == true) {
      vaTrue
      ..getAddress()
      ..getUserImage()
      ..getFirabaseId();
      
      Provider.of<PersonalInfoProvider>(context, listen: true)
          .getPersonalData();
      isFirst = false;
    }
    sm = SizeManager(context);
    return WillPopScope(
      onWillPop: () => APIManager.onWillPop(context),
      child: Scaffold(
        key: RIKeys.josKeys24,
        body: ListView(children: [
          Container(
            padding: EdgeInsets.all(sm.w(4)),
            margin: EdgeInsets.only(top: sm.h(2)),
            // color: Colors.white,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Provider.of<UserAddressProvider>(context, listen: false)
                          .getImage(ImgSource.Gallery, RIKeys.josKeys24);
                    },
                    child: Container(
                      width: sm.w(20),
                      padding: EdgeInsets.symmetric(horizontal: sm.w(2)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                              height: sm.h(8),
                              width: sm.h(8),
                              child: ImageMaster(
                                  url:context.watch<UserAddressProvider>()
                                      .getProfileImage()))),
                    ),
                  ),
                  Container(
                    width: sm.w(60),
                    child: InkWell(onTap: () {
                      showModalBottomSheet<void>(
                          enableDrag: true,
                          isScrollControlled: true,
                          context: context,
                          backgroundColor: Color.fromRGBO(255, 0, 0, 0),
                          builder: (BuildContext context) {
                            return StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return Container(
                                  height: sm.h(70),
                                  // decoration:
                                  //     BoxDecoration(color: Colors.white),
                                  child: UserAddress());
                            });
                          });
                    }, child: Consumer<UserAddressProvider>(
                        builder: (context, data, child) {
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Provider.of<PersonalInfoProvider>(context,
                                      listen: true)
                                  .username,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(fontSize: 16),
                            ),
                            Text(
                              "${data?.getSelectedAddress()}  ${(data?.getSelectedAddress()?.length ?? 0) > 1 ? '\u{25bc}' : ''}",
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(fontSize: 10),
                            ),
                            Text(
                              'v2.3',
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(fontSize: 8),
                            )
                          ]);
                    })),
                  ),
                  Container(
                    width: sm.w(12),
                    alignment: Alignment.center,
                    child: IconButton(
                        icon: SvgPicture.asset(
                          'assets/icon/image_scanner.svg',
                          height: sm.h(3),
                          fit: BoxFit.fill,
                        ),
                        onPressed: () {
                          vaTrue.scanQR(context);
                        }),
                  )
                ]),
          ),
          Container(height: sm.h(30), child: myCarousel()),
          Padding(
            padding: EdgeInsets.only(left: sm.w(5), right: sm.w(5)),
            child: EditTextComponent(
              controller: _mySearchEditTextController,
              hint: "Search",
              suffixTxt: '',
              security: false,
              valid: false,
              error: '',
              keyboardSet: TextInputType.text,
              prefixIcon: 'search',
              keyBoardAction: TextInputAction.search,
              atSubmit: (_val) {
                Navigator.of(context).pushNamed('/searchResult',
                    arguments: SearchReqData(text: _val));
              },
              prefClick: () => Navigator.of(context).pushNamed('/searchResult',
                  arguments:
                      SearchReqData(text: _mySearchEditTextController.text)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(sm.w(4)),
            child: Wrap(
              runSpacing: sm.h(5),
              spacing: sm.h(5),
              alignment: WrapAlignment.center,
              children: [
                for (var i = 0; i < widget.imagName.length; i++)
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/searchResult',
                          arguments:
                              SearchReqData(category: widget.imagName[i]));
                    },
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Neumorphic(
                              style: NeumorphicStyle(
                                  shape: NeumorphicShape.convex,
                                  depth: 8,
                                  lightSource: LightSource.topLeft,
                                  color: myButtonBackground,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.all(Radius.circular(12.0)),
                                  )),
                              child: Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(sm.h(3.5)),
                                child: SvgPicture.asset(
                                  'assets/icon/${widget.image[i]}.svg',
                                  height: sm.h(3.5),
                                ),
                              )),
                          Padding(
                            padding: EdgeInsets.only(top: sm.h(2.5)),
                            child: Text(widget.imagName[i].toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center),
                          ),
                        ]),
                  ),
              ],
            ),
          ),
          header(sm, "Hot & New Business"),
          HotAndNewBusiness(),
        ]),
      ),
    );
  }

  Widget header(SizeManager sm, String title) {
    return Padding(
      padding: EdgeInsets.all(sm.w(5)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 16),
        ),
        InkWell(
          onTap: () {
            setState(() {});
          },
          child: Text(
            "View all",
            style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey),
          ),
        )
      ]),
    );
  }
}
