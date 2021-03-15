import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/ui/profile/user/PersonalInfo/PersonalInfoProvider.dart';
import 'package:favorito_user/ui/profile/user/PersonalInfo/UserAddress.dart';
import 'package:favorito_user/ui/profile/user/PersonalInfo/UserAddressProvider.dart';
import 'package:favorito_user/ui/profile/user/ProfileDetail.dart';
import 'package:favorito_user/ui/profile/user/ProfileProvider.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/Prefs.dart';
import 'package:favorito_user/utils/RIKeys.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../utils/MyColors.dart';

class Profile extends StatelessWidget {
  ProfileProvider vaTrue;
  ProfileProvider vaFalse;
  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    vaTrue = Provider.of<ProfileProvider>(context, listen: true);
    vaFalse = Provider.of<ProfileProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
          key: RIKeys.josKeys5,
          backgroundColor: myBackGround,
          appBar: AppBar(
              toolbarHeight: sm.h(5),
              backgroundColor: myBackGround,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              title: Text("My Profile",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400))),
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
                    itemCount: vaFalse.menuTitleList.length,
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
          ])),
    );
  }

  Widget menuItems(SizeManager sm, int identifier) {
    return InkWell(
      onTap: () {
        print('das${vaFalse.menuTitleList[identifier]}eeee');
        switch (vaFalse.menuTitleList[identifier]) {
          case 'Logout':
            {
              Prefs().clear();
              Navigator.pop(RIKeys.josKeys5.currentContext);
              Navigator.of(RIKeys.josKeys5.currentContext).pushNamed('/login');
            }
            break;
          case 'Edit profile':
            {
              Navigator.of(RIKeys.josKeys5.currentContext)
                  .pushNamed('/personalInfo');
            }
            break;
          case 'Saved Addresses':
            {
              showModalBottomSheet<void>(
                  enableDrag: true,
                  isScrollControlled: true,
                  context: RIKeys.josKeys5.currentContext,
                  backgroundColor: Color.fromRGBO(255, 0, 0, 0),
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Container(
                          height: sm.h(95),
                          decoration: BoxDecoration(color: Colors.white),
                          child: UserAddress());
                    });
                  });
            }
            break;
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: sm.w(5), vertical: sm.h(.7)),
        child: Row(children: [
          SizedBox(
              width: 14,
              height: 16,
              child: SvgPicture.asset(
                'assets/icon/${vaTrue.menuIconList[identifier]}.svg',
                fit: BoxFit.fill,
              )),
          Padding(
            padding: EdgeInsets.only(left: sm.w(4)),
            child: Text('\t\t\t' + vaTrue.menuTitleList[identifier],
                style: TextStyle(
                  fontSize: 15,
                  letterSpacing: 0.40,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Gilroy-Regular',
                  color: myGrey,
                )),
          )
        ]),
      ),
    );
  }
}
