import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:favorito_user/model/Chat/ChatModel.dart';
import 'package:favorito_user/model/Chat/ChatModelData.dart';
import 'package:favorito_user/model/Chat/UserModel.dart';
import 'package:favorito_user/services/function.dart';
import 'package:favorito_user/ui/chat/ChatProvider.dart';
import 'package:favorito_user/utils/Prefs.dart';
import 'package:favorito_user/utils/RIKeys.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatProvider vaTrue;
  SharedPreferences preferences;

  var listMessage;

  bool isFirst = true;

  @override
  Widget build(BuildContext context) {
    if (isFirst) {
      isFirst = false;
      vaTrue = Provider.of<ChatProvider>(context, listen: true);
      vaTrue
        ..readLocal()
        ..chatModelData.clear();
      vaTrue.getChathistory();
    }

    return SafeArea(
      child: WillPopScope(
          child: Stack(children: [
            Column(children: [
              //create list of messages
              createListMessages(),

              //Show stickers
              // Visibility(visible: isDisplaySticker, child: createStickers()),
              //Create input
              createInput(),
            ]),
            vaTrue.createLoading()
          ]),
          onWillPop: () => vaTrue.onBackPress(context)),
    );
  }

  createListMessages() {
    List<ChatModelData> chatModelData = vaTrue.getChatModelData();
    print("1213:${chatModelData.length}");
    return Flexible(
        child: chatModelData.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                ),
              )
            :
            //       StreamBuilder(
            // stream: vaTrue.getChat(),
            // builder: (context, snapshot) {
            //   if (!snapshot.hasData) {
            // return

            // } else {
            // return
            ListView.builder(
                padding: EdgeInsets.all(10),
                itemBuilder: (context, index) =>
                    createItem(index, chatModelData[index]),
                itemCount: chatModelData.length,
                reverse: true,
                controller: vaTrue.listScrollController,
              )
        // }
        // },
        // )
        );
  }

  Widget createItem(int index, ChatModelData document) {
    //My Messages right side
    UserData _v = vaTrue.getUserInfo();
    if (_v.targetId != document.targetId) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // document["type"] == 0
          // ?
          Container(
            //text msg
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            margin: EdgeInsets.only(
                bottom: isLastMsgRight(index) ? 20 : 10, right: 10),
            width: 200,
            decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(15.0)),
            child: Text(
              "${document.message} - ${document.id}",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          )
          // : document["type"] == 1
          //     ? Container(
          //         //image files
          //         margin: EdgeInsets.only(
          //             bottom: isLastMsgRight(index) ? 20 : 10, right: 10),
          //         child: FlatButton(
          //           child: Material(
          //             child: CachedNetworkImage(
          //               placeholder: (context, url) => Container(
          //                 child: CircularProgressIndicator(
          //                   valueColor: AlwaysStoppedAnimation<Color>(
          //                       Colors.lightBlueAccent),
          //                 ),
          //                 width: 200,
          //                 height: 200,
          //                 padding: EdgeInsets.all(70),
          //                 decoration: BoxDecoration(
          //                     color: Colors.grey,
          //                     borderRadius: BorderRadius.circular(8)),
          //               ),
          //               errorWidget: (context, url, error) => Material(
          //                 borderRadius: BorderRadius.circular(8),
          //                 clipBehavior: Clip.hardEdge,
          //                 child: Image.asset(
          //                   'images/img_not_available.jpeg',
          //                   width: 200,
          //                   height: 200,
          //                   fit: BoxFit.cover,
          //                 ),
          //               ),
          //               imageUrl: document["content"],
          //               width: 200,
          //               height: 200,
          //               fit: BoxFit.cover,
          //             ),
          //             borderRadius: BorderRadius.circular(8),
          //             clipBehavior: Clip.hardEdge,
          //           ),
          //           onPressed: () {
          //             // Navigator.push(
          //             //   context,
          //             //   MaterialPageRoute(
          //             //     builder: (context) => FullPhoto(
          //             //       url: document["content"],
          //             //     ),
          //             //   ),
          //             // );
          //           },
          //         ),
          //       )
          //     : Container(
          //         //gif files
          //         margin: EdgeInsets.only(
          //             bottom: isLastMsgRight(index) ? 20 : 10, right: 10),
          //         child: Image.asset(
          //           "images/${document['content']}.gif",
          //           width: 100,
          //           height: 100,
          //           fit: BoxFit.cover,
          //         ),
          //       ),
        ],
      );
    }
    //reciever messages leftSide
    else {
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              // isLastMsgLeft(index)
              // ? Container(
              //     //display reciever profile image
              //     child: CachedNetworkImage(
              //       placeholder: (context, url) => Container(
              //         child: CircularProgressIndicator(
              //             valueColor: AlwaysStoppedAnimation<Color>(
              //                 Colors.lightBlueAccent)),
              //         width: 35,
              //         height: 35,
              //         padding: EdgeInsets.all(70),
              //       ),
              //       imageUrl: widget.userInfo.photo,
              //       width: 35,
              //       height: 35,
              //     ),
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.all(Radius.circular(18))),
              //     clipBehavior: Clip.hardEdge,
              //   )
              // : Container(width: 35),
              //display text msg
              // (document["type"] == 0)
              //     ?
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                  margin: EdgeInsets.only(left: 10),
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 9,
                          child: Text(
                            document.message,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        // Text(
                        //   DateFormat("hh:mm:aa").format(
                        //       DateTime.fromMillisecondsSinceEpoch(
                        //           int.parse(document.createdAt.toString()))),
                        //   style: TextStyle(
                        //       fontStyle: FontStyle.italic,
                        //       fontSize: 8,
                        //       color: Colors.grey[800]),
                        // ),
                      ]))
              // : document["type"] == 1
              //     ? Container(
              //         //image files
              //         margin: EdgeInsets.only(left: 10),
              //         child: FlatButton(
              //           child: Material(
              //             child: CachedNetworkImage(
              //               placeholder: (context, url) => Container(
              //                 child: CircularProgressIndicator(
              //                   valueColor: AlwaysStoppedAnimation<Color>(
              //                       Colors.lightBlueAccent),
              //                 ),
              //                 width: 200,
              //                 height: 200,
              //                 padding: EdgeInsets.all(70),
              //                 decoration: BoxDecoration(
              //                     color: Colors.grey,
              //                     borderRadius: BorderRadius.circular(8)),
              //               ),
              //               errorWidget: (context, url, error) => Material(
              //                 borderRadius: BorderRadius.circular(8),
              //                 clipBehavior: Clip.hardEdge,
              //                 child: Image.asset(
              //                   'images/img_not_available.jpeg',
              //                   width: 200,
              //                   height: 200,
              //                   fit: BoxFit.cover,
              //                 ),
              //               ),
              //               imageUrl: document["content"],
              //               width: 200,
              //               height: 200,
              //               fit: BoxFit.cover,
              //             ),
              //             borderRadius: BorderRadius.circular(8),
              //             clipBehavior: Clip.hardEdge,
              //           ),
              //           onPressed: () {
              //             // Navigator.push(
              //             //   context,
              //             //   MaterialPageRoute(
              //             //     builder: (context) => FullPhoto(
              //             //       url: document["content"],
              //             //     ),
              //             //   ),
              //             // );
              //           },
              //         ),
              //       )
              //     : Container(
              //         //gif files
              //         margin: EdgeInsets.only(
              //             bottom: isLastMsgLeft(index) ? 20 : 10,
              //             right: 10),
              //         child: Image.asset(
              //             "images/${document['content']}.gif",
              //             width: 100,
              //             height: 100,
              //             fit: BoxFit.cover),
              //       ),
            ],
          ),
          // isLastMsgLeft(index)
          //     ? Container(
          //         margin: EdgeInsets.only(left: 50, top: 10, bottom: 50),
          //         child: Text(
          //           DateFormat("dd MMM, yyyy, hh:mm:aa").format(
          //             DateTime.fromMillisecondsSinceEpoch(
          //               int.parse(document.createdAt.toString()),
          //             ),
          //           ),
          //           style: TextStyle(
          //               fontStyle: FontStyle.italic,
          //               fontSize: 12,
          //               color: Colors.grey),
          //         ),
          //       )
          //     : Container()
        ]),
      );
    }
  }

  createInput() {
    return Container(
      child: Row(
        children: [
          //pick image icon button
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image, color: Colors.lightBlueAccent),
                onPressed: vaTrue.getImage,
                color: Colors.white,
              ),
            ),
            color: Colors.white,
          ),

          //imoji icon button
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.face, color: Colors.lightBlueAccent),
                onPressed: vaTrue.getStickers,
                color: Colors.white,
              ),
            ),
            color: Colors.white,
          ),
          Flexible(
            child: Container(
              child: TextField(
                decoration: InputDecoration.collapsed(
                    hintText: 'Write here...',
                    hintStyle: TextStyle(color: Colors.grey)),
                controller: vaTrue.textEditingController,
                style: TextStyle(color: Colors.black, fontSize: 15.0),
                focusNode: vaTrue.focusNode,
              ),
            ),
          ),
          //send icon button
          Container(
              child: IconButton(
            color: Colors.white,
            icon: Icon(Icons.send, color: Colors.lightBlueAccent),
            // onPressed: () => onSendMessage(textEditingController.text, 0),
          ))
        ],
      ),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
          // borderRadius: BorderRadius.all(Radius.circular(0)),
          border: Border(
            top: BorderSide(color: Colors.white, width: 0.5),
          ),
          color: Colors.white),
    );
  }

  bool isLastMsgRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]["idFrom"] != vaTrue.roomId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMsgLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]["idFrom"] == vaTrue.roomId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }
}
