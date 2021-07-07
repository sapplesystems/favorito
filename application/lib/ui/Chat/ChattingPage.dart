import 'package:Favorito/model/Chat/ConnectionData.dart';
import 'package:Favorito/ui/Chat/ChatScreen.dart';
import 'package:flutter/material.dart';
import '../../utils/Extentions.dart';

class Chat extends StatelessWidget {
  ConnectionData userInfo;
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
      elevation: 0,
      title: InkWell(
        onTap: () {},
        child: Text('${userInfo.name}'.capitalize(),
            style: Theme.of(context).textTheme.headline6.copyWith()),
      ),
    );
  }
}
