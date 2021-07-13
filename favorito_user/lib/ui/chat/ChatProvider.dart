import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorito_user/Providers/BaseProvider.dart';
import 'package:favorito_user/model/Chat/ChatUserList.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatProvider extends BaseProvider {
  SharedPreferences preferences;
  Future<QuerySnapshot> futureSearchResultsd;
  String _chatId = "";
  String id;
  String currentUserId;//this is firebase id
  List<ChatUser> serachUserResult =[];
  initialCAll() async {
    preferences = await SharedPreferences.getInstance();
    currentUserId = preferences.getString('firebaseId');
    print("currentUserId:${currentUserId}");
    // id = preferences.getString("id");//this is targeted person Id
    id = preferences.getString("targetId");//this is targeted person Id
    getChatConnectedList();
}

  // controlSearching(String userName) async {
  //   Future<QuerySnapshot> allFoundUsers = Firestore.instance
  //       .collection("user")
  //       // .where(Firestore.instance.collection('messages').document(_chatId).collection(_chatId))
  //       // .where("nickname", isGreaterThanOrEqualTo: userName)
  //       .getDocuments();

  //   futureSearchResultsd = allFoundUsers;
  //   serachUserResult.clear();
  //   futureSearchResultsd.then((value) {
  //     value.documents.forEach((document) {
  //       User eachUser = User.fromDocument(document);
  //       UserResult userResult = UserResult(eachUser);
  //       // removeUser(userResult);
  //       if (currentUserId != document["id"] &&
  //           !serachUserResult.contains(userResult)) {
  //         serachUserResult.add(userResult);
  //       }
  //       notifyListeners();
  //     });
  //   });
  //   // Future<QuerySnapshot> abc = Firestore.instance
  //   //     .collection('messages')
  //   //     .document(_chatId)
  //   //     .collection(_chatId)
  //   //     .getDocuments();
  //   // print(abc);
  // }



// }

getChatConnectedList()async{
  await APIManager.getChatConnectedList().then((value){
    if(value.status=="success"){
    serachUserResult.clear();
    serachUserResult.addAll(value.data);
    print("serachUserResult:${serachUserResult.length}");
    }
    notifyListeners();  
  });
}
    removeUser([userResult]) {
    _chatId = '$id-${userResult.eachUser.id}';
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
    await APIManager.emailRegister({'email': str});
  }

  sendFireBaseIdToServer(String str, key) async {
    await APIManager.setGetFirebaseId({'api_type': 'set', 'firebase_id': str});
  }

  // List<ChatUserList> getabd() {
  //   print("vLengths${serachUserResult.length}");
  //   return serachUserResult;
  // }

}
