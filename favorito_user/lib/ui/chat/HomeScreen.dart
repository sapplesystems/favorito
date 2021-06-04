import 'package:cached_network_image/cached_network_image.dart';
import 'package:favorito_user/component/circularProgress.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/Chat/User.dart';
import 'package:favorito_user/ui/Chat/ChatProvider.dart';
import 'package:favorito_user/ui/Chat/ChattingPage.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../../utils/MyString.dart';
import '../../utils/Extentions.dart';

class HomeScreen extends StatefulWidget {
  final String currentUserId;
  HomeScreen({Key key, @required this.currentUserId});
  @override
  State createState() => HomeScreenState(currentUserId: currentUserId);
}

class HomeScreenState extends State<HomeScreen> {
  TextEditingController searchTextEditingController = TextEditingController();

  final String currentUserId;
  HomeScreenState({Key key, @required this.currentUserId});
  ChatProvier vaTrue;

  SizeManager sm;
  bool isFirst = true;
  var vv;
  @override
  Widget build(BuildContext context) {
    if (isFirst) {
      isFirst = false;
      sm = SizeManager(context);
      vaTrue = Provider.of<ChatProvier>(context, listen: true);
      vaTrue.currentUserId = currentUserId;
      vaTrue.controlSearching("");
      vaTrue.initialCAll();
      vv = vaTrue.getabd();
      print("vLength:${vv.length}");
    }
    return SafeArea(
      child: Scaffold(
          body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text("Inbox",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.w500),
              textScaleFactor: 1.4),
        ),
        header(),
        Expanded(
          child: vv == null
              ? displayNoSerachResultScreen()
              : Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: vv.length <= 0
                      ? circularProgress()
                      : ListView(children: vv),
                ),
        )
      ])),
    );
  }

  displayNoSerachResultScreen() {
    return Center(
      child: ListView(shrinkWrap: true, children: [
        Icon(Icons.group,
            color: Colors.lightBlueAccent.withOpacity(.4), size: 200),
        Text("Search user",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6.copyWith(
                color: Colors.lightBlueAccent.withOpacity(.4),
                fontSize: 50,
                fontWeight: FontWeight.w500))
      ]),
    );
  }

  header() => Container(
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
                  vaTrue.notifyListeners();
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
                  // vaFalse.getSelectedTab() == title ? myRed :
                  myGrey)),
    );
  }

  // homePageHeader() {
  //   return AppBar(
  //     automaticallyImplyLeading: false,
  //     actions: [
  //       IconButton(
  //           icon: Icon(Icons.settings, size: 30.0, color: Colors.white),
  //           onPressed: () {
  //             Navigator.push(
  //                 context, MaterialPageRoute(builder: (context) => Settings()));
  //           })
  //     ],
  //     backgroundColor: Colors.lightBlue,
  //     title: Container(
  //       margin: EdgeInsets.only(bottom: 4.0),
  //       child: TextFormField(
  //         style: Theme.of(context)
  //             .textTheme
  //             .headline6
  //             .copyWith(fontSize: 18.0, color: Colors.white),
  //         controller: searchTextEditingController,
  //         decoration: InputDecoration(
  //             hintText: 'Search here..',
  //             hintStyle: Theme.of(context)
  //                 .textTheme
  //                 .headline6
  //                 .copyWith(color: Colors.white),
  //             enabledBorder: UnderlineInputBorder(
  //                 borderSide: BorderSide(color: Colors.grey)),
  //             focusedBorder: UnderlineInputBorder(
  //                 borderSide: BorderSide(color: Colors.white)),
  //             filled: true,
  //             prefixIcon: Icon(Icons.person_pin, color: Colors.white, size: 30),
  //             suffixIcon: IconButton(
  //                 icon: Icon(Icons.clear, color: Colors.white),
  //                 onPressed: emptyTextFormFirld)),
  //         onFieldSubmitted: controlSearching,
  //       ),
  //     ),
  //   );
  // }

  // void emptyTextFormFirld() {
  //   searchTextEditingController.clear();
  // }
}
