import 'package:Favorito/Provider/BaseProvider.dart';
import 'package:Favorito/model/Chat/User.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/Chat/UserResult.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatProvier extends BaseProvider {
  SharedPreferences preferences;
  Future<QuerySnapshot> futureSearchResultsd;
  String _chatId = "";
  // String id;
  String currentUserId;

  List<UserResult> serachUserResult = [];
  initialCAll() async {
    preferences = await SharedPreferences.getInstance();
    currentUserId = preferences.getString("id");
  }

  controlSearching(String userName) async {
    print("userName$userName");
    Future<QuerySnapshot> allFoundUsers = Firestore.instance
        .collection("user")
        .where("nickname", isGreaterThanOrEqualTo: userName)
        .getDocuments();

    futureSearchResultsd = allFoundUsers;
    serachUserResult.clear();
    futureSearchResultsd.then((value) {
      value.documents.forEach((document) {
        User eachUser = User.fromDocument(document);
        UserResult userResult = UserResult(eachUser);
        removeUser(userResult);
        if (currentUserId != document["id"] &&
            !serachUserResult.contains(userResult)) {
          serachUserResult.add(UserResult(eachUser));
          notifyListeners();
        }
      });
    });
    // Future<QuerySnapshot> abc = Firestore.instance
    //     .collection('messages')
    //     .document(_chatId)
    //     .collection(_chatId)
    //     .getDocuments();
    // print(abc);
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

  List getabd() {
    print("vLengths${serachUserResult.length}");
    return serachUserResult;
  }
}
