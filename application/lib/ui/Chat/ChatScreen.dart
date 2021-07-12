import 'dart:io';

import 'package:Favorito/component/FullPhoto.dart';
import 'package:Favorito/component/Progress.dart';
import 'package:Favorito/model/Chat/ConnectionData.dart';
import 'package:Favorito/model/Chat/User.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  ConnectionData userInfo;
  ChatScreen({Key key, @required this.userInfo});
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final ScrollController listScrollController = ScrollController();
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  bool isDisplaySticker = false;
  bool isLoading = false;
  File imageFile;
  String imageUrl;

  String _chatId = "";
  String id;
  SharedPreferences preferences;
  var listMessage;
  @override
  void initState() {
    readLocal();
    super.initState();
    focusNode.addListener(onFocusChange);
  }

  readLocal() async {
    preferences = await SharedPreferences.getInstance();
    id = preferences.getString("firebaseId") ?? "";
    print("_chatid:${widget.userInfo.targetId}");
    var id2 = widget.userInfo.targetId;
    if (id.hashCode <= id2.hashCode) {
      _chatId = '$id-$id2';
    } else {
      _chatId = '$id2-$id';
    }
    print('_chatid:$_chatId');
    var va = Firestore.instance
        .collection('user')
        .document(id)
        .updateData({'chattingWith': widget.userInfo.id});
    setState(() {});
  }

  onFocusChange() {
    if (focusNode.hasFocus) {
      //hide stickers whenever keypad apear
      setState(() {
        isDisplaySticker = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
          child: Stack(children: [
            Column(children: [
              //create list of messages
              createListMessages(),

              //Show stickers
              Visibility(visible: isDisplaySticker, child: createStickers()),
              //Create input
              createInput(),
            ]),
            // createLoading()
          ]),
          onWillPop: onBackPress),
    );
  }

  createLoading() =>
      Positioned(child: isLoading ? circularProgress() : Container());

  Future<bool> onBackPress() {
    if (isDisplaySticker) {
      setState(() {
        isDisplaySticker = false;
      });
    } else {
      Navigator.pop(context);
    }
    return Future.value(false);
  }

  createStickers() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                  onPressed: () => onSendMessage("mimi1", 2),
                  child: Image.asset('images/mimi1.gif',
                      width: 50.0, height: 50, fit: BoxFit.cover)),
              FlatButton(
                  onPressed: () => onSendMessage("mimi2", 2),
                  child: Image.asset('images/mimi2.gif',
                      width: 50.0, height: 50, fit: BoxFit.cover)),
              FlatButton(
                  onPressed: () => onSendMessage("mimi3", 2),
                  child: Image.asset('images/mimi3.gif',
                      width: 50.0, height: 50, fit: BoxFit.cover)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                  onPressed: () => onSendMessage("mimi4", 2),
                  child: Image.asset('images/mimi4.gif',
                      width: 50.0, height: 50, fit: BoxFit.cover)),
              FlatButton(
                  onPressed: () => onSendMessage("mimi5", 2),
                  child: Image.asset('images/mimi5.gif',
                      width: 50.0, height: 50, fit: BoxFit.cover)),
              FlatButton(
                  onPressed: () => onSendMessage("mimi6", 2),
                  child: Image.asset('images/mimi6.gif',
                      width: 50.0, height: 50, fit: BoxFit.cover)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                  onPressed: () => onSendMessage("mimi7", 2),
                  child: Image.asset('images/mimi7.gif',
                      width: 50.0, height: 50, fit: BoxFit.cover)),
              FlatButton(
                  onPressed: () => onSendMessage("mimi8", 2),
                  child: Image.asset('images/mimi8.gif',
                      width: 50.0, height: 50, fit: BoxFit.cover)),
              FlatButton(
                  onPressed: () => onSendMessage("mimi9", 2),
                  child: Image.asset('images/mimi9.gif',
                      width: 50.0, height: 50, fit: BoxFit.cover)),
            ],
          )
        ],
      ),
    );
  }

  createListMessages() {
    return Flexible(
        child: _chatId == ""
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                ),
              )
            : StreamBuilder(
                stream: Firestore.instance
                    .collection("messages")
                    .document(_chatId)
                    .collection(_chatId)
                    .orderBy("timestamp", descending: true)
                    .limit(20)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.lightBlueAccent),
                      ),
                    );
                  } else {
                    listMessage = snapshot.data.documents;
                    return ListView.builder(
                      padding: EdgeInsets.all(10),
                      itemBuilder: (context, index) =>
                          createItem(index, snapshot.data.documents[index]),
                      itemCount: snapshot.data.documents.length,
                      reverse: true,
                      controller: listScrollController,
                    );
                  }
                },
              ));
  }

  Widget createItem(int index, DocumentSnapshot document) {
    //My Messages right side
    if (document["idFrom"] == id) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          document["type"] == 0
              ? Container(
                  //text msg
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  margin: EdgeInsets.only(
                      bottom: isLastMsgRight(index) ? 20 : 10, right: 10),
                  width: 200,
                  decoration: BoxDecoration(
                      color: myRed,
                      //  Colors.lightBlueAccent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      )),
                  child: Text(
                    document["content"],
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                )
              : document["type"] == 1
                  ? Container(
                      //image files
                      margin: EdgeInsets.only(
                          bottom: isLastMsgRight(index) ? 20 : 10, right: 10),
                      child: FlatButton(
                        child: Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.lightBlueAccent),
                              ),
                              width: 200,
                              height: 200,
                              padding: EdgeInsets.all(70),
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            errorWidget: (context, url, error) => Material(
                              borderRadius: BorderRadius.circular(8),
                              clipBehavior: Clip.hardEdge,
                              child: Image.asset(
                                'images/img_not_available.jpeg',
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            imageUrl: document["content"],
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          clipBehavior: Clip.hardEdge,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullPhoto(
                                url: document["content"],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Container(
                      //gif files
                      margin: EdgeInsets.only(
                          bottom: isLastMsgRight(index) ? 20 : 10, right: 10),
                      child: Image.asset(
                        "images/${document['content']}.gif",
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
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
              isLastMsgLeft(index)
                  ? Container(
                      //display reciever profile image
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.lightBlueAccent)),
                          width: 35,
                          height: 35,
                          padding: EdgeInsets.all(70),
                        ),
                        imageUrl: widget.userInfo.photo,
                        width: 35,
                        height: 35,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(18))),
                      clipBehavior: Clip.hardEdge,
                    )
                  : Container(width: 35),
              //display text msg
              (document["type"] == 0)
                  ? Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                      margin: EdgeInsets.only(left: 10),
                      width: 200,
                      decoration: BoxDecoration(
                          color: myRed.withOpacity(.09),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25),
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          )),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 9,
                            child: Text(
                              document["content"],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Text(
                            DateFormat("hh:mm:aa").format(
                                DateTime.fromMillisecondsSinceEpoch(int.parse(
                                    document["timestamp"].toString()))),
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 8,
                                color: Colors.grey[800]),
                          ),
                        ],
                      ))
                  : document["type"] == 1
                      ? Container(
                          //image files
                          margin: EdgeInsets.only(left: 10),
                          child: FlatButton(
                            child: Material(
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.lightBlueAccent),
                                  ),
                                  width: 200,
                                  height: 200,
                                  padding: EdgeInsets.all(70),
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                errorWidget: (context, url, error) => Material(
                                  borderRadius: BorderRadius.circular(8),
                                  clipBehavior: Clip.hardEdge,
                                  child: Image.asset(
                                    'images/img_not_available.jpeg',
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                imageUrl: document["content"],
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              clipBehavior: Clip.hardEdge,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullPhoto(
                                    url: document["content"],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Container(
                          //gif files
                          margin: EdgeInsets.only(
                              bottom: isLastMsgLeft(index) ? 20 : 10,
                              right: 10),
                          child: Image.asset(
                              "images/${document['content']}.gif",
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover),
                        ),
            ],
          ),
          isLastMsgLeft(index)
              ? Container(
                  margin: EdgeInsets.only(left: 50, top: 10, bottom: 50),
                  child: Text(
                    DateFormat("dd MMM, yyyy, hh:mm:aa").format(
                      DateTime.fromMillisecondsSinceEpoch(
                        int.parse(document["timestamp"].toString()),
                      ),
                    ),
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                        color: Colors.grey),
                  ),
                )
              : Container()
        ]),
      );
    }
  }

  createInput() {
    return Container(
      child: Row(
        children: [
          //pick image icon button
          // Material(
          //   child: Container(
          //     margin: EdgeInsets.only(left: .5),
          //     child: IconButton(
          //       icon: Icon(Icons.image, color: Colors.lightBlueAccent),
          //       onPressed: () => getImage(true),
          //       color: Colors.white,
          //     ),
          //   ),
          //   color: Colors.white,
          // ),
          //imoji icon button placeholder
          InkWell(
            onTap: () => getImage(true),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: SvgPicture.asset(
                'assets/icon/placeholder.svg',
                color: myRed,
                fit: BoxFit.cover,
                height: 22,
              ),
            ),
          ),
          InkWell(
            onTap: () => getImage(false),
            child: Container(
              margin: EdgeInsets.only(right: 16),
              child: SvgPicture.asset('assets/icon/camera.svg',
                  color: myRed, fit: BoxFit.cover, height: 20),
            ),
          ),
          Flexible(
            child: Container(
              child: TextField(
                  decoration: InputDecoration.collapsed(
                      hintText: 'Write here...',
                      hintStyle: TextStyle(color: Colors.grey)),
                  controller: textEditingController,
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                  focusNode: focusNode),
            ),
          ),
          //send icon button
          Container(
              child: IconButton(
            color: Colors.white,
            icon: Icon(Icons.send, color: myRed),
            onPressed: () => onSendMessage(textEditingController.text, 0),
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

  void getStickers() {
    focusNode.unfocus();
    setState(() {
      isDisplaySticker = !isDisplaySticker;
    });
  }

  getImage(bool _val) async {
    imageFile = await ImagePicker.pickImage(
        source: _val ? ImageSource.gallery : ImageSource.camera);
    if (imageFile != null) {
      isLoading = false;
    }
    uploadImageFile();
  }

  uploadImageFile() async {
    String filename = DateTime.now().microsecondsSinceEpoch.toString();
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child("Chat Images").child(filename);
    StorageUploadTask storageUploadTask = storageReference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    }, onError: (error) {
      setState(() {
        isLoading = false;
        Fluttertoast.showToast(msg: "Error:${error.toString()}");
      });
    });
  }

  void onSendMessage(String contentMsg, int type) async {
    //type = 0 its text message
    //type = 1 its text imageFile
    //type = 2 its text sticker imoji gif
    if (contentMsg != "") {
      textEditingController.clear();
      var docRef = Firestore.instance
          .collection("messages")
          .document(_chatId)
          .collection(_chatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(docRef,{
          "idFrom": id,
          "idTo": widget.userInfo.id,
          "timestamp": DateTime.now().millisecondsSinceEpoch,
          "content": contentMsg,
          "type": type
        });
      });
      listScrollController.animateTo(0.0,
          duration: Duration(microseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: "Empty Message,Cant send");
    }
  }

  bool isLastMsgRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]["idFrom"] != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMsgLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]["idFrom"] == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }
}
