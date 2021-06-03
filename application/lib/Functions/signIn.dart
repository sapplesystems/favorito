import 'package:Favorito/ui/claim/ClaimProvider.dart';
import 'package:Favorito/ui/setting/setting/SettingProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

initFirebase(firebaseUser, key) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  //Signin Success
  if (firebaseUser != null) {
    //check if already signedUp
    final QuerySnapshot resultQuery = await Firestore.instance
        .collection("user")
        .where("id", isEqualTo: firebaseUser.uid)
        .getDocuments();
    final List<DocumentSnapshot> documentSnapshots = resultQuery.documents;
    //Save dota to firebase if new user
    if (documentSnapshots.length == 0) {
      Firestore.instance.collection("user").document(firebaseUser.uid).setData({
        "nickname": preferences.getString('nickname'),
        "photoUrl": preferences.getString('photoUrl'),
        "id": firebaseUser.uid,
        "aboutMe": "I am using favorito",
        "phone": firebaseUser.phoneNumber,
        "createAt": DateTime.now().microsecondsSinceEpoch.toString(),
        "chattingWith": null,
      });
      //Write data to Local

      await preferences.setString("id", firebaseUser.uid);
      await preferences.setString("phone", firebaseUser.phoneNumber);
      await preferences.setString("nickname", firebaseUser.displayName);
      await preferences.setString("photoUrl", firebaseUser.photoUrl);
    } else {
      //Write data to Local
      await preferences.setString("id", documentSnapshots[0]["id"]);
      await preferences.setString("nickname", documentSnapshots[0]["nickname"]);
      await preferences.setString("phone", documentSnapshots[0]["phone"]);
      await preferences.setString("photoUrl", documentSnapshots[0]["photoUrl"]);
      await preferences.setString("aboutMe", documentSnapshots[0]["aboutMe"]);
      // await preferences.setString("id", documentSnapshots[0]["id"]);
    }
    Provider.of<ClaimProvider>(key.currentContext, listen: false)
        .isOtpSendSet(false);
    Fluttertoast.showToast(msg: "Congratulations, Sign in Successful.");
    // this.setState(() {
    //   isLoading = false;
    // });

    // Navigator.pop(context);
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) =>
    //             HomeScreen(currentUserId: firebaseUser.uid)));
  }
  //SignIn not success

  else {
    Fluttertoast.showToast(msg: 'Try again , Sign in Failed');
  }
}
