import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/component/myCarousel.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/AddressListModel.dart';
import 'package:favorito_user/model/appModel/ProfileImageModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/home/hotAndNewBusiness.dart';
import 'package:favorito_user/ui/home/myClipRect.dart';
import 'package:favorito_user/ui/home/usernameAddress.dart';
import 'package:favorito_user/ui/search/SearchResult.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();

  List<String> image = ['pizza', 'table', 'callender', 'ala', 'bag', 'home'];
  List<String> imagName = [
    'Food',
    'Book A Table',
    'Book An\nAppoinent',
    'Doctor',
    'Jobs',
    'Freelancers'
  ];
}

class _HomeState extends State<Home> {
  String _selectedAddress = "selected Address";
  final List<String> imgList = [];
  var _mySearchEditTextController = TextEditingController();
  AddressListModel addressData;
  ProfileImageModel profileImage;
  SizeManager sm;
  ProgressDialog pr;
  @override
  void initState() {
    super.initState();
    getUserImage();
    getAddress();
    try {
      pr?.isShowing() ?? false ? pr?.hide() : "";
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Fetching Data, please wait');
    sm = SizeManager(context);
    return Scaffold(
      backgroundColor: myBackGround,
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(sm.w(4)),
            margin: EdgeInsets.only(top: sm.h(2)),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sm.w(2)),
                  child: myClipRect(profileImage: profileImage, sm: sm),
                ),
                usernameAddress(
                    addressData: addressData,
                    selectedAddress: _selectedAddress),
                Padding(
                  padding: EdgeInsets.only(right: sm.w(2), bottom: sm.w(4)),
                  child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/icon/image_scanner.svg',
                        height: sm.h(3),
                        fit: BoxFit.fill,
                      ),
                      onPressed: () {
                        getAddress();
                        getCarousel();
                      }),
                )
              ],
            ),
          ),
          Container(height: sm.h(30), child: myCarousel(dataList: imgList)),
          Padding(
            padding: EdgeInsets.only(left: sm.w(5), right: sm.w(5)),
            child: EditTextComponent(
              ctrl: _mySearchEditTextController,
              title: "Search",
              security: false,
              valid: true,
              prefixIcon: 'search',
              prefClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SearchResult(_mySearchEditTextController.text),
                  ),
                );
              },
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
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                          textAlign: TextAlign.center),
                    ),
                  ]),
              ],
            ),
          ),
          header(sm, "Hot & New Business"),
          HotAndNewBusiness(),
        ],
      ),
    );
  }

  Widget header(SizeManager sm, String title) {
    return Padding(
      padding: EdgeInsets.all(sm.w(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
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
        ],
      ),
    );
  }

  void getCarousel() async {
    pr?.show();
    await APIManager.carousel(context).then((value) {
      pr?.hide();
      if (value.status == 'success') {
        if (value.data.length > 0) imgList.clear();
        for (var _va in value.data) imgList.add(_va.photo);
        setState(() {});
      }
    });
  }

  void getAddress() async {
    pr?.show();
    await APIManager.getAddress(context).then((value) {
      pr?.hide();
      if (value.status == 'success') {
        addressData = value;
        for (Addresses temp in addressData.data.addresses) {
          if (temp.defaultAddress == 1) {
            _selectedAddress = temp.address;
            break;
          }
        }
      }
    });
  }

  void getUserImage() async {
    pr?.show();
    await APIManager.getUserImage(context).then((value) {
      pr?.hide();
      if (value.status == 'success') {
        profileImage = value;
        getCarousel();
      }
    });
  }
}
