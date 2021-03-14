import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/ui/profile/user/PersonalInfo/PersonalInfoProvider.dart';
import 'package:favorito_user/ui/profile/user/PersonalInfo/UserAddressProvider.dart';
import 'package:favorito_user/ui/profile/user/ProfileDetail.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/Prefs.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../utils/MyColors.dart';

class Profile extends StatefulWidget {
  _ProfileState createState() => _ProfileState();
  List<String> menuTitleList = [
    "Edit profile",
    "Reviews",
    "Photos added with reviews",
    "Check-ins",
    "Favourites",
    "Refer fiend/place",
    "Saved Addresses",
    "Orders",
    "Friends",
    "Followers",
    "Following",
    "Following Business",
    "Find friend by name",
    "Liked posts",
    "Blocked users",
    "Terms of services",
    "Privacy policy",
    "Licenses",
    "Change login details",
    "Delete Acount",
    'Logout'
  ];
}

class _ProfileState extends State<Profile> {
  List menuIconList = [
    'edit',
    'star',
    'camera',
    'check',
    'favorite',
    'refer',
    'location',
    'bucket',
    'friend',
    'follow',
    'following',
    'shirt',
    'find',
    'heart',
    'block',
    'term',
    'privacy',
    'license',
    'changePass',
    'delete',
    'delete'
  ];
  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
        backgroundColor: myBackGround,
        appBar: AppBar(
            toolbarHeight: sm.h(5),
            backgroundColor: myBackGround,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              "My Profile",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
            )),
        body: ListView(children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: sm.w(5)),
            height: sm.h(20),
            width: sm.w(100),
            child: ListView(
              children: [
                Row(children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileDetail()));
                    },
                    child: Container(
                        width: sm.w(25),
                        height: sm.w(25),
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(
                                    "https://source.unsplash.com/1NiNq7S4-AA/40*40")))),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: sm.w(2)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            Provider.of<PersonalInfoProvider>(context,
                                    listen: true)
                                .username,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Gilroy-Bold')),
                        Text(
                            Provider.of<PersonalInfoProvider>(context,
                                    listen: true)
                                .phone,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: myGrey)),
                        Text(
                            "${Provider.of<UserAddressProvider>(context, listen: true).city},${Provider.of<UserAddressProvider>(context, listen: true).state}",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: myGrey))
                      ],
                    ),
                  )
                ]),
                Padding(
                  padding: EdgeInsets.only(top: sm.h(2)),
                  child: Text(
                    "Business manager at Avadh group of companies and always open for collaborations",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Gilroy-Regular',
                      letterSpacing: 0.28,
                      color: myGrey,
                    ),
                  ),
                )
              ],
            ),
          ),
          Divider(
              height: 10,
              color: Colors.grey.shade300,
              endIndent: sm.w(5),
              indent: sm.w(5)),
          Container(
              height: sm.h(60),
              child: ListView.builder(
                  itemCount: widget.menuTitleList.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    List<int> _ls = [7, 14, 17];
                    return !_ls.contains(index)
                        ? menuItems(sm, index)
                        : Column(children: [
                            menuItems(sm, index),
                            Divider(
                                height: 10,
                                color: Colors.grey.shade300,
                                endIndent: sm.w(5),
                                indent: sm.w(5))
                          ]);
                  }))
        ]));
  }

  Widget menuItems(SizeManager sm, int identifier) {
    return InkWell(
      onTap: () {
        print('das${widget.menuTitleList[identifier]}');
        switch (widget.menuTitleList[identifier]) {
          case 'Logout':
            {
              Prefs().clear();
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/login');
            }
            break;
          case 'Edit profile':
            {
              Navigator.of(context).pushNamed('/personalInfo');
            }
            break;
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: sm.w(5), vertical: sm.h(.7)),
        child: Row(
          children: [
            SizedBox(
                width: 14,
                height: 13,
                child: SvgPicture.asset(
                  'assets/icon/${menuIconList[identifier]}.svg',
                  fit: BoxFit.fill,
                )),
            Padding(
              padding: EdgeInsets.only(left: sm.w(4)),
              child: Text('\t\t\t' + widget.menuTitleList[identifier],
                  style: TextStyle(
                    fontSize: 15,
                    letterSpacing: 0.40,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Gilroy-Regular',
                    color: myGrey,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
