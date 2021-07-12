import 'package:Favorito/Provider/BaseProvider.dart';
import 'package:Favorito/model/Chat/ConnectionData.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/Chat/UserResult.dart';
import 'package:Favorito/utils/RIKeys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatProvier extends BaseProvider {
TextEditingController searchTextEditingController = TextEditingController();  
  SharedPreferences preferences;
  List<ConnectionData> connectionsList=[];
  String _chatId = "";
  String id;
  String currentUserId;

  List<UserResult> serachUserResult = [];
  initialCAll() async {
    preferences = await SharedPreferences.getInstance();
    currentUserId = preferences.getString("firebaseId");
    print("currentUserId:${currentUserId}");
    // id = preferences.getString("id");//this is targeted person Id
    id = preferences.getString("targetId");
    getChatConnectedList();
  }

getChatConnectedList()async{
  await WebService.getFirebaseConnectedList().then((value){
    if(value.status=="success"){
      connectionsList.clear();
      connectionsList.addAll(value.data);
      print("serachUserResult:${serachUserResult.length}");
    }
    notifyListeners();
  });
}


  controlSearching(String userName) async {
    // print("userName$userName");
    // Future<QuerySnapshot> allFoundUsers = Firestore.instance
    //     .collection("user")
    //     .where("nickname", isGreaterThanOrEqualTo: userName)
    //     .getDocuments();

// await WebService.getFirebaseConnectedList(RIKeys.josKeys29).then((value) {
// connectionsList.clear();
//   connectionsList.addAll(value.data);
    //   serachUserResult.forEach((document) {
    //      ConnectionData eachUser= UserResult(eachUser);
    //     removeUser(userResult);
    //     if (currentUserId != document["id"] &&
    //         !serachUserResult.contains(userResult)) {
    //       serachUserResult.add(UserResult(eachUser));
    //       notifyListeners();
    //     }
    // });
// });
   }

  removeUser([userResult]) {
    _chatId = '$currentUserId-${userResult.eachUser.id}';
    Firestore.instance
        .collection("messages")
        .document(_chatId)
        .collection(_chatId)
        .limit(1)
        .getDocuments()
        .then((value) {
      if (value.documents.isEmpty) {
        // serachUserResult.remove(userResult);
      }
      notifyListeners();
    });
  }

  sendEmailToserver(String str, key) async {
    // await WebService.setGetFirebaseId({'api_type': 'set', 'firebase_id': str});
  }

  sendFireBaseIdToServer(String str, key) async {
    await WebService.setGetFirebaseId({'api_type': 'set', 'firebase_id': str});
  }

  
   void emptyTextFormFirld() {
    searchTextEditingController.clear();
    controlSearching('');
  }
}
