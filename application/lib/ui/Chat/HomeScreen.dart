import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/ui/Chat/ChatProvider.dart';
import 'package:Favorito/ui/Chat/UserResult.dart';
import 'package:Favorito/utils/RIKeys.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  
  SizeManager sm;
  bool isFirst = true;
  var vv;
  @override
  Widget build(BuildContext context) {
    

    return SafeArea(
      child: Scaffold(
        key: RIKeys.josKeys29,
          body: 
          Consumer<ChatProvier>(builder: (context,_data,child){
            if (isFirst) {
      isFirst = false;
      sm = SizeManager(context);
      _data.initialCAll();
    }
            return Column(children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text("Inbox",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontWeight: FontWeight.w500),
                  textScaleFactor: 1.2),
            ),
            InkWell(
              onTap: (){
                _data.controlSearching('');
              },
              child: Icon(
                Icons.refresh,
                color: Colors.black,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        homePageHeader(_data),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text("All Chats",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.w500),
              textScaleFactor: 1),
        ),
        Expanded(
          child: _data.connectionsList.isEmpty
              ? displayNoSerachResultScreen()
              : Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: _data.connectionsList.isEmpty
                      // ? circularProgress()
                      ? displayNoSerachResultScreen()
                      : ListView.builder(
                        itemCount: _data.connectionsList.length,
                        itemBuilder: (context,index){
                          return UserResult(_data.connectionsList[index]);
                        }),
                ),
        )
      ]);
          },)
      ),
    
    
    );
  }

  displayNoSerachResultScreen() {
    return Center(
      child: ListView(shrinkWrap: true, children: [
        Icon(Icons.group, color: myRed.withOpacity(.1), size: 200),
        Text("Search user",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6.copyWith(
                color: myRed.withOpacity(.1),
                fontSize: 50,
                fontWeight: FontWeight.w500))
      ]),
    );
  }

  // header() => Container(
  //       // width: sm.w(100),
  //       margin: EdgeInsets.symmetric(vertical: 20),
  //       alignment: Alignment.center,
  //       child: SizedBox(
  //         width: sm.w(60),
  //         child: Card(
  //           elevation: 8,
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(12.0))),
  //           child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
  //             InkWell(
  //               onTap: () {
  //                 isFirst = true;
  //                 vaTrue.notifyListeners();
  //               },
  //               child: newHistory(message.toString().capitalize()),
  //             ),
  //             InkWell(
  //               onTap: () {},
  //               child: newHistory(notification.toString().capitalize()),
  //             ),
  //           ]),
  //         ),
  //       ),
  //     );

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

  homePageHeader(_data) {
    return AppBar(
      automaticallyImplyLeading: false,
      // actions: [
      //   IconButton(
      //       icon: Icon(Icons.settings, size: 30.0, color: Colors.white),
      //       onPressed: () {
      //         Navigator.push(
      //             context, MaterialPageRoute(builder: (context) => Settings()));
      //       })
      // ],
      title: Card(
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 4.0),
        child: TextFormField(
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(fontSize: 18.0, fontWeight: FontWeight.w400),
          controller: _data.searchTextEditingController,
          decoration: InputDecoration(
              hintText: 'Search ',
              hintStyle: Theme.of(context).textTheme.headline6.copyWith(
                  color: myGrey, fontWeight: FontWeight.w400, fontSize: 18),
              enabledBorder: InputBorder.none,
              filled: true,
              focusedBorder: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.black, size: 30),
              suffixIcon: IconButton(
                  icon: Icon(Icons.clear, color: Colors.black),
                  onPressed: _data.emptyTextFormFirld)),
          onFieldSubmitted: (_val) => _data.controlSearching(_val),
        ),
      ),
    );
  }

 
}
