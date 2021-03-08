import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/ui/profile/user/ProfileDetail.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/Prefs.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

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

  List<Icon> menuIconList = [
    Icon(Icons.edit_outlined),
    Icon(Icons.star_outline),
    Icon(Icons.camera_outlined),
    Icon(Icons.check_circle_outline),
    Icon(Icons.favorite_outline_outlined),
    Icon(Icons.share_outlined),
    Icon(Icons.gps_fixed_outlined),
    Icon(Icons.add_shopping_cart_outlined),
    Icon(Icons.child_friendly_outlined),
    Icon(Icons.follow_the_signs_outlined),
    Icon(Icons.follow_the_signs_outlined),
    Icon(Icons.follow_the_signs_outlined),
    Icon(Icons.search_outlined),
    Icon(Icons.favorite_outline_outlined),
    Icon(Icons.block_outlined),
    Icon(Icons.text_format_sharp),
    Icon(Icons.privacy_tip_outlined),
    Icon(Icons.local_police_rounded),
    Icon(Icons.login_outlined),
    Icon(Icons.delete_forever_outlined),
    Icon(Icons.power_settings_new),
  ];
}

class _ProfileState extends State<Profile> {
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
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
          )),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: sm.w(5)),
            height: sm.h(20),
            width: sm.w(100),
            child: ListView(
              children: [
                Row(
                  children: [
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
                            "Jessica Saint",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text("9718594728",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: myGrey)),
                          Text("Surat, Gujrat",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: myGrey))
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: sm.h(2)),
                  child: Text(
                    "Business manager at Avadh group of companies and always open for collaborations",
                    style: TextStyle(
                      fontSize: 12,
                      color: myGrey,
                    ),
                  ),
                )
              ],
            ),
          ),
          Divider(height: 10, color: myGrey),
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
                        Divider(height: 10, color: myGrey),
                      ]);
              },
            ),
          )
        ],
      ),
    );
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
        padding: EdgeInsets.symmetric(horizontal: sm.w(5), vertical: sm.h(1)),
        child: Row(
          children: [
            widget.menuIconList[identifier],
            Padding(
              padding: EdgeInsets.only(left: sm.w(4)),
              child: Text(widget.menuTitleList[identifier],
                  style: TextStyle(
                    fontSize: 16,
                    color: myGrey,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
