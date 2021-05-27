import 'package:favorito_user/ui/business/BusinessProfileProvider.dart';
import 'package:favorito_user/ui/chat/ChatProvider.dart';
import 'package:favorito_user/ui/chat/ChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import '../../utils/Extentions.dart';

class Chat extends StatelessWidget {
  ChatProvider vaTrue;
  bool isFirst = true;
  @override
  Widget build(BuildContext context) {
    if (isFirst) {
      vaTrue = Provider.of<ChatProvider>(context, listen: true);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: NeumorphicTheme.isUsingDark(context)
            ? Colors.grey[850]
            : Color(0xffF4F6FC),
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios_rounded, size: 28)),
        elevation: .9,
        shadowColor: Colors.black,
        actions: [
          Icon(Icons.call, size: 30, color: Colors.black),
          Icon(Icons.call, size: 18, color: Colors.transparent)
        ],
        title: InkWell(
          onTap: () {
            Provider.of<BusinessProfileProvider>(context, listen: false)
              ..setBusinessId(vaTrue.getUserInfo().targetId)
              ..refresh(1);
            Navigator.pushNamed(context, '/businessProfile');
          },
          child: Text(vaTrue.getUserInfo().name.capitalize(),
              style: Theme.of(context).textTheme.headline6.copyWith()),
        ),
      ),
      body: ChatScreen(),
    );
  }
}
