import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/component/myCarousel.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/ui/home/hotAndNewBusiness.dart';
import 'package:favorito_user/ui/home/myClipRect.dart';
import 'package:favorito_user/ui/profile/user/PersonalInfo/PersonalInfoProvider.dart';
import 'package:favorito_user/ui/profile/user/PersonalInfo/UserAddress.dart';
import 'package:favorito_user/ui/search/SearchReqData.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/RIKeys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:favorito_user/ui/profile/user/PersonalInfo/UserAddressProvider.dart';

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();

  ProgressDialog pr;
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
  var _mySearchEditTextController = TextEditingController();
  // AddressListModel addressData = AddressListModel();
  SizeManager sm;
  UserAddressProvider vaTrue;

  @override
  Widget build(BuildContext context) {
    vaTrue = Provider.of<UserAddressProvider>(context, listen: true);
    if (widget.pr == null) {
      // vaTrue.getAddress();
      vaTrue.getUserImage();
    }
    widget.pr = ProgressDialog(context, type: ProgressDialogType.Normal);
    widget.pr.style(message: 'Fetching Data, please wait');
    sm = SizeManager(context);

    return Scaffold(
      key: RIKeys.josKeys3,
      backgroundColor: myBackGround,
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(sm.w(4)),
            margin: EdgeInsets.only(top: sm.h(2)),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: sm.w(20),
                    padding: EdgeInsets.symmetric(horizontal: sm.w(2)),
                    child: myClipRect()),
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
                                decoration: BoxDecoration(color: Colors.white),
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
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Gilroy-Bold'),
                          ),
                          Text(data?.getSelectedAddress(),
                              textAlign: TextAlign.start)
                        ]);
                  })),
                ),
                Container(
                  width: sm.w(12),
                  padding: EdgeInsets.only(right: sm.w(2), bottom: sm.w(4)),
                  child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/icon/image_scanner.svg',
                        height: sm.h(3),
                        fit: BoxFit.fill,
                      ),
                      onPressed: () {}),
                )
              ],
            ),
          ),
          Container(height: sm.h(30), child: myCarousel()),
          Padding(
            padding: EdgeInsets.only(left: sm.w(5), right: sm.w(5)),
            child: EditTextComponent(
              ctrl: _mySearchEditTextController,
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
              prefClick: () {
                Navigator.of(context).pushNamed('/searchResult',
                    arguments:
                        SearchReqData(text: _mySearchEditTextController.text));
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
                                textAlign: TextAlign.center),
                          ),
                        ]),
                  ),
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
}
