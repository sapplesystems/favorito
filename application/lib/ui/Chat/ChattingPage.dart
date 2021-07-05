import 'package:Favorito/model/Chat/ConnectionData.dart';
import 'package:Favorito/model/Chat/User.dart';
import 'package:Favorito/ui/Chat/ChatScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:favorito_user/model/Chat/User.dart';
// import 'package:favorito_user/ui/Chat/ChatScreen.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import '../../utils/Extentions.dart';

class Chat extends StatelessWidget {
  ConnectionData userInfo;
  Chat({Key key, @required this.userInfo});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(userInfo, context),
      // AppBar(
      //   backgroundColor: Color(0xffF4F6FC),
      //   shadowColor: Colors.black54,
      //   elevation: 1,
      //   leading: InkWell(
      //       onTap: () => Navigator.pop(context),
      //       child: Icon(Icons.arrow_back_ios, size: 30)),
      //   actions: [
      //     Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: Icon(Icons.call, size: 30))
      //   ],
      //   // iconTheme: IconThemeData(color: Colors.white,),
      //   title: Text(userInfo.nickname,
      //       style: Theme.of(context).textTheme.headline6.copyWith(
      //             fontWeight: FontWeight.w500,
      //           )),
      // ),
      body: ChatScreen(userInfo: userInfo),
    );
  }

  header(userInfo, context) {
    return AppBar(
      // backgroundColor: MaterialTheme.isUsingDark(context)
      //     ? Colors.grey[850]
      //     : Color(0xffF4F6FC),
      // leading: InkWell(
      //     onTap: () => Navigator.pop(context),
      //     child: Icon(Icons.arrow_back_ios_rounded, size: 28)),
      elevation: 0,
      // shadowColor: Colors.black,
      // actions: [
      //   Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Icon(Icons.call, size: 30, color: Colors.black),
      //   ),
      // ],
      title: InkWell(
        onTap: () {
          // Provider.of<BusinessProfileProvider>(context, listen: false)
          //   ..setBusinessId(vaTrue.getUserInfo().targetId)
          //   ..refresh(1);
          // Navigator.pushNamed(context, '/businessProfile');
        },
        child: Text(userInfo.nickname.toString().capitalize(),
            style: Theme.of(context).textTheme.headline6.copyWith()),
      ),
    );
  }
}
