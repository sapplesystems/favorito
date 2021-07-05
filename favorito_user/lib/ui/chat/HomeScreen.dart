import 'package:favorito_user/component/circularProgress.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/ui/chat/ChatProvider.dart';
import 'package:favorito_user/ui/chat/UserResult.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/RIKeys.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../../utils/MyString.dart';
import '../../utils/Extentions.dart';

class HomeScreen extends StatelessWidget {
  
  String currentUserId;
  SizeManager sm;
  bool isFirst = true;
  @override
  Widget build(BuildContext context) {
    // if (isFirst) {
    //   isFirst = false;
      sm = SizeManager(context);
      context.read<ChatProvider>().initialCAll();
    // }
      
    return SafeArea(
      child: Scaffold(
        key: RIKeys.josKeys31,
          body:Consumer<ChatProvider>(builder:(context,data,child){
            return Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text("Inbox",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontWeight: FontWeight.w500),
                    textScaleFactor: 1.4),
              ),
              header(data),
              Expanded(
                child: data.serachUserResult.isEmpty
                    ? displayNoSerachResultScreen(): Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: data.serachUserResult.isEmpty
                      ? circularProgress()
                      :
                  ListView.builder(
                    itemCount: data.serachUserResult.length,
                    itemBuilder: (context,index){
                      return UserResult(data.serachUserResult[index]);
                    },
                  ),
                ),
              )
            ]);

          },)
          ),
      //
    );
  }

  displayNoSerachResultScreen() {
    return Center(
      child: ListView(shrinkWrap: true, children: [
        Icon(Icons.group,
            color: Colors.lightBlueAccent.withOpacity(.4), size: 200),
        Text("Search user",
            textAlign: TextAlign.center,
            style: Theme.of(RIKeys.josKeys31.currentContext).textTheme.headline6.copyWith(
                color: Colors.lightBlueAccent.withOpacity(.4),
                fontSize: 50,
                fontWeight: FontWeight.w500))
      ]),
    );
  }

  header(data) => Container(
        // width: sm.w(100),
        margin: EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        child: SizedBox(
          width: sm.w(60),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              InkWell(
                onTap: () {
                  isFirst = true;
                  data.initialCAll();
                },
                child: newHistory(message.toString().capitalize()),
              ),
              InkWell(
                onTap: () {},
                child: newHistory(notification.toString().capitalize()),
              ),
            ]),
          ),
        ),
      );

  newHistory(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16.0),
      child: Text(title,
          style: TextStyle(
              fontSize: 14.0,
              color:
                  myGrey)),
    );
  }
}
