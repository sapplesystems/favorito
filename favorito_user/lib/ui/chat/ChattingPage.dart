import 'package:favorito_user/model/Chat/ChatUserList.dart';
import 'package:favorito_user/ui/Chat/ChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../../utils/Extentions.dart';
class Chat extends StatelessWidget {
  ChatUser userInfo;
  Chat({Key key, @required this.userInfo});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(userInfo, context),
      body: ChatScreen(userInfo: userInfo),
    );
  }

  header(userInfo, context) {
    return AppBar(
      backgroundColor: NeumorphicTheme.isUsingDark(context)
          ? Colors.grey[850]
          : Color(0xffF4F6FC),
      leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_rounded, size: 28)),
      elevation: .9,
      shadowColor: Colors.black,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.call, size: 30, color: Colors.black),
        ),
      ],
      title: InkWell(
        onTap: () {
          // Provider.of<BusinessProfileProvider>(context, listen: false)
          //   ..setBusinessId(userInfo.id)
          //   ..refresh(1);
          // Navigator.pushNamed(context, '/businessProfile');
        },
        child: Text('${userInfo.name}'.capitalize(),
            style: Theme.of(context).textTheme.headline6.copyWith()),
      ),
    );
  }
}
