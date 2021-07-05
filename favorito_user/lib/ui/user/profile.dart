import 'package:favorito_user/Providers/BaseProvider.dart';
import 'package:favorito_user/component/ImageMaster.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/chat/ChatProvider.dart';
import 'package:favorito_user/ui/user/PersonalInfo/PersonalInfoProvider.dart';
import 'package:favorito_user/ui/user/PersonalInfo/UserAddressProvider.dart';
import 'package:favorito_user/ui/user/ProfileDetail.dart';
import 'package:favorito_user/ui/user/ProfileProvider.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/Prefs.dart';
import 'package:favorito_user/utils/RIKeys.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../utils/MyColors.dart';

class Profile extends StatelessWidget {
  BaseProvider vaTrue;

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    vaTrue = Provider.of<BaseProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () => APIManager.onWillPop(context),
      child: SafeArea(
        child: Scaffold(
            key: RIKeys.josKeys5,
            appBar: AppBar(
                toolbarHeight: sm.h(5),
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false,
                title: Text("My Profile",
                    style: Theme.of(context).textTheme.headline6.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: .4,
                        fontSize: 20))),
            body: ListView(children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: sm.w(5)),
                height: sm.h(18),
                width: sm.w(100),
                child: ListView(children: [
                  Row(children: [
                    InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileMaster())),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                              height: sm.h(10),
                              width: sm.h(10),
                              child: ImageMaster(
                                  url: Provider.of<UserAddressProvider>(context,
                                          listen: true)
                                      .getProfileImage()))),
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
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
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
                          ]),
                    )
                  ]),
                  Padding(
                    padding: EdgeInsets.only(top: sm.h(2)),
                    child: Text(
                        Provider.of<PersonalInfoProvider>(context, listen: true)
                                .profileModel
                                ?.data
                                ?.detail
                                ?.shortDescription ??
                            '',
                        style: Theme.of(context).textTheme.headline3.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.28,
                            color: myGrey)),
                  )
                ]),
              ),
              Divider(
                  height: 10,
                  color: Colors.grey.shade300,
                  endIndent: sm.w(5),
                  indent: sm.w(5)),
              Container(
                  height: sm.h(60),
                  child: ListView.builder(
                      itemCount: vaTrue.menuTitleList.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        List<int> _ls = [7, 14, 17];
                        return !_ls.contains(index)
                            ? menuItems(sm, index, context)
                            : Column(children: [
                                menuItems(sm, index, context),
                                Divider(
                                    height: 10,
                                    color: Colors.grey.shade300,
                                    endIndent: sm.w(5),
                                    indent: sm.w(5))
                              ]);
                      }))
            ])),
      ),
    );
  }

  Widget menuItems(SizeManager sm, int identifier, BuildContext context) {
    return InkWell(
      onTap: () {
        print('das${vaTrue.menuTitleList[identifier]}eeee');
        switch (vaTrue.menuTitleList[identifier]) {
          case 'Logout':
            {
              try {
                context.read<ChatProvider>().preferences.clear();
                Provider.of<UserAddressProvider>(context, listen: false)
                    .allClear();
                    
              } catch (e) {} finally {
                Prefs().clear();
              }
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/login');
            }
            break;
          case 'Edit profile':
            Navigator.of(RIKeys.josKeys5.currentContext)
                .pushNamed('/personalInfo');
            break;

          case 'Saved Addresses':
            Navigator.of(RIKeys.josKeys5.currentContext)
                .pushNamed('/userAddress');
            break;

          case 'Orders':
            Navigator.of(RIKeys.josKeys5.currentContext)
                .pushNamed('/orderHome');
            break;

          case 'Change login details':
            Navigator.of(context).pushNamed('/loginDetail');
            break;

          case 'Following':
            {
              Provider.of<ProfileProvider>(context, listen: false).dataWill(1);
              Navigator.of(context).pushNamed('/followingUser');
              break;
            }
          case 'Following Business':
            {
              Provider.of<ProfileProvider>(context, listen: false).dataWill(2);
              Navigator.of(context).pushNamed('/followingUser');
              break;
            }
          case 'Followers':
            {
              Provider.of<ProfileProvider>(context, listen: false).dataWill(-3);
              Navigator.of(context).pushNamed('/followingUser');
              break;
            }
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
                  fit: BoxFit.fill)),
          Padding(
            padding: EdgeInsets.only(left: sm.w(4)),
            child: Text('\t\t\t' + vaTrue.menuTitleList[identifier],
                style: TextStyle(
                    fontSize: 15,
                    letterSpacing: 0.40,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Gilroy-Regular',
                    color: myGrey)),
          )
        ]),
      ),
    );
  }
}
